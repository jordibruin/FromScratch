//
//  ViewExtension.swift
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

extension View {
    @available(*, deprecated, message: "Please pass one or more parameters.")
    func width() -> Self { self }
    
    /// Sets the view's width.
    func width(_ width: CGFloat?, alignment: HorizontalAlignment = .center) -> some View {
        frame(width: width, alignment: alignment.combined(with: .center))
    }
    
    /// Sets the view's min, max and ideal widths.
    func width(min: CGFloat? = nil, ideal: CGFloat? = nil, max: CGFloat? = nil, alignment: HorizontalAlignment = .center) -> some View {
        frame(minWidth: min, idealWidth: ideal, maxWidth: max, alignment: alignment.combined(with: .center))
    }
    
    /// Makes the view expend horizontally
    func expandWidth(alignment: HorizontalAlignment = .center) -> some View {
        frame(maxWidth: .infinity, alignment: alignment.combined(with: .center))
    }
    
    @available(*, deprecated, message: "Please pass one or more parameters.")
    func height() -> Self { self }
    
    /// Sets the view's heights.
    func height(_ height: CGFloat?, alignment: VerticalAlignment = .center) -> some View {
        frame(height: height, alignment: alignment.combined(with: .center))
    }
    /// Sets the view's min, max and ideal height.
    func height(min: CGFloat? = nil, ideal: CGFloat? = nil, max: CGFloat? = nil, alignment: VerticalAlignment = .center) -> some View {
        frame(minHeight: min, idealHeight: ideal, maxHeight: max, alignment: alignment.combined(with: .center))
    }
    
    func frame(size: CGSize?, alignment: Alignment = .center) -> some View {
        frame(width: size?.width, height: size?.height, alignment: alignment)
    }
    
    func frame(square amount: CGFloat, alignment: Alignment = .center) -> some View {
        frame(size: .init(width: amount, height: amount), alignment: alignment)
    }
    
    func frame(minSize: CGSize? = nil, idealSize: CGSize? = nil, maxSize: CGSize? = nil, alignment: Alignment = .center) -> some View {
        frame(minWidth: minSize?.width, idealWidth: idealSize?.width, maxWidth: maxSize?.width, minHeight: minSize?.height, idealHeight: idealSize?.height, maxHeight: maxSize?.height, alignment: alignment)
    }
    
    func frame(_ width: CGFloat? = nil, _ height: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        frame(width: width, height: height, alignment: alignment)
    }
    
    /// Makes the view expend vertically.
    func expandHeight(alignment: VerticalAlignment = .center) -> some View {
        frame(maxHeight: .infinity, alignment: alignment.combined(with: .center))
    }
    
    /// Makes the view expend both vertically and horizontally.
    func expand(alignment: Alignment = .center) -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
    
    /// Fixes the view's width.
    func fixedWidth() -> some View {
        fixedSize(horizontal: true, vertical: false)
    }
    
    /// Fixes the view's height.
    func fixedHeight() -> some View {
        fixedSize(horizontal: false, vertical: true)
    }
    
    func padding(horizontal: CGFloat, vertical: CGFloat) -> some View {
        padding(.horizontal, horizontal).padding(.vertical, vertical)
    }
    
    func when(_ flag: Bool) -> some View {
        return flag ? self : nil
    }
}
