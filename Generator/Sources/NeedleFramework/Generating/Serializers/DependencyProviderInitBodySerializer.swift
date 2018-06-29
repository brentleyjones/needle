//
//  Copyright (c) 2018. Uber Technologies
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

/// A serializer that produces the initializer body code for the dependency
/// provider.
class DependencyProviderInitBodySerializer: Serializer {

    /// Initializer.
    ///
    /// - parameter provider: The provider to generate initializer body
    /// code for.
    init(provider: ProcessedDependencyProvider) {
        self.provider = provider
    }

    /// Serialize the data model and produce the initializer body code.
    ///
    /// - returns: The initializer body code.
    func serialize() -> String {
        return provider.levelMap.map { (componentType: String, level: Int) in
            return "        \(componentType.lowercasedFirstChar()) = component\(String(repeating: ".parent", count: level)) as! \(componentType)"
        }
        .joined(separator: "\n")
    }

    // MARK: - Private

    private let provider: ProcessedDependencyProvider
}
