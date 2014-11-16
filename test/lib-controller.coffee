assert = require 'assert'

controller = require '../src/controller.coffee'
controller.debug = no

describe '#decodePulses()', ->
  tests = [
    {
      protocol: 'generic'
      pulseLengths: [671, 2051, 4346, 10220]
      pulses: [
        '020102010201020101020102010201020102020101020201020102010102020101020201010202010201020102010201020102010201020102010201020102010201020102010201020102010201020102010201020102010201020102010201010203'
        '020102010201020101020102010201020102020101020201020102010102020101020201010202010201020102010201020102010201020102010201020102010201020102010201020102010102020102010102010201020201010202010201010203'
        '020102010201020101020102010201020102010202010201010201020102020101020201010202010201020102010201020102010201020102010201020102010102020102010201020102010102010202010201020101020102010202010201010203'
        '020102010201020101020102010201020102020101020201020102010102020101020201020102010201020102010201020102010201020102010201020102010102020102010201020102010102010202010201020101020102010202010201010203'
        '020102010201020101020102010201020102020101020201020102010102020101020201010201020102010201020102010201020102010201020102010201020102010201020102010201020102010201020102010201020102010201020102010203'
      ]
      values: [
        { id: 1000, type: 10, positive: true, value: 1 }
        { id: 1000, type: 10, positive: true, value: 1257 }
        { id: 1011, type: 10, positive: true, value: 67129 }
        { id: 1000, type: 10, positive: false, value: 67129 }
        { id: 1000, type: 10, positive: true, value: 1073741823 }
      ]
    },
    {
      protocol: 'pir1'
      pulseLengths: [358, 1095, 11244]
      pulses: [
        '01100101011001100110011001100110011001010110011002'
        '01100110011001100110010101100110011001010110011002'
        '01100110011001010110011001100110010101100110011002'
      ]
      values: [
        { unit: 8, id: 1, presence: true }
        { unit: 0, id: 17, presence: true }
        { unit: 2, id: 2, presence: true }
      ]
    },
    {
      protocol: 'pir2'
      pulseLengths: [451, 1402, 14356]
      pulses: [
        '01100110010110011001010110100101010101011010010102'
      ]
      values: [
        { unit: 21, id: 21, presence: true }
      ]
    },
    {
      protocol: 'weather1'
      pulseLengths: [456, 1990, 3940, 9236]
      pulses: [
        '01020102020201020101010101010102010101010202020101020202010102010101020103'
        '01020102020201020101010101010102010101010202020102010102010102010101020103'
        '01020102020201020101010101010102010101010202020102010101010102010101020103'
      ]
      values: [
        { temperature: 23.1, humidity: 34 }
        { temperature: 23.3, humidity: 34 }
        { temperature: 23.2, humidity: 34 }
      ]
    },
    {
      protocol: 'weather2'
      pulseLengths: [492, 969, 1948, 4004]
      pulses: [
        '01010102020202010201010101010101020202010201020102020202010101010101010103'
        '01010102020202010201010101010101020202010201010202020202010101010101010103'
        '01010102020202010201010101010101020202010201010102020202010101010101010103'
        '01010101020201020201010101010102010101010202010102020202010101010101010103'
        '01010101020201020201010101010102010101010201010102020202010101010101010103'
        '01010101020201020201010101010102010101010202020102020202010101010101010103'
      ],
      values: [
        { temperature: 23.4 }
        { temperature: 23.3 }
        { temperature: 23.2 }
        { temperature: 26.8 }
        { temperature: 26.4 }
        { temperature: 27 }
      ]
    },
    {
      protocol: 'weather3'
      pulseLengths: [508, 2012, 3908, 7726]
      pulses: [
        '0101020202020102020101010201010202020102020201020201020101010101020201020101010102010303'
        '0101020202020102020101010201020102020102020201020201020101010101020201020101020201010303'
        '0101020102010202010201010101010101010102010101020201010101020102010101010101010201020303'
        '0101020102010202010201010101010202020102010101020201010101020102010101010101010201010303'
        '0101010101020202020101010102020101020101010101020201020202010101020201020101010101020303'
        '0101010101020202020101010102010201020101010201020201020202020101020201010101020201010303'
      ]
      values: [
        { id: 246, channel: 3, temperature: 24.2, humidity: 56 }
        { id: 246, channel: 3, temperature: 24.4, humidity: 56 }
        { id: 173, channel: 1, temperature: 21.1, humidity: 65 }
        { id: 173, channel: 1, temperature: 21.5, humidity: 65 }
        { id: 30,  channel: 2, temperature: 18.1, humidity: 62 }
        { id: 30,  channel: 2, temperature: 18.7, humidity: 63 }
      ]
    },
    {
      protocol: 'weather4'
      pulseLengths: [ 526, 990, 1903, 4130, 7828, 16076 ]
      pulses: [
        '11111111040303030203030302020302030203020302030302020202030302020202030303020202030202020305'
      ]
      values: [
        { id: 238, channel:1, temperature: 18.9, humidity: 71, battery: 2.5 }
      ]
    },
    {
      protocol: 'weather5'
      pulseLengths: [ 534, 2000, 4000, 9120  ]
      pulses: [
        '01020101010201020102010101020202020202010101010102020201010202010202020203'
        '01010101010101010102020102020101020202010201010101010101010101010101010203'
        '01020202010101020102020102020101020102020202010101010101010101010102020103'
        '01020202010202020101010102010201020202010101010102010102020101020201020103'
        '01020202010202020101020101020101020202020202020202010102010202010101010103'
      ]
      values: [
        { id: 162, temperature: 12.6, humidity: 67, battery: 1 }
        { id: 0, rain: 5.75, battery: 1 }
        { id: 142, rain: 15.25, battery: 1 }
        { id: 238, temperature: 11.7, humidity: 99,  battery: 1 }
        { id: 238, temperature: -1.4, humidity: 69,  battery: 1 }
      ]
    },
    {
      protocol: 'dimmer1'
      pulseLengths: [259, 1293, 2641, 10138]
      pulses: [
        '0200010001010000010001010000010001000101000100010001000100000101000100010000010001000100010001010001000001000101000001000100010001010001000100010013'
      ],
      values: [
        {id: 9565958, all: false, unit: 0, dimlevel: 15, state: true}
      ]
    },
    {
      protocol: 'switch1'
      pulseLengths: [268, 1282, 2632, 10168]
      pulses: [
        '020001000101000001000100010100010001000100000101000001000101000001000100010100000100010100010000010100000100010100000100010001000103'
        '020001000101000001000100010100010001000100000101000001000101000001000100010100000100010100010000010100000100010100000100010001010003'
        '020001000101000001000100010100010001000100000101000001000101000001000100010100000100010100010000010100000100010001000100010001010003'
      ],
      values: [
        { id: 9390234, all: false, state: true, unit: 0 }
        { id: 9390234, all: false, state: true, unit: 1 }
        { id: 9390234, all: false, state: false, unit: 1 }
      ]
    },
    {
      protocol: 'switch2'
      pulseLengths: [306, 957, 9808]
      pulses: [
        '01010101011001100101010101100110011001100101011002'
      ],
      values: [
        { houseCode: 25, unitCode: 16, state: true }
      ]
    },
    { 
      protocol: 'switch4'
      pulseLengths: [ 295, 1180, 11210 ],
      pulses: [
        '01010110010101100110011001100110010101100110011002'
      ],  
      values: [
         { id: 2, unit: 20, state: true }
      ]
    },
    {
      protocol: 'switch5'
      pulseLengths: [295, 886, 9626]
      pulses: [
        '10010101101010010110010110101001010101011010101002'
        '10010101101010010110010110101001010101011010100102'
        '10010101101010010110010110101001010101011010011002'
        '10010101101010010110010110101001010101011010010102'
        '10010101101010010110010110101001010101011001101002'
        '10010101101010010110010110101001010101011001100102'
        '10010101101010010110010110101001010101010110101002'
        '10010101101010010110010110101001010101010110100102'
        '10010101101010010110010110101001010101010101011002'
        '10010101101010010110010110101001010101010101100102'
     ],
      values: [
        { id: 465695, unit: 1, all: false, state: on }
        { id: 465695, unit: 1, all: false, state: off }
        { id: 465695, unit: 2, all: false, state: on }
        { id: 465695, unit: 2, all: false, state: off }
        { id: 465695, unit: 3, all: false, state: on }
        { id: 465695, unit: 3, all: false, state: off }
        { id: 465695, unit: 4, all: false, state: on }
        { id: 465695, unit: 4, all: false, state: off }
        { id: 465695, unit: 0, all: true, state: off }
        { id: 465695, unit: 0, all: true, state: on }
      ]
    },
    { 
      protocol: 'switch6'
      pulseLengths: [ 150, 453, 4733],
      pulses: [
        '10101010101010101010010101100110011001100110010102'
        '10101010101010100110011001010110011001100110010102'
      ],  
      values: [
         { systemcode: 31, programcode: 1, state: true }
         { systemcode: 15, programcode: 2, state: true }
      ]
    },
    { 
      protocol: 'switch7'
      pulseLengths: [307, 944, 9712],
      pulses: [
        '01010101010101100101010101010110011001100110011002'
        '10100101010101100101010101010110011001100110011002'
      ],  
      values: [
         { id: 24, unit: 29, state: true }
         { id: 24, unit: 29, state: false }
      ]
    },
    {
      protocol: 'contact1'
      pulseLengths: [268, 1282, 2632, 10168]
      pulses: [
        '0200010001010001000001000100010100010000010100010001000100010000010100000100010001010001000001010001000001000101000100000100010100000101000001000103'
        '020001000101000100000100010001010001000001010001000100010001000001010000010001000101000100000101000100000100010001010000010001010003'
      ],
      values: [
        { id: 13040182, all: false, state: true, unit: 9 }
        { id: 13040182, all: false, state: false, unit: 9 }
      ]
    },
  ]

  runTest = ( (t) ->
    it "#{t.protocol} should decode the pulses", ->
      for pulses, i in t.pulses
        results = controller.decodePulses(t.pulseLengths, pulses)
        assert(results.length >= 1, "pulse of #{t.protocol} should be detected.")
        result = null
        for r in results
          if r.protocol is t.protocol
            result = r
            break
        assert(result, "pulse of #{t.protocol} should be detected as #{t.protocol}.") 
        assert.deepEqual(result.values, t.values[i])
  )

  runTest(t) for t in tests

  it "should decode fixable pulses", ->
    pulseLengths =[ 258, 401, 1339, 2715, 10424 ]
    pulses = '030002000202000200000202000002020000020002020000020002020000020201020000020200020000020201020002000200000200020002000200020002000204' 
    results = controller.decodePulses(pulseLengths, pulses)
    assert(results.length >= 1, "fixable pulses should be fixed.")


