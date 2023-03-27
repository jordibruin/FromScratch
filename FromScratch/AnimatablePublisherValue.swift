//
//  AnimatablePublisherValue.swift
//
//  MIT License
//
//  Copyright (c) 2023 Pierre Tacchi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import SwiftUI
import Combine

struct AnimatablePublisherValue<P: Publisher>: ViewModifier where P.Failure == Never {
    @State private var signal = false
    
    let animation: Animation?
    let publisher: P
    
    func body(content: Content) -> some View {
        content
            .animation(animation, value: signal)
            .onReceive(publisher, perform: { _ in signal.toggle() })
    }
}

extension View {
    func animation<P: Publisher>(_ animation: Animation?, publisher: P) -> some View where P.Failure == Never {
        modifier(AnimatablePublisherValue(animation: animation, publisher: publisher))
    }
    
    func animation<O: ObservableObject>(_ animation: Animation?, observed: O) -> some View {
        modifier(AnimatablePublisherValue(animation: animation, publisher: observed.objectWillChange))
    }
}
