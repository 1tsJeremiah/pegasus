;;
;; Domain:     1tsjeremiah.com.
;; Exported:   2025-03-25 02:20:34
;;
;; This file is intended for use for informational and archival
;; purposes ONLY and MUST be edited before use on a production
;; DNS server.  In particular, you must:
;;   -- update the SOA record with the correct authoritative name server
;;   -- update the SOA record with the contact e-mail address information
;;   -- update the NS record(s) with the authoritative name servers for this domain.
;;
;; For further information, please consult the BIND documentation
;; located on the following website:
;;
;; http://www.isc.org/
;;
;; And RFC 1035:
;;
;; http://www.ietf.org/rfc/rfc1035.txt
;;
;; Please note that we do NOT offer technical support for any use
;; of this zone data, the BIND name server, or any other third-party
;; DNS software.
;;
;; Use at your own risk.
;; SOA Record
1tsjeremiah.com	3600	IN	SOA	brynne.ns.cloudflare.com. dns.cloudflare.com. 2049453583 10000 2400 604800 3600

;; NS Records
1tsjeremiah.com.	86400	IN	NS	brynne.ns.cloudflare.com.
1tsjeremiah.com.	86400	IN	NS	jeff.ns.cloudflare.com.

;; A Records
1tsjeremiah.com.	1	IN	A	198.96.88.177 ; cf_tags=cf-proxied:true
ai.1tsjeremiah.com.	1	IN	A	198.96.88.177 ; cf_tags=cf-proxied:true
authentik.1tsjeremiah.com.	1	IN	A	198.96.88.177 ; authentication dash cf_tags=cf-proxied:true
onboard.1tsjeremiah.com.	1	IN	A	198.96.88.177 ; cf_tags=cf-proxied:true
traefik.1tsjeremiah.com.	1	IN	A	198.96.88.177 ; traefik reverse proxy dash cf_tags=cf-proxied:true

;; CNAME Records
www.1tsjeremiah.com.	1	IN	CNAME	1tsjeremiah.com. ; cf_tags=cf-proxied:true

;; MX Records
1tsjeremiah.com.	1	IN	MX	91 route3.mx.cloudflare.net.
1tsjeremiah.com.	1	IN	MX	63 route2.mx.cloudflare.net.
1tsjeremiah.com.	1	IN	MX	25 route1.mx.cloudflare.net.
emails.1tsjeremiah.com.	1	IN	MX	91 route3.mx.cloudflare.net.
emails.1tsjeremiah.com.	1	IN	MX	63 route2.mx.cloudflare.net.
emails.1tsjeremiah.com.	1	IN	MX	25 route1.mx.cloudflare.net.

;; TXT Records
1tsjeremiah.com.	1	IN	TXT	"openai-domain-verification=dv-uJ9j6I9cZCBKG2s7RhUG6K9p"
1tsjeremiah.com.	1	IN	TXT	"v=spf1 include:_spf.mx.cloudflare.net ~all"
cf2024-1._domainkey.1tsjeremiah.com.	1	IN	TXT	"v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiweykoi+o48IOGuP7GR3X0MOExCUDY/BCRHoWBnh3rChl7WhdyCxW3jgq1daEjPPqoi7sJvdg5hEQVsgVRQP4DcnQDVjGMbASQtrY4WmB1VebF+RPJB2ECPsEDTpeiI5ZyUAwJaVX7r6bznU67g7LvFq35yIo4sdlmtZGV+i0H4cpYH9+3JJ78k" "m4KXwaf9xUJCWF6nxeD+qG6Fyruw1Qlbds2r85U9dkNDVAS3gioCvELryh1TxKGiVTkg4wqHTyHfWsp7KD3WQHYJn0RyfJJu6YEmL77zonn7p2SRMvTMP3ZEXibnC9gz3nnhR6wcYL8Q7zXypKTMD58bTixDSJwIDAQAB"
_dmarc.1tsjeremiah.com.	1	IN	TXT	"v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s;"
_dmarc.1tsjeremiah.com.	1	IN	TXT	"v=DMARC1; p=none; rua=mailto:3e9986c6094b404591cfd83a2e3fc29f@dmarc-reports.cloudflare.net"
*._domainkey.1tsjeremiah.com.	1	IN	TXT	"v=DKIM1; p="
emails.1tsjeremiah.com.	1	IN	TXT	"v=spf1 include:_spf.mx.cloudflare.net ~all"
