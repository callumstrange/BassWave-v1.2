//
//  ViewController.swift
//  BassSynth
//
//  Created by callum strange on 13/04/2018.
//  Copyright © 2018 callum strange. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

    
    class ViewController: UIViewController, AKKeyboardDelegate {
        
        // main oscillators
        
        var osc = AKMorphingOscillatorBank(waveformArray: [AKTable(.sine),
                                                            AKTable(.triangle),
                                                            AKTable(.sawtooth),
                                                            AKTable(.square)])
        var osc2 = AKMorphingOscillatorBank(waveformArray: [AKTable(.sine),
                                                            AKTable(.triangle),
                                                            AKTable(.sawtooth),
                                                            AKTable(.square)])
        
        
        let sine = AKTable(.sine)
        
        let triangle = AKTable(.triangle)
        
        let saw = AKTable(.sawtooth)
        
        let square = AKTable(.square)
        
        
        //processors
        
        var filter = AKRolandTB303Filter()
        
        var compressor = AKDynamicRangeCompressor()
        
        var adsr = AKAmplitudeEnvelope()
    
  
        //mixers
        
        var mixer = AKMixer()
        
        var drywetmix = AKDryWetMixer()
        
        var masterVolume = AKBooster()
        
        //control outlets
        
        @IBOutlet weak var mastervolknob: Knob!
        
        @IBOutlet weak var Keyview: Knob!
        
        @IBOutlet weak var processone: Knob!
        
        @IBOutlet weak var processtwo: Knob!
        
        @IBOutlet weak var processthree: Knob!
        
        @IBOutlet weak var attack: Knob!
        
        @IBOutlet weak var decay: Knob!
        
        @IBOutlet weak var sustain: Knob!
        
        @IBOutlet weak var rellength: Knob!
        
        
        @IBOutlet weak var lforate: Knob!
        
        @IBOutlet weak var lfodep: Knob!
        
        @IBOutlet weak var ramptime: Knob!
        
        
        @IBOutlet weak var AudioPlot: EZAudioPlot!
        
    
        @IBOutlet weak var kbview: UIStackView!
        
        
        @IBOutlet weak var cutoffview: UISlider!
        
        @IBOutlet weak var trianglelight: UIButton!
        
        @IBOutlet weak var squarelight: UIButton!
        
        @IBOutlet weak var sinelight: UIButton!
        
        @IBOutlet weak var sawlight: UIButton!
        
        @IBOutlet weak var sinelight2: UIButton!
        
        
        @IBOutlet weak var trianglelight2: UIButton!
        
        
        @IBOutlet weak var sawlight2: UIButton!
        
        @IBOutlet weak var squarelight2: UIButton!
        
        @IBOutlet weak var attacklabel: UILabel!
        
        
        // Visual Functions
        
       
        
        func setupkeyb() {
            
            let Keyboard = AKKeyboardView(frame: kbview.bounds)
            kbview.addSubview(Keyboard)
            Keyboard.keyOnColor = UIColor.cyan
            Keyboard.whiteKeyOff = UIColor.white.withAlphaComponent(0.600)
            Keyboard.firstOctave = 0
            Keyboard.polyphonicMode = true
            Keyboard.delegate = self
        }
        
        func setupPlot() {
            let plot = AKNodeOutputPlot(mixer, frame: AudioPlot.bounds)
            plot.plotType = .buffer
            plot.shouldFill = true
            plot.shouldMirror = true
            plot.color = UIColor.cyan
            plot.backgroundColor = UIColor.clear
            plot.tintColor = UIColor.magenta
            plot.gain = 0.8
            AudioPlot.addSubview(plot)
            
            
        }
        @IBOutlet weak var attta: UIView!
        
        let hz = 2.0
        var time = 0.0
        let timestep = 0.02
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Build the keyboard
        setupkeyb()
        
 
    
        
        
        mixer = AKMixer(osc, osc2)
        
        
        compressor = AKDynamicRangeCompressor(mixer)
        
        
        
        masterVolume = AKBooster(compressor)
        
          filter = AKRolandTB303Filter(compressor)
        
        drywetmix = AKDryWetMixer(compressor, filter)
        drywetmix.balance = 0.5
        
        AudioKit.output = drywetmix
        AudioKit.start()
        
        setDelegates()
        setDefaultValues()
        setupPlot()
        setupKnobValues()
        }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }
        // KEYBOARD NOTES
        
        func noteOn(note: MIDINoteNumber) {
            
            osc.play(noteNumber: note, velocity: 100)
            osc2.play(noteNumber: note, velocity: 100)
            
        }
        func noteOff(note: MIDINoteNumber) {
            
            osc.stop(noteNumber: note)
            osc2.stop(noteNumber: note)
            
        }
        
        // WHAT DO THEY CONTROL
        
        func setupKnobValues() {
            processone.maximum = 1.0
            processone.minimum = 0.0
            processone.value = osc.index
           
            
            processtwo.maximum = 3
            processtwo.minimum = 0
            processtwo.value = Double(osc.pitchBend)
            
            processthree.maximum = 1.0
            processthree.value = osc2.index
            processthree.minimum = 0.0
            mastervolknob.maximum = 0.4
            mastervolknob.value = masterVolume.gain
            attack.maximum = 2.0
            attack.value = osc.attackDuration
            attack.value = osc2.attackDuration
            decay.maximum = 2.0
            decay.value = osc.decayDuration
            decay.value = osc2.decayDuration
            sustain.maximum = 2
            sustain.value = osc.sustainLevel
            sustain.value = osc2.sustainLevel
            rellength.maximum = 2.0
            rellength.value = osc.releaseDuration
            rellength.value = osc2.releaseDuration
            lforate.maximum = 3.0
            lforate.value = osc.vibratoRate
            lforate.value = osc2.vibratoRate
            lfodep.maximum = 1.0
            lfodep.value = osc.vibratoDepth
            lfodep.value = osc2.vibratoDepth
            ramptime.maximum = 1.0
            ramptime.value = osc2.rampTime
          
            
            
        }
        
        func setDefaultValues() {
      
            filter.cutoffFrequency = 1_000
            filter.resonance = 0.2
            filter.distortion = 2.0
            filter.resonanceAsymmetry = 0.8
            osc.attackDuration = 0.1
            osc.decayDuration = 0.1
            osc.sustainLevel = 1.0
            osc.releaseDuration = 0.2
            osc2.attackDuration = 0.1
            osc2.decayDuration = 0.1
            osc2.sustainLevel = 1.0
            osc2.releaseDuration = 0.2
            osc.index = 0.5
            osc.pitchBend = 0
            osc2.pitchBend = 0
            osc2.index = 0.5
            osc.rampTime = 0
            osc2.rampTime = 0
            osc.vibratoDepth = 0
            osc.vibratoRate = 0
            osc2.vibratoRate = 0
            osc2.vibratoDepth = 0
            compressor.attackTime = 0.2
            compressor.ratio = 2.1
            compressor.threshold = 1.0
            masterVolume.gain = 0.4
            //
            
        }
    
    
        
        @IBAction func resonance(_ sender: UISlider) {
              filter.resonance = (sender.value * 0.8)
        }
        
        @IBAction func cutoff(_ sender: UISlider) {
                  filter.cutoffFrequency = (1 - cos(2 * 3.14 * hz * time)) * 600 + 700
        }
        
       
        @IBAction func Squarebutton(_ sender: UIButton) {
            if sender.isEnabled {
                osc.waveformArray = [square]
                
                trianglelight.isSelected = false
                squarelight.isSelected = true
                sinelight.isSelected = false
                sawlight.isSelected = false
            }
        }
        
        @IBAction func Sine(_ sender: UIButton) {
            if sender.isEnabled {
                osc.waveformArray = [sine]
                
                sinelight.isSelected = true
                squarelight.isSelected = false
                sawlight.isSelected = false
                trianglelight.isSelected = false
            }
        }
        
        @IBAction func Triangle(_ sender: UIButton) {
            if sender.isEnabled {
                osc.waveformArray = [triangle]
                
                trianglelight.isSelected = true
                squarelight.isSelected = false
                sinelight.isSelected = false
                sawlight.isSelected = false
            }
        }
        
        @IBAction func Sawtooth(_ sender: UIButton) {
            if sender.isEnabled {
                osc.waveformArray = [saw]
                
                sawlight.isSelected = true
                trianglelight.isSelected = false
                squarelight.isSelected = false
                sinelight.isSelected = false
                       }
            
        }
        
        @IBAction func osc2sine(_ sender: UIButton) {
            osc2.waveformArray = [sine]
            
            sinelight2.isSelected = true
            squarelight2.isSelected = false
            sawlight2.isSelected = false
            trianglelight2.isSelected = false
            
        }
        
        @IBAction func osc2tri(_ sender: UIButton) {
            
            osc2.waveformArray = [triangle]
            
            trianglelight2.isSelected = true
            squarelight2.isSelected = false
            sinelight2.isSelected = false
            sawlight2.isSelected = false
            
        }
        
        @IBAction func osc2saw(_ sender: UIButton) {
               osc2.waveformArray = [saw]
            sawlight2.isSelected = true
            trianglelight2.isSelected = false
            squarelight2.isSelected = false
            sinelight2.isSelected = false
            
        }
        
        @IBAction func osc2sqr(_ sender: UIButton) {
            
            osc2.waveformArray = [square]
            trianglelight2.isSelected = false
            squarelight2.isSelected = true
            sinelight2.isSelected = false
            sawlight2.isSelected = false
            
        }
        
        
}


    // KNOB DELEGATES......MAKE IT DO SOMETHING
    extension ViewController: KnobDelegate {
        
        func updateKnobValue(_ value: Double, tag: Int) {
            masterVolume.gain = Double(mastervolknob.knobValue)
            osc.index = Double(processone.knobValue)
            osc.pitchBend = Double(processtwo.knobValue)
            osc2.index = Double(processthree.knobValue)
            osc.attackDuration = Double(attack.knobValue)
            osc2.attackDuration = Double(attack.knobValue)
            osc.decayDuration = Double(decay.knobValue)
            osc2.decayDuration = Double(decay.knobValue)
            osc.sustainLevel = Double(sustain.knobValue)
            osc2.sustainLevel = Double(sustain.knobValue)
            osc2.releaseDuration = Double(rellength.knobValue)
            osc.releaseDuration = Double(rellength.knobValue)
            osc.vibratoRate = Double(lforate.knobValue)
            osc2.vibratoRate = Double(lforate.knobValue)
            osc.vibratoDepth = Double(lfodep.knobValue)
            osc2.vibratoDepth = Double(lfodep.knobValue)
            osc2.rampTime = Double(ramptime.knobValue)

           
    }

}
    // Set Delegates

    extension ViewController {
        
        func setDelegates() {
            mastervolknob.delegate = self
            processone.delegate = self
            processtwo.delegate = self
            processthree.delegate = self
            attack.delegate = self
            decay.delegate = self
            sustain.delegate = self
            rellength.delegate = self
            lforate.delegate = self
            lfodep.delegate = self
            ramptime.delegate = self

            
        }
        
    }


