From: "Bharath Ramesh" <bramesh-PjAqaU27lzQ@public.gmane.org>
Subject: RE: IB atomic operations
Date: Fri, 25 Feb 2011 11:32:25 -0500
Message-ID: <00f401cbd509$96834b80$c389e280$@edu>
References: <00b701cbd4bd$e271fe20$a755fa60$@edu> <4D67D17C.7000405@systemfabricworks.com> <00e401cbd505$a437bc60$eca73520$@edu> <4D67D4F2.4040404@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="----=_NextPart_000_00EF_01CBD4DF.ACE25260";
	protocol="application/x-pkcs7-signature";
	micalg=SHA1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D67D4F2.4040404-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'frank zago' <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_00EF_01CBD4DF.ACE25260
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

> -----Original Message-----
> From: frank zago [mailto:fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org]
> 
> On 02/25/2011 10:04 AM, Bharath Ramesh wrote:
> >> -----Original Message-----
> >> From: frank zago [mailto:fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org]
> >>
> >> On 02/25/2011 01:30 AM, Bharath Ramesh wrote:
> >>> Hi,
> >>> 	I am trying to use IB atomic operations, specifically fetch and
> >> add.
> >>> I tried a small example but I am unable to get it to work. The WC
> >> status is
> >>> IBV_WC_REM_INV_REQ_ERR. My sample code is as follows:
> >>
> >> Did you register your memory with IBV_ACCESS_REMOTE_ATOMIC ?
> >
> > I have registered both the remote and local data with
> > IBV_ACCESS_LOCAL_WRITE | IBV_ACCESS_REMOTE_ATOMIC |
> IBV_ACCESS_REMOTE_READ |
> > IBV_ACCESS_REMOTE_WRITE
> >
> 
> Do you create your QPs with RDMA CM or do you transition them by hand ?
> In the later case there is a couple flags to set.

I transition them by hand, my QP creation is done as follows:

memset (&init_attr, 0, sizeof (struct ibv_qp_init_attr));
init_attr.recv_cq = ib_cq;
init_attr.send_cq = ib_cq;
init_attr.cap.max_recv_wr = IB_MAX_WR;
init_attr.cap.max_send_wr = IB_MAX_WR;
init_attr.cap.max_recv_sge = IB_MAX_SGE;
init_attr.cap.max_send_sge = IB_MAX_SGE;
init_attr.qp_type = IBV_QPT_RC;
qp = ibv_create_qp (ib_pd, &init_attr);
if (qp == NULL) {
	// QP creation error.
}

I transition the QP as follows:

// Transition QP to INIT state.
attr.qp_state = IBV_QPS_INIT;
attr.pkey_index = 0;
attr.port_num = IB_PORT;
attr.qp_access_flags = IBV_ACCESS_LOCAL_WRITE | IBV_ACCESS_REMOTE_ATOMIC |
IBV_ACCESS_REMOTE_READ
	| IBV_ACCESS_REMOTE_WRITE;
if (ibv_modify_qp (qp, &attr, IBV_QP_STATE | IBV_QP_PKEY_INDEX |
		IBV_QP_PORT | IBV_QP_ACCESS_FLAGS) != 0) {
	// QP modify error.
}

memset (&attr, 0, sizeof (struct ibv_qp_attr));
attr.qp_state = IBV_QPS_RTR;
attr.path_mtu = ib_mtu;
attr.dest_qp_num = qpn;
attr.rq_psn = 0;
attr.max_dest_rd_atomic = IB_MAX_RD_ATOMIC;
attr.min_rnr_timer = IB_RNR_TIMER;
attr.ah_attr.is_global = 0;
attr.ah_attr.dlid = lid;
attr.ah_attr.sl = 0;
attr.ah_attr.src_path_bits = 0;
attr.ah_attr.port_num = IB_PORT;
if (ibv_modify_qp (qp, &attr, IBV_QP_STATE | IBV_QP_AV | IBV_QP_PATH_MTU |
IBV_QP_DEST_QPN |
		IBV_QP_RQ_PSN | IBV_QP_MAX_DEST_RD_ATOMIC |
IBV_QP_MIN_RNR_TIMER) != 0) {
	// QP modify error.
}

// Transition the QP to RTS.
attr.timeout = IB_TIMEOUT;
attr.retry_cnt = IB_RETRY_CNT;
attr.rnr_retry = IB_RNR_RETRY;
attr.qp_state = IBV_QPS_RTS;
attr.sq_psn = 0;
attr.max_rd_atomic = IB_MAX_RD_ATOMIC;
if (ibv_modify_qp (qp, &attr, IBV_QP_STATE | IBV_QP_SQ_PSN |
IBV_QP_MAX_QP_RD_ATOMIC |
		IBV_QP_RETRY_CNT | IBV_QP_RNR_RETRY | IBV_QP_TIMEOUT) != 0)
{
	// QP modify error.
}

