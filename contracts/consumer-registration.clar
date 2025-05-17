;; Consumer Registration Contract
;; Records energy users

;; Data structures
(define-map consumers
  principal
  {
    energy-capacity: uint,
    location: (string-ascii 64),
    registered: bool
  })

;; Error codes
(define-constant err-already-registered (err u200))
(define-constant err-not-registered (err u201))

;; Register a new consumer
(define-public (register-consumer (energy-capacity uint) (location (string-ascii 64)))
  (let ((consumer-data (map-get? consumers tx-sender)))
    (asserts! (is-none consumer-data) err-already-registered)
    (ok (map-set consumers
                tx-sender
                {
                  energy-capacity: energy-capacity,
                  location: location,
                  registered: true
                }))))

;; Update consumer information
(define-public (update-consumer (energy-capacity uint) (location (string-ascii 64)))
  (let ((consumer-data (map-get? consumers tx-sender)))
    (asserts! (is-some consumer-data) err-not-registered)
    (ok (map-set consumers
                tx-sender
                {
                  energy-capacity: energy-capacity,
                  location: location,
                  registered: true
                }))))

;; Unregister a consumer
(define-public (unregister-consumer)
  (let ((consumer-data (map-get? consumers tx-sender)))
    (asserts! (is-some consumer-data) err-not-registered)
    (ok (map-set consumers
                tx-sender
                {
                  energy-capacity: (get energy-capacity (unwrap-panic consumer-data)),
                  location: (get location (unwrap-panic consumer-data)),
                  registered: false
                }))))

;; Check if a consumer is registered
(define-read-only (is-registered (consumer principal))
  (let ((consumer-data (map-get? consumers consumer)))
    (if (is-some consumer-data)
        (get registered (unwrap-panic consumer-data))
        false)))

;; Get consumer information
(define-read-only (get-consumer-info (consumer principal))
  (map-get? consumers consumer))
