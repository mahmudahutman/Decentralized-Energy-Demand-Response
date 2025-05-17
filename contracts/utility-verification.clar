;; Utility Verification Contract
;; This contract validates energy providers

(define-data-var admin principal tx-sender)

;; Map to store verified utilities
(define-map verified-utilities principal bool)

;; Error codes
(define-constant err-not-admin (err u100))
(define-constant err-already-verified (err u101))
(define-constant err-not-verified (err u102))

;; Check if caller is admin
(define-private (is-admin)
  (is-eq tx-sender (var-get admin)))

;; Verify a utility
(define-public (verify-utility (utility-address principal))
  (begin
    (asserts! (is-admin) err-not-admin)
    (asserts! (is-none (map-get? verified-utilities utility-address)) err-already-verified)
    (ok (map-set verified-utilities utility-address true))))

;; Revoke verification
(define-public (revoke-verification (utility-address principal))
  (begin
    (asserts! (is-admin) err-not-admin)
    (asserts! (is-some (map-get? verified-utilities utility-address)) err-not-verified)
    (ok (map-set verified-utilities utility-address false))))

;; Check if a utility is verified
(define-read-only (is-verified (utility-address principal))
  (default-to false (map-get? verified-utilities utility-address)))

;; Transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-admin) err-not-admin)
    (ok (var-set admin new-admin))))