Regards,

Bharath

------=_NextPart_000_00EF_01CBD4DF.ACE25260
Content-Type: application/x-pkcs7-signature;
	name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIOhTCCBDIw
ggMaoAMCAQICAQEwDQYJKoZIhvcNAQEFBQAwezELMAkGA1UEBhMCR0IxGzAZBgNVBAgMEkdyZWF0
ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBwwHU2FsZm9yZDEaMBgGA1UECgwRQ29tb2RvIENBIExpbWl0
ZWQxITAfBgNVBAMMGEFBQSBDZXJ0aWZpY2F0ZSBTZXJ2aWNlczAeFw0wNDAxMDEwMDAwMDBaFw0y
ODEyMzEyMzU5NTlaMHsxCzAJBgNVBAYTAkdCMRswGQYDVQQIDBJHcmVhdGVyIE1hbmNoZXN0ZXIx
EDAOBgNVBAcMB1NhbGZvcmQxGjAYBgNVBAoMEUNvbW9kbyBDQSBMaW1pdGVkMSEwHwYDVQQDDBhB
QUEgQ2VydGlmaWNhdGUgU2VydmljZXMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC+
QJ30buHqdoccTUVEjr5GyIMGncEq/hgfjuQC+vOrXVCKFjELmgbQxXAizUktVGPMtm5oRgtT6stM
JMC8ck7q8RWu9FSaEgrDerIzYOLaiVXzIljz3tzP74OGooyUT59o8piQRoQnx3a/48w1LIteB2Rl
gsBIsKiR+WGfdiBQqJHHZrXreGIDVvCKGhPqMaMeoJn9OPb2JzJYbwf1a7j7FCuvt6rM1mNfc4za
BZmoOKjLF3g2UazpnvR4Oo3PD9lC4pgMqy+fDgHe75+ZSfEt36x0TRuYtUfF5SnR+ZAYx2KcvoPH
Jns+iiXHwN2d5jVoECCdj9je0sOEnA1e6C/JAgMBAAGjgcAwgb0wHQYDVR0OBBYEFKARCiM+lvEH
7OKvKe+CpX/QMKS0MA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MHsGA1UdHwR0MHIw
OKA2oDSGMmh0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0FBQUNlcnRpZmljYXRlU2VydmljZXMuY3Js
MDagNKAyhjBodHRwOi8vY3JsLmNvbW9kby5uZXQvQUFBQ2VydGlmaWNhdGVTZXJ2aWNlcy5jcmww
DQYJKoZIhvcNAQEFBQADggEBAAhW/ALwm+j/pPrWe8ZEgM5PxMX2AFjMpra8FEloBHbo5u5d7AIP
YNaNUBhPJk4B4+awpe6/vHRUQb/9/BK4x09a9IlgBX9gtwVK8/bxwr/EuXSGti19a8zS80bdL8bg
asPDNAMsfZbdWsIOpwqZwQWLqwwv81w6z2w3VQmH3lNAbFjv/LarZW4E9hvcPOBaFcae2fFZSDAh
ZQNs7Okhc+ybA6HgN62gFRiP+roCzqcsqRATLNTlCCarIpdg+JBedNSimlO98qlo4KJuwtdssaMP
nr/raOdW8q7y4ys4OgmBtWuF174t7T8at7Jj4vViLILUagBBUPE5g5+V6TaWmG4wggTdMIIDxaAD
AgECAhBxkvvmGV+sTRKFdHE0ohinMA0GCSqGSIb3DQEBBQUAMHsxCzAJBgNVBAYTAkdCMRswGQYD
VQQIDBJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcMB1NhbGZvcmQxGjAYBgNVBAoMEUNvbW9k
byBDQSBMaW1pdGVkMSEwHwYDVQQDDBhBQUEgQ2VydGlmaWNhdGUgU2VydmljZXMwHhcNMDQwMTAx
MDAwMDAwWhcNMjgxMjMxMjM1OTU5WjCBrjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYD
VQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYD
VQQLExhodHRwOi8vd3d3LnVzZXJ0cnVzdC5jb20xNjA0BgNVBAMTLVVUTi1VU0VSRmlyc3QtQ2xp
ZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBFbWFpbDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBALI5haTyfatBO2JGN67NwWB1vDll+UoaR6K5zEjMapjVTTUZuaRC5c5J4oovHnzSMQfHTrSD
ZJ0uKdWiZMSFvYVRNXmkTmiQexx6pJKoF/KYFfKTzMmkMpW7DE8wvZigC4vlbhuiRvp4vKJvq1le
pS/Pytptqi/rrKGzaqq3Lmc1i3nhHmmI4uZGzaCl6r4LznY6eg6b6vzaJ1s9cx8i5khhxkzzabGo
Lhu21DEgLLyCio6kDqXXiUP8FlqvHXHXEVnauocNr/rz4cLwpMVnjNbWVDreCqS6A3ezZcj9HtN0
YqoYymiTHqGFfvVHZcv4TVcodNI0/zC27vZiMBSMLOsCAwEAAaOCAScwggEjMB8GA1UdIwQYMBaA
FKARCiM+lvEH7OKvKe+CpX/QMKS0MB0GA1UdDgQWBBSJgmd9xJ0mcABLtFBIfN49rgRufTAOBgNV
HQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUH
AwQwEQYDVR0gBAowCDAGBgRVHSAAMHsGA1UdHwR0MHIwOKA2oDSGMmh0dHA6Ly9jcmwuY29tb2Rv
Y2EuY29tL0FBQUNlcnRpZmljYXRlU2VydmljZXMuY3JsMDagNKAyhjBodHRwOi8vY3JsLmNvbW9k
by5uZXQvQUFBQ2VydGlmaWNhdGVTZXJ2aWNlcy5jcmwwEQYJYIZIAYb4QgEBBAQDAgEGMA0GCSqG
SIb3DQEBBQUAA4IBAQCdlcs8uH6lCcQevwvCx3aOOTyUxhCqTwzJ4KuEXYlU4GU7820cfDcsJVRf
liH8N4SRnRXcFE+Bz1Qda2xFYMct+ZdRTPlmyjyggoymyPDi6dRK+ew/VsnddozDggFPbADzHhph
dARHA6nGQFeRvGUixSdnT1fbZFrZjR+6hi/0Bq6cae3p9M8pF9jgSp8aIC+XTFG7RgfEijdOIOMJ
MWjHnsSLneh+EbwyaBCWEZhE2CpRYE2I63Q630MGMsg5Vow6EVLTQaRDA/Tt7zMn2zngFE4mydj1
OeKJuJNdtykmQeqzm66D/Hd1yujKtf7iZUpjPkTE0MNeh3OpmByvfxV/MIIFajCCBFKgAwIBAgIQ
YcOeSMr+SboU7E8CNVWuhDANBgkqhkiG9w0BAQUFADCBrjELMAkGA1UEBhMCVVMxCzAJBgNVBAgT
AlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3
b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVzZXJ0cnVzdC5jb20xNjA0BgNVBAMTLVVUTi1VU0VS
Rmlyc3QtQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBFbWFpbDAeFw0xMDExMTcwMDAwMDBaFw0x
MTExMTcyMzU5NTlaMB8xHTAbBgkqhkiG9w0BCQEWDmJyYW1lc2hAdnQuZWR1MIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsK1UEXu6lbG6ggSIHF8f65XaOGcpxNiqSHp7EJk7v3FcJ9aY
2/jFUQcQPc2FwZMKvRdOGOEsnX71hxOTo+K3lPNa8D5Aijv4qck+bt/p7xZOPPvJrTTnA0Y+gJev
WeblYh8GV8OCassour7rHxXxlteeBq5mIQ4ha0zaozLlAIhXGBTPtNX2yu40cQ3my/kWqAxB6tjk
XFb3oR/UaROC/zivQeDj3pVvdSeUA1vDag9K0gr0svKEy1qvj9D0j7Yj9czjm7ZdZXbkYwplQBaw
4Wjx2o6g93MuNroozvly+0HNi1x3GJdGuOrI4pZMXTitDk4CNwQALp2iq3NwFIYUCQIDAQABo4IC
EDCCAgwwHwYDVR0jBBgwFoAUiYJnfcSdJnAAS7RQSHzePa4Ebn0wHQYDVR0OBBYEFHtZ/WL8KZ/o
2o7Q6DSPYyhCVQxbMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMCAGA1UdJQQZMBcGCCsG
AQUFBwMEBgsrBgEEAbIxAQMFAjARBglghkgBhvhCAQEEBAMCBSAwRgYDVR0gBD8wPTA7BgwrBgEE
AbIxAQIBAQEwKzApBggrBgEFBQcCARYdaHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwgaUG
A1UdHwSBnTCBmjBMoEqgSIZGaHR0cDovL2NybC5jb21vZG9jYS5jb20vVVROLVVTRVJGaXJzdC1D
bGllbnRBdXRoZW50aWNhdGlvbmFuZEVtYWlsLmNybDBKoEigRoZEaHR0cDovL2NybC5jb21vZG8u
bmV0L1VUTi1VU0VSRmlyc3QtQ2xpZW50QXV0aGVudGljYXRpb25hbmRFbWFpbC5jcmwwbAYIKwYB
BQUHAQEEYDBeMDYGCCsGAQUFBzAChipodHRwOi8vY3J0LmNvbW9kb2NhLmNvbS9VVE5BQUFDbGll
bnRDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAZBgNVHREEEjAQ
gQ5icmFtZXNoQHZ0LmVkdTANBgkqhkiG9w0BAQUFAAOCAQEAQTpK/RfJMVCzOKIhI+VqhXFeAbFx
zVyrzqomWrBHB1/EWXxnKZBCt1hYgutlGarCnHxomphRD9FCmrbvQS7M803iLlfWLb8PGnu9z15Q
jKp+7tbNS7PgJwehr7nfl6IZv9o9M0nCY/CGXdfJUYpEmNgM0ZpIrD6tnhGa+CDOO+rxcMznf/Mi
V+UpL+qIPrRupYY8fnDrLg+HP0ZvXtFyehvGYN1mbqloUx4iDELa999M166iFjxoJsKNodhRvy4/
iCGrkMgfSUI0RBA2whQ0jAQtPcQ1mXZ7QSNxXUN8tHQU5DWodhIPu41MooGPoyjxj51XuiR7r0j/
Pwf+hUasrjGCBLYwggSyAgEBMIHDMIGuMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNV
BAcTDlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxITAfBgNV
BAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTE2MDQGA1UEAxMtVVROLVVTRVJGaXJzdC1DbGll
bnQgQXV0aGVudGljYXRpb24gYW5kIEVtYWlsAhBhw55Iyv5JuhTsTwI1Va6EMAkGBSsOAwIaBQCg
ggLHMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTExMDIyNTE2MzIy
NVowIwYJKoZIhvcNAQkEMRYEFKwSeYpUE+Mh9LPjp9RZNkCLRqtBMIG3BgkqhkiG9w0BCQ8xgakw
gaYwCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjAKBggqhkiG9w0DBzALBglghkgBZQMEAQIwDgYI
KoZIhvcNAwICAgCAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgFAMA0GCCqGSIb3DQMCAgEoMAcGBSsO
AwIaMAsGCWCGSAFlAwQCAzALBglghkgBZQMEAgIwCwYJYIZIAWUDBAIBMAoGCCqGSIb3DQIFMIHU
BgkrBgEEAYI3EAQxgcYwgcMwga4xCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMO
U2FsdCBMYWtlIENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMY
aHR0cDovL3d3dy51c2VydHJ1c3QuY29tMTYwNAYDVQQDEy1VVE4tVVNFUkZpcnN0LUNsaWVudCBB
dXRoZW50aWNhdGlvbiBhbmQgRW1haWwCEGHDnkjK/km6FOxPAjVVroQwgdYGCyqGSIb3DQEJEAIL
MYHGoIHDMIGuMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcTDlNhbHQgTGFrZSBD
aXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxITAfBgNVBAsTGGh0dHA6Ly93d3cu
dXNlcnRydXN0LmNvbTE2MDQGA1UEAxMtVVROLVVTRVJGaXJzdC1DbGllbnQgQXV0aGVudGljYXRp
b24gYW5kIEVtYWlsAhBhw55Iyv5JuhTsTwI1Va6EMA0GCSqGSIb3DQEBAQUABIIBAF2fiU2BoZXk
LVlj+rMJTGGtRqk9ZTwbUH7B+ESCoBrHwbm3XFjx10RB0XAVB25GwEpDi5ALjZeYxHYHDdK1WLr1
PpYB5+7JNIst4ge4rypgUO9rp4K9Vmvk0ni6RdKC5LfQMyb+/pMGbqdI4qBSaWbB3eueSXX2FqMS
y4oe5Ctc7c39fbNVEAaKJ3PDZh4AuD3BVQYcJqe4q9ETDjDUgZAUDsn9w7cFFKQlb5yl+nwyIh+p
IVa8zYFBija1I5pqUCtsnyWzWjNahxOSG5LsmQzi8zLPU8JPptfc5Rxa3X1WASZzhrmcAML1g7uD
NSYblPKjk+3lRi5DlIpiYf6TGeoAAAAAAAA=

------=_NextPart_000_00EF_01CBD4DF.ACE25260--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
