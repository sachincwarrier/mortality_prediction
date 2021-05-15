CREATE TABLE mimiciii.mp_data
WITH (
  format='PARQUET'
) AS
select
mp.subject_id1 as subject_id , mp.hadm_id1 as hadm_id, 
 mp.icustay_id1 as icustay_id, mp.hr1 as hr
  , vi.HeartRate
  , vi.SysBP
  , vi.DiasBP
  , vi.MeanBP
  , vi.RespRate
  , coalesce(bg.TEMPERATURE, vi.TempC) as tempc
  , coalesce(bg.SO2, vi.SpO2) as spo2
  , coalesce(lab.GLUCOSE,bg.GLUCOSE,vi.Glucose) as glucose
  , gcs.GCS
  , gcs.GCSMotor
  , gcs.GCSVerbal
  , gcs.GCSEyes
  , gcs.EndoTrachFlag
  , bg.PO2 as bg_PO2
  , bg.PCO2 as bg_PCO2
  , bg.PaO2FiO2Ratio as bg_PaO2FiO2Ratio
  , bg.PH as bg_PH
  , bg.BASEEXCESS as bg_BASEEXCESS
  , bg.TOTALCO2 as bg_TOTALCO2
  , bg.CARBOXYHEMOGLOBIN as bg_CARBOXYHEMOGLOBIN
  , bg.METHEMOGLOBIN as bg_METHEMOGLOBIN
  , lab.ANIONGAP as ANIONGAP
  , lab.ALBUMIN as ALBUMIN
  , lab.BANDS as BANDS
  , coalesce(lab.BICARBONATE,bg.BICARBONATE) as BICARBONATE
  , lab.BILIRUBIN as BILIRUBIN
  , bg.CALCIUM as CALCIUM
  , lab.CREATININE as CREATININE
  , coalesce(lab.CHLORIDE, bg.CHLORIDE) as CHLORIDE
  , coalesce(lab.HEMATOCRIT,bg.HEMATOCRIT) as HEMATOCRIT
  , coalesce(lab.HEMOGLOBIN,bg.HEMOGLOBIN) as HEMOGLOBIN
  , coalesce(lab.LACTATE,bg.LACTATE) as LACTATE
  , lab.PLATELET as PLATELET
  , coalesce(lab.POTASSIUM, bg.POTASSIUM) as POTASSIUM
  , lab.PTT as PTT
  , lab.INR as INR
  , coalesce(lab.SODIUM, bg.SODIUM) as SODIUM
  , lab.BUN as BUN
  , lab.WBC as WBC
  , uo.UrineOutput
from mimiciii.mp_hourly_cohort1 mp
left join mimiciii.mp_vital vi
  on  mp.icustay_id1 = vi.icustay_id
  and mp.hr1 = vi.hr
left join mimiciii.mp_gcs gcs
  on  mp.icustay_id1 = gcs.icustay_id
  and mp.hr1 = gcs.hr
left join mimiciii.mp_uo uo
  on  mp.icustay_id1 = uo.icustay_id
  and mp.hr1   = uo.hr
left join mimiciii.mp_bg_art bg
  on  mp.hadm_id1 = bg.hadm_id
  and mp.hr1 = bg.hr
left join mimiciii.mp_lab lab
  on  mp.hadm_id1 = lab.hadm_id
  and mp.hr1 = lab.hr
order by mp.subject_id1, mp.hadm_id1, mp.icustay_id1, mp.hr1;