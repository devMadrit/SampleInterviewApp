//
//  MutableLiveData.swift
//  SampleViewModel
//
//  Created by Kacabumi Madrit on 5.10.20.
//  Copyright © 2020 SampleViewModel. All rights reserved.
//

import Foundation

public typealias MutableLiveDataCallback<T> = (_ value: T?) -> Void

public final class MutableLiveData<T> where T : Any {
    
    /**
     The array containing all observers references
     */
    private var listenerItems = [MutableLiveDataObserver<T>]()
    
    /**
     The current store of Generic `T`  type value.
     This will store the value in a private place,
     in case we need to update the value without notifying all observers.
     
     # Reference: post(_ value: T?, notify: Bool = true)
     */
    private var _value: T?
    
    /**
     The current value of Generic `T`  type.
     Setting the value accessing the `value` property will trigger the observers
     in the current thread the `value = T` value to take place.
     
     # Reference: post(_ value: T?, notify: Bool = true)
     */
    public var value: T? {
        set {
            self._value = newValue
            listenerItems = listenerItems.compact()
            for case let listenerItem in listenerItems where listenerItem.callback != nil  {
                listenerItem.fire(value: self.value)
            }
        }
        
        get {
            return _value
        }
    }
    
    /**
     Init a MutableLiveData object
     - Parameter value: The initial value, if have one. default will be nil.
     */
    init(value: T? = nil) {
        self._value = value
    }
    
    ///
    /// Update the value and notify all observers in their required `DispatchQueue` provided in `MutableLiveDataObserver` object
    /// currently store in the array of listeners.
    ///- Parameter value: the value of type `T` you want to update and notify.
    ///
    public func post(_ value: T?) {
        self._value = value
        listenerItems = listenerItems.compact()
        for case let listenerItem in listenerItems where listenerItem.callback != nil  {
            listenerItem.dispatchQueue.async {
                listenerItem.fire(value: self._value)
            }
        }
    }
    
    ///
    /// Add an observer object to the array of MutableLiveDataObserver.
    ///- Parameter bound: **Very Important** this bond will be used a reference when compacting the listener item.
    ///     Example : if you provide the viewcontroller instance as a bound, than the observer will stay as long as the ViewController is alive. Avoid using an object that normally stays alive all the time or
    ///     the reference will not be removed once compact functions are called.
    ///
    public func addObserver(bound: AnyObject?, dispatchQueue: DispatchQueue = .main, autoFire: Bool = false, mutableLiveDataCallback: MutableLiveDataCallback<T>?){
        listenerItems = listenerItems.compact()
        let observer = MutableLiveDataObserver(bound: bound, callback: mutableLiveDataCallback, dispatchQueue: dispatchQueue)
        listenerItems.append(observer)
        if autoFire {
            observer.fire(value: _value)
        }
    }
    
    ///
    /// Update the value without trigering the observers
    /// Parameter value: the value of type `T` you want to update.
    ///
    public func postSilently(_ value: T?) {
        self._value = value
    }
}

class MutableLiveDataObserver<T> where T : Any {
    
    weak var mBound: AnyObject?
    var dispatchQueue: DispatchQueue
    var callback: MutableLiveDataCallback<T>?
    
    init(bound: AnyObject?, callback: MutableLiveDataCallback<T>?, dispatchQueue: DispatchQueue){
        self.mBound = bound
        self.callback = callback
        self.dispatchQueue = dispatchQueue
    }
    
    deinit {
        mBound = nil
        callback = nil
    }
}

extension MutableLiveDataObserver: MyGenericStructProtocol {
    typealias GenericType = T
    
    var bound: Any? {
        return mBound
    }
    
    func fire(value: T?) {
        callback?(value)
    }
}

extension Array where Element : MyGenericStructProtocol {
    
    internal func compact() -> [Element] {
        return filter{$0.bound != nil}
    }
}

protocol MyGenericStructProtocol: class {
    associatedtype GenericType
    var bound: Any? { get }
}
