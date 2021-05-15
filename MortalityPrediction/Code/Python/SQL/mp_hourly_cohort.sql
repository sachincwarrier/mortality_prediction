--mp_hourly_cohort
create table mimiciii.mp_hourly_cohort1 as(
select try_cast(subject_id as integer)as subject_id1 , try_cast(hadm_id as integer) as  hadm_id1, 
  try_cast(icustay_id as integer) as icustay_id1, try_cast(hr as integer) as hr1 from mimiciii.mp_hourly_cohort);