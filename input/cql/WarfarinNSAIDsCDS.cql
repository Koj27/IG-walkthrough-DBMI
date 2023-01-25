library WarfarinNSAIDsCDS version '1.0'

using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1' called FHIRHelpers



codesystem "RXNORM": 'http://www.nlm.nih.gov/research/umls/rxnorm'


valueset "Topical Diclofenac": 'http://hl7.org/fhir/ig/PDDI-CDS/ValueSet/valueset-topicaldiclofenac'
valueset "Warfarins": 'http://hl7.org/fhir/ig/PDDI-CDS/ValueSet/valueset-warfarin'
valueset "NSAIDs": 'http://hl7.org/fhir/ig/PDDI-CDS/ValueSet/valueset-NSAIDS'
valueset "PPIs and Misoprostols": 'valueset-PPIS'
valueset "History of GI Bleeds": 'valueset-Hx-UGIB-snomed'
valueset "Systemic Corticosteroids": 'valueset-SCS'
valueset "Aldosterone Antagonists": 'valueset-AAS'


parameter ContextPrescriptionStatements List<MedicationStatement>
parameter ContextPrescriptionRequests List<MedicationRequest>
parameter ContextConditions List<Condition>


context Patient



define "Inclusion Criteria":
   "NSAID Rx exists" 
    and 
  "Warfarin Rx exists"


define "Warfarin Rx exists":
  exists ("Warfarin Rx")

define "Warfarin Rx":
   (
      [MedicationStatement: "Warfarins"] MS
        where (Today() - 100 days) < MS.effective.start.value  // or, could be hard-coded e.g., > @2022-11-01 
        return MS.medication.coding[0]
    )
    union
    (
      [MedicationRequest: "Warfarins"] MR
      where MR.authoredOn.value > (Today() - 100 days) // or, could be hard-coded e.g., > @2022-11-01 
      return MR.medication.coding[0]
    )

define "NSAID Rx exists":
  exists ("NSAID Prescription")

define "NSAID Prescription":
 ( 
    [MedicationStatement: "NSAIDs"] P
      where P.effective.start.value > (Today() - 100 days) // or, could be hard-coded e.g., > @2022-11-01 
     return P.medication.coding[0]
  )
  union 
  ( 
    [MedicationRequest: "NSAIDs"] P
      where P.authoredOn.value > (Today() - 100 days) // or, could be hard-coded e.g., > @2022-11-01 
     return P.medication.coding[0]
  )

