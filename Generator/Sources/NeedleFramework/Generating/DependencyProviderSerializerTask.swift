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

/// The task that serializes a list of processed dependency providers into
/// exportable foramt.
class DependencyProviderSerializerTask: AbstractTask<[SerializedDependencyProvider]> {

    /// Initializer.
    ///
    /// - parameter providers: The processed dependency provider to serialize.
    init(providers: [ProcessedDependencyProvider]) {
        self.providers = providers
    }

    /// Execute the task and returns the in-memory serialized dependency
    /// provider data models.
    ///
    /// - returns: The list of `SerializedDependencyProvider`.
    override func execute() -> [SerializedDependencyProvider] {
        return providers.map { (provider: ProcessedDependencyProvider) in
            return serialize(provider)
        }
    }

    // MARK: - Private

    private let providers: [ProcessedDependencyProvider]

    private func serialize(_ provider: ProcessedDependencyProvider) -> SerializedDependencyProvider {
        let content = serializedContent(for: provider)
        let registration = DependencyProviderRegistrationSerializer(provider: provider).serialize()
        return SerializedDependencyProvider(content: content, registration: registration)
    }

    private func serializedContent(for provider: ProcessedDependencyProvider) -> String {
        let classNameSerializer = ClassNameSerializer(provider: provider)
        let propertiesSerializer = PropertiesSerializer(provider: provider)
        let sourceComponentsSerializer = SourceComponentsSerializer(provider: provider)
        let initBodySerializer = DependencyProviderInitBodySerializer(provider: provider)

        let serializer = DependencyProviderSerializer(provider: provider, classNameSerializer: classNameSerializer, propertiesSerializer: propertiesSerializer, sourceComponentsSerializer: sourceComponentsSerializer, initBodySerializer: initBodySerializer)
        return serializer.serialize()
    }
}