describe '#compressTimings()', ->
  tests = [
    {
      protocol: 'switch2'
      timings: [
        [ 288, 972, 292, 968, 292, 972, 292, 968, 292, 972, 920, 344, 288, 976, 920, 348, 
          284, 976, 288, 976, 284, 976, 288, 976, 288, 976, 916, 348, 284, 980, 916, 348, 
          284, 976, 920, 348, 284, 976, 920, 348, 284, 980, 280, 980, 284, 980, 916, 348, 
          284, 9808
        ],
        [
          292, 968, 292, 972, 292, 972, 292, 976, 288, 976, 920, 344, 288, 976, 920, 348, 
          284, 976, 288, 976, 288, 976, 284, 980, 284, 976, 920, 348, 284, 976, 916, 352, 
          280, 980, 916, 352, 280, 980, 916, 348, 284, 980, 284, 976, 284, 984, 912, 352, 
          280, 9808
        ],
        [
          292, 976, 288, 972, 292, 972, 292, 920, 288, 976, 920, 344, 288, 980, 916, 344, 
          288, 980, 284, 980, 284, 972, 288, 980, 284, 976, 920, 344, 288, 976, 916, 352, 
          280, 980, 916, 348, 284, 980, 916, 348, 284, 980, 284, 976, 288, 976, 916, 352, 
          280, 9804
        ],
        [
          288, 972, 292, 968, 296, 972, 296, 976, 288, 976, 920, 344, 288, 976, 920, 344, 
          292, 972, 288, 976, 288, 976, 284, 976, 288, 976, 920, 344, 288, 976, 920, 344, 
          284, 980, 916, 348, 284, 980, 916, 348, 284, 980, 284, 976, 288, 980, 912, 352, 
          280, 9808
        ]
      ]
      results: [
        { 
          buckets: [ 304, 959, 9808 ],
          pulses: '01010101011001100101010101100110011001100101011002'
        }
        { 
          buckets: [ 304, 959, 9808 ],
          pulses: '01010101011001100101010101100110011001100101011002'
        }
        { 
          buckets: [ 304, 957, 9804 ],
          pulses: '01010101011001100101010101100110011001100101011002' 
        }
        { 
          buckets: [ 304, 959, 9808 ],
          pulses: '01010101011001100101010101100110011001100101011002' 
        }
      ]
    },
    {
      protocol: 'switch4'
      timings: [
        [
          295, 1180, 295, 1180, 295, 1180, 1180, 295, 295, 1180, 295, 1180, 295, 1180, 1180, 295, 
          295, 1180, 1180, 295, 295, 1180, 1180, 295, 295, 1180, 1180, 295, 295, 1180, 1180, 295, 
          295, 1180, 295, 1180, 295, 1180, 1180, 295, 295, 1180, 1180, 295, 295, 1180, 1180, 295, 
          295, 11210
        ]
      ]
      results: [
        {  
          buckets: [ 295, 1180, 11210 ],
          pulses: '01010110010101100110011001100110010101100110011002'
        }
      ]
    }
  ]

  runTest = ( (t) ->
    it 'should compress the timings', ->
      for timings, i in t.timings
        result = controller.compressTimings(timings)
        assert.deepEqual(result, t.results[i]) 
  )

  runTest(t) for t in tests

describe '#encodeMessage()', ->
  tests = [
    {
      protocol: 'switch1'
      message: { id: 9390234, all: false, state: true, unit: 0 }
      pulses: '020001000101000001000100010100010001000100000101000001000101000001000100010100000100010100010000010100000100010100000100010001000103'
    },
    {
      protocol: 'switch2'
      message: { houseCode: 25, unitCode: 16, state: true }
      pulses: '01010101011001100101010101100110011001100101011002'
    },
    {
      protocol: 'switch5'
      message: { id: 465695, unit: 2, all: false, state: on }
      pulses: '10010101101010010110010110101001010101011010011002'
    },
    {
      protocol: 'switch6'
      message: {systemcode: 15, programcode: 2, state: true }
      pulses: '10101010101010100110011001010110011001100110010102'
    }
  ]

  runTest = ( (t) ->
    it "should create the correct pulses for #{t.protocol}", ->
      result = controller.encodeMessage(t.protocol, t.message)
      assert.equal result.pulses, t.pulses
  )

  runTest(t) for t in tests


describe '#fixPulses()', ->
  tests = [
    {
      pulseLengths: [ 258, 401, 1339, 2715, 10424 ],
      pulses: '030002000202000200000202000002020000020002020000020002020000020201020000020200020000020201020002000200000200020002000200020002000204'
      result: { 
        pulseLengths: [ 329, 1339, 2715, 10424 ],
        pulses: '020001000101000100000101000001010000010001010000010001010000010100010000010100010000010100010001000100000100010001000100010001000103'
      }
    },
    { 
      pulseLengths: [ 239, 320, 1337, 2717, 10359 ],
      pulses: '030002000202000201010202010002020101020102020101020102020101020201020101020201020101020201020102010201010201020102010201020112000204'
      result: { 
        pulseLengths: [ 279, 1337, 2717, 10359 ],
        pulses: '020001000101000100000101000001010000010001010000010001010000010100010000010100010000010100010001000100000100010001000100010001000103' 
      }
    }
  ]

  runTest = ( (t) ->
    it "should fix the pulses", ->
      result = controller.fixPulses(t.pulseLengths, t.pulses)
      assert.deepEqual result.pulseLengths, t.result.pulseLengths
      assert.equal result.pulses, t.result.pulses
  )

  runTest(t) for t in tests

  it "should not change correct pulses", ->
    pulseLengths = [ 279, 1337, 2717, 10359 ]
    pulses = '020001000101000100000101000001010000010001010000010001010000010100010000010100010000010100010001000100000100010001000100010001000103'
    result = controller.fixPulses(pulseLengths, pulses)
    assert(result is null)



