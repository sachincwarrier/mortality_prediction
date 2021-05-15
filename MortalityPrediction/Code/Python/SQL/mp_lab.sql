--mp_lab

CREATE TABLE mimiciii.mp_lab
WITH (
  format='PARQUET'
) AS
SELECT
    pvt.hadm_id, pvt.hr
  , avg(CASE WHEN label = 'ANION GAP' THEN valuenum ELSE null END) as ANIONGAP
  , avg(CASE WHEN label = 'ALBUMIN' THEN valuenum ELSE null END) as ALBUMIN
  , avg(CASE WHEN label = 'BANDS' THEN valuenum ELSE null END) as BANDS
  , avg(CASE WHEN label = 'BICARBONATE' THEN valuenum ELSE null END) as BICARBONATE
  , avg(CASE WHEN label = 'BILIRUBIN' THEN valuenum ELSE null END) as BILIRUBIN
  , avg(CASE WHEN label = 'CREATININE' THEN valuenum ELSE null END) as CREATININE
  , avg(CASE WHEN label = 'CHLORIDE' THEN valuenum ELSE null END) as CHLORIDE
  , avg(CASE WHEN label = 'GLUCOSE' THEN valuenum ELSE null END) as GLUCOSE
  , avg(CASE WHEN label = 'HEMATOCRIT' THEN valuenum ELSE null END) as HEMATOCRIT
  , avg(CASE WHEN label = 'HEMOGLOBIN' THEN valuenum ELSE null END) as HEMOGLOBIN
  , avg(CASE WHEN label = 'LACTATE' THEN valuenum ELSE null END) as LACTATE
  , avg(CASE WHEN label = 'PLATELET' THEN valuenum ELSE null END) as PLATELET
  , avg(CASE WHEN label = 'POTASSIUM' THEN valuenum ELSE null END) as POTASSIUM
  , avg(CASE WHEN label = 'PTT' THEN valuenum ELSE null END) as PTT
  , avg(CASE WHEN label = 'INR' THEN valuenum ELSE null END) as INR
  , avg(CASE WHEN label = 'PT' THEN valuenum ELSE null END) as PT
  , avg(CASE WHEN label = 'SODIUM' THEN valuenum ELSE null end) as SODIUM
  , avg(CASE WHEN label = 'BUN' THEN valuenum ELSE null end) as BUN
  , avg(CASE WHEN label = 'WBC' THEN valuenum ELSE null end) as WBC
