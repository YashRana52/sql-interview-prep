-- Problem: Latest appointment per patient

SELECT *
FROM (
    SELECT 
        a.patient_id,
        a.appointment_date,
        a.status,
        ROW_NUMBER() OVER (
            PARTITION BY a.patient_id
            ORDER BY a.appointment_date DESC
        ) AS rn
    FROM appointments a
) t
WHERE rn = 1;
