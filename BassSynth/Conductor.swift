//
//  Conductor.swift
//  BassSynth
//
//  Created by callum strange on 23/04/2018.
//  Copyright © 2018 callum strange. All rights reserved.
//

import AudioKit

class Consuctor: AKMIDIListener {
    
    static let sharedInstance = Conductor()
    
    var core = GaneratorBank
    
}