FROM
(
  SELECT le.hadm_id
  , ceil(date_diff('hour',co.intime, le.charttime)) as hr
  , CASE
        WHEN itemid = 50868 THEN 'ANION GAP'
        WHEN itemid = 50862 THEN 'ALBUMIN'
        WHEN itemid = 51144 THEN 'BANDS'
        WHEN itemid = 50882 THEN 'BICARBONATE'
        WHEN itemid = 50885 THEN 'BILIRUBIN'
        WHEN itemid = 50912 THEN 'CREATININE'
        WHEN itemid = 50902 THEN 'CHLORIDE'
        WHEN itemid = 50931 THEN 'GLUCOSE'
        WHEN itemid = 51221 THEN 'HEMATOCRIT'
        WHEN itemid = 51222 THEN 'HEMOGLOBIN'
        WHEN itemid = 50813 THEN 'LACTATE'
        WHEN itemid = 51265 THEN 'PLATELET'
        WHEN itemid = 50971 THEN 'POTASSIUM'
        WHEN itemid = 51275 THEN 'PTT'
        WHEN itemid = 51237 THEN 'INR'
        WHEN itemid = 51274 THEN 'PT'
        WHEN itemid = 50983 THEN 'SODIUM'
        WHEN itemid = 51006 THEN 'BUN'
        WHEN itemid = 51300 THEN 'WBC'
        WHEN itemid = 51301 THEN 'WBC'
      ELSE null
    END AS label
  , CASE
      WHEN itemid = 50862 and valuenum >    10 THEN null -- g/dL 'ALBUMIN'
      WHEN itemid = 50868 and valuenum > 10000 THEN null -- mEq/L 'ANION GAP'
      WHEN itemid = 51144 and valuenum <     0 THEN null -- immature band forms, %
      WHEN itemid = 51144 and valuenum >   100 THEN null -- immature band forms, %
      WHEN itemid = 50882 and valuenum > 10000 THEN null -- mEq/L 'BICARBONATE'
      WHEN itemid = 50885 and valuenum >   150 THEN null -- mg/dL 'BILIRUBIN'
      WHEN itemid = 50806 and valuenum > 10000 THEN null -- mEq/L 'CHLORIDE'
      WHEN itemid = 50902 and valuenum > 10000 THEN null -- mEq/L 'CHLORIDE'
      WHEN itemid = 50912 and valuenum >   150 THEN null -- mg/dL 'CREATININE'
      WHEN itemid = 50809 and valuenum > 10000 THEN null -- mg/dL 'GLUCOSE'
      WHEN itemid = 50931 and valuenum > 10000 THEN null -- mg/dL 'GLUCOSE'
      WHEN itemid = 50810 and valuenum >   100 THEN null -- % 'HEMATOCRIT'
      WHEN itemid = 51221 and valuenum >   100 THEN null -- % 'HEMATOCRIT'
      WHEN itemid = 50811 and valuenum >    50 THEN null -- g/dL 'HEMOGLOBIN'
      WHEN itemid = 51222 and valuenum >    50 THEN null -- g/dL 'HEMOGLOBIN'
      WHEN itemid = 50813 and valuenum >    50 THEN null -- mmol/L 'LACTATE'
      WHEN itemid = 51265 and valuenum > 10000 THEN null -- K/uL 'PLATELET'
      WHEN itemid = 50822 and valuenum >    30 THEN null -- mEq/L 'POTASSIUM'
      WHEN itemid = 50971 and valuenum >    30 THEN null -- mEq/L 'POTASSIUM'
      WHEN itemid = 51275 and valuenum >   150 THEN null -- sec 'PTT'
      WHEN itemid = 51237 and valuenum >    50 THEN null -- 'INR'
      WHEN itemid = 51274 and valuenum >   150 THEN null -- sec 'PT'
      WHEN itemid = 50824 and valuenum >   200 THEN null -- mEq/L == mmol/L 'SODIUM'
      WHEN itemid = 50983 and valuenum >   200 THEN null -- mEq/L == mmol/L 'SODIUM'
      WHEN itemid = 51006 and valuenum >   300 THEN null -- 'BUN'
      WHEN itemid = 51300 and valuenum >  1000 THEN null -- 'WBC'
      WHEN itemid = 51301 and valuenum >  1000 THEN null -- 'WBC'
    ELSE le.valuenum
    END AS valuenum

  FROM mimiciii.labevents le
  inner join mimiciii.mp_cohort co
    on le.hadm_id = co.hadm_id
    and co.excluded = 0
  WHERE le.ITEMID in
  (
    -- comment is: LABEL | CATEGORY | FLUID | NUMBER OF ROWS IN LABEVENTS
    50868, -- ANION GAP | CHEMISTRY | BLOOD | 769895
    50862, -- ALBUMIN | CHEMISTRY | BLOOD | 146697
    51144, -- BANDS - hematology
    50882, -- BICARBONATE | CHEMISTRY | BLOOD | 780733
    50885, -- BILIRUBIN, TOTAL | CHEMISTRY | BLOOD | 238277
    50912, -- CREATININE | CHEMISTRY | BLOOD | 797476
    50902, -- CHLORIDE | CHEMISTRY | BLOOD | 795568
    -- 50806, -- CHLORIDE, WHOLE BLOOD | BLOOD GAS | BLOOD | 48187
    50931, -- GLUCOSE | CHEMISTRY | BLOOD | 748981
    -- 50809, -- GLUCOSE | BLOOD GAS | BLOOD | 196734
    51221, -- HEMATOCRIT | HEMATOLOGY | BLOOD | 881846
    -- 50810, -- HEMATOCRIT, CALCULATED | BLOOD GAS | BLOOD | 89715
    51222, -- HEMOGLOBIN | HEMATOLOGY | BLOOD | 752523
    -- 50811, -- HEMOGLOBIN | BLOOD GAS | BLOOD | 89712
    50813, -- LACTATE | BLOOD GAS | BLOOD | 187124
    51265, -- PLATELET COUNT | HEMATOLOGY | BLOOD | 778444
    50971, -- POTASSIUM | CHEMISTRY | BLOOD | 845825
    -- 50822, -- POTASSIUM, WHOLE BLOOD | BLOOD GAS | BLOOD | 192946
    51275, -- PTT | HEMATOLOGY | BLOOD | 474937
    51237, -- INR(PT) | HEMATOLOGY | BLOOD | 471183
    51274, -- PT | HEMATOLOGY | BLOOD | 469090
    50983, -- SODIUM | CHEMISTRY | BLOOD | 808489
    -- 50824, -- SODIUM, WHOLE BLOOD | BLOOD GAS | BLOOD | 71503
    51006, -- UREA NITROGEN | CHEMISTRY | BLOOD | 791925
    51301, -- WHITE BLOOD CELLS | HEMATOLOGY | BLOOD | 753301
    51300  -- WBC COUNT | HEMATOLOGY | BLOOD | 2371
  )
  AND valuenum IS NOT null AND valuenum > 0 
) pvt
GROUP BY pvt.hadm_id, pvt.hr
ORDER BY pvt.hadm_id, pvt.hr;
