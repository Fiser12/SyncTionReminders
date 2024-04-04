//
//  RemindersFormService.swift
//  SyncTion (macOS)
//
//  Created by Rubén on 29/12/22.
//

/*
This file is part of SyncTion and is licensed under the GNU General Public License version 3.
SyncTion is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

import Combine
import SyncTionCore
import Foundation

public final class RemindersFormService: FormService {
    public var id = FormServiceId(hash: UUID(uuidString: "e32c0692-4ce4-41e4-a510-7ecbf2c4087c")!)
    
    public static let shared = RemindersFormService()

    public let description = String(localized: "Reminders")
    public let icon = "RemindersLogo"

    private let repository = RemindersRepository.shared

    public var scratchTemplate: FormTemplate {
        RemindersRepository.scratchTemplate
    }

    public let onChangeEvents: [any TemplateEvent] = []
    
    public func load(form: FormModel) async throws -> FormDomainEvent {
        guard var input: OptionsTemplate = form.inputs.first(tag: .Reminders.ListField) else {
            throw FormError.nonLocatedInput(.Reminders.ListField)
        }

        let lists = repository.lists
        input.load(options: lists, keepSelected: false)
        return { [input] form in
            form.inputs[input.id] = AnyInputTemplate(input)
        }
    }
    
    public func send(form: FormModel) async throws {
        try await repository.post(form: form)
    }
}

