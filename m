From: Bharath Ramesh <bramesh-PjAqaU27lzQ@public.gmane.org>
Subject: Re: Intermitted "Failed to obtain HW semaphore, aborting" error
Date: Sun, 03 Feb 2013 10:18:14 -0500
Message-ID: <510E7FB6.8050603@vt.edu>
References: <510DF227.30307@vt.edu> <510E0D9B.9020907@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060001010903010604030800"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <510E0D9B.9020907-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms060001010903010604030800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2/3/2013 2:11 AM, Or Gerlitz wrote:
> On 03/02/2013 07:14, Bharath Ramesh wrote:
>> Intermittently a couple of nodes in our cluster throw the error=20
>> "Failed to obtain HW semaphore, aborting" on boot. When this error=20
>> occurs we are unable to use IB on those nodes, unloading and=20
>> reloading the module doesnt help.=20
>
> load mlx4_core with debug_level=3D1 and send the resulted dmesg along=20
> with the lspci info of the card ("$ lspci | grep Mellanox")
The same node will come up fine on some reboots and on others I will get =

this error. Here is the output from lspci
$ lspci | grep Mellanox
01:00.0 Network controller: Mellanox Technologies MT27500 Family=20
[ConnectX-3]

dmesg output trying to load mlx4_core with debug_level=3D1

mlx4_core: Mellanox ConnectX core driver v1.0-ofed1.5.4 (November 10, 201=
1)
mlx4_core: Initializing 0000:01:00.0
mlx4_core 0000:01:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
mlx4_core 0000:01:00.0: setting latency timer to 64
Uhhuh. NMI received for unknown reason 31 on CPU 0.
Do you have a strange power saving mode enabled?
Dazed and confused, but trying to continue
Uhhuh. NMI received for unknown reason 31 on CPU 0.
Do you have a strange power saving mode enabled?
Dazed and confused, but trying to continue
Uhhuh. NMI received for unknown reason 21 on CPU 0.
Do you have a strange power saving mode enabled?
Dazed and confused, but trying to continue
mlx4_core 0000:01:00.0: Failed to obtain HW semaphore, aborting
mlx4_core 0000:01:00.0: Failed to reset HCA, aborting.
mlx4_core 0000:01:00.0: PCI INT A disabled
mlx4_core: probe of 0000:01:00.0 failed with error -11

I am unable to run ibv_devinfo on the bad node, here is an output from a =

good node
$ ibv_devinfo
hca_id: mlx4_0
         transport:                      InfiniBand (0)
         fw_ver:                         2.10.2370
         node_guid:                      001e:6703:003c:dff4
         sys_image_guid:                 001e:6703:003c:dff7
         vendor_id:                      0x02c9
         vendor_part_id:                 4099
         hw_ver:                         0x0
         board_id:                       INCX-3I358C10501
         phys_port_cnt:                  1
                 port:   1
                         state:                  PORT_ACTIVE (4)
                         max_mtu:                2048 (4)
                         active_mtu:             2048 (4)
                         sm_lid:                 358
                         port_lid:               331
                         port_lmc:               0x00
                         link_layer:             IB

--=20
Bharath



--------------ms060001010903010604030800
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIKQDCC
BRowggQCoAMCAQICEG0Z6qcZT2ozIuYiMnqqcd4wDQYJKoZIhvcNAQEFBQAwga4xCzAJBgNV
BAYTAlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3Qu
Y29tMTYwNAYDVQQDEy1VVE4tVVNFUkZpcnN0LUNsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQg
RW1haWwwHhcNMTEwNDI4MDAwMDAwWhcNMjAwNTMwMTA0ODM4WjCBkzELMAkGA1UEBhMCR0Ix
GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UE
ChMRQ09NT0RPIENBIExpbWl0ZWQxOTA3BgNVBAMTMENPTU9ETyBDbGllbnQgQXV0aGVudGlj
YXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAJKEhFtLV5jUXi+LpOFAyKNTWF9mZfEyTvefMn1V0HhMVbdClOD5J3EHxcZppLkyxPFA
GpDMJ1Zifxe1cWmu5SAb5MtjXmDKokH2auGj/7jfH0htZUOMKi4rYzh337EXrMLaggLW1DJq
1GdvIBOPXDX65VSAr9hxCh03CgJQU2yVHakQFLSZlVkSMf8JotJM3FLb3uJAAVtIaN3FSrTg
7SQfOq9xXwfjrL8UO7AlcWg99A/WF1hGFYE8aIuLgw9teiFX5jSw2zJ+40rhpVJyZCaRTqWS
D//gsWD9Gm9oUZljjRqLpcxCm5t9ImPTqaD8zp6Q30QZ9FxbNboW86eb/8ECAwEAAaOCAUsw
ggFHMB8GA1UdIwQYMBaAFImCZ33EnSZwAEu0UEh83j2uBG59MB0GA1UdDgQWBBR6E04AdFvG
eGNkJ8Ev4qBbvHnFezAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBADARBgNV
HSAECjAIMAYGBFUdIAAwWAYDVR0fBFEwTzBNoEugSYZHaHR0cDovL2NybC51c2VydHJ1c3Qu
Y29tL1VUTi1VU0VSRmlyc3QtQ2xpZW50QXV0aGVudGljYXRpb25hbmRFbWFpbC5jcmwwdAYI
KwYBBQUHAQEEaDBmMD0GCCsGAQUFBzAChjFodHRwOi8vY3J0LnVzZXJ0cnVzdC5jb20vVVRO
QWRkVHJ1c3RDbGllbnRfQ0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1
c3QuY29tMA0GCSqGSIb3DQEBBQUAA4IBAQCF1r54V1VtM39EUv5C1QaoAQOAivsNsv1Kv/av
QUn1G1rF0q0bc24+6SZ85kyYwTAo38v7QjyhJT4KddbQPTmGZtGhm7VNm2+vKGwdr+XqdFqo
2rHA8XV6L566k3nK/uKRHlZ0sviN0+BDchvtj/1gOSBH+4uvOmVIPJg9pSW/ve9g4EnlFsjr
P0OD8ODuDcHTzTNfm9C9YGqzO/761Mk6PB/tm/+bSTO+Qik5g+4zaS6CnUVNqGnagBsePdIa
XXxHmaWbCG0SmYbWXVcHG6cwvktJRLiQfsrReTjrtDP6oDpdJlieYVUYtCHVmdXgQ0BCML7q
peeU0rD+83X5f27nMIIFHjCCBAagAwIBAgIRAN22Q2v22Zy9hskOYaOi3XkwDQYJKoZIhvcN
AQEFBQAwgZMxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAO
BgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMTkwNwYDVQQDEzBD
T01PRE8gQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTIx
MTE5MDAwMDAwWhcNMTMxMTE5MjM1OTU5WjAfMR0wGwYJKoZIhvcNAQkBFg5icmFtZXNoQHZ0
LmVkdTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANh81vYaLvDNeNh1+oJe44bN
7FPrbo3WJAJpulUEnBH2MvxWP+oyxdFOcWB7msjRrC8ftYaEVl4K9m768rmfWho4iCiyW6uQ
upTDRLrPrhvyoDIsILfy69ayWA/aUph0NVrwnZy4GsZ4bHSjXfLoh3fN6lJN2+8CxbYDSNar
xIx2fn124IHtIz4e7euRi6qg+W5lFCoFNWmCuEaKSHKkwHd4I8Sw6R702BOsZ9+bEpybkm/h
k1JmLg6HJDP1K1eL1jsD2XCBbFBWiRWya1DCyqsvzcqXtgaaU+iGaOJMUHQlE1ogxXgl/X4L
jCkwq7//WUScJhHv2ZBF1k1694gRbPsCAwEAAaOCAd4wggHaMB8GA1UdIwQYMBaAFHoTTgB0
W8Z4Y2QnwS/ioFu8ecV7MB0GA1UdDgQWBBQ3y6VnkWY6FF4mjVobS4yBWoM5FzAOBgNVHQ8B
Af8EBAMCBaAwDAYDVR0TAQH/BAIwADAgBgNVHSUEGTAXBggrBgEFBQcDBAYLKwYBBAGyMQED
BQIwEQYJYIZIAYb4QgEBBAQDAgUgMEYGA1UdIAQ/MD0wOwYMKwYBBAGyMQECAQEBMCswKQYI
KwYBBQUHAgEWHWh0dHBzOi8vc2VjdXJlLmNvbW9kby5uZXQvQ1BTMFcGA1UdHwRQME4wTKBK
oEiGRmh0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0NPTU9ET0NsaWVudEF1dGhlbnRpY2F0aW9u
YW5kU2VjdXJlRW1haWxDQS5jcmwwgYgGCCsGAQUFBwEBBHwwejBSBggrBgEFBQcwAoZGaHR0
cDovL2NydC5jb21vZG9jYS5jb20vQ09NT0RPQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1
cmVFbWFpbENBLmNydDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuY29tb2RvY2EuY29tMBkG
A1UdEQQSMBCBDmJyYW1lc2hAdnQuZWR1MA0GCSqGSIb3DQEBBQUAA4IBAQBpORr1+kAak071
YWHyJH8wedMGNycEXjZdKAOKQesWrfn3HivapKvG/uVcDQxzHZOt0rJuukoPnVAQrs4/XJZt
Lc6B+e0A/Q6l0rYHxli4szpnXPjo0QUJ/DSY+DXQ8O8DnIHfY0dQoXRlncOAmeDz3IqZpWMO
g6wQWATiFXV/a59tXTvAdEpFFfkCq9K7CHWmQSHhEoN2T4Ww5GS5rUFauUgkAXns//NppUBB
5uAAswFyXYaqm/LuSbcKpXtfsnZnYqFWFVwmiD5ZANnHVCgdBCpdg5Crw1cKoES+JoyTUDiK
PeZ/HuzuXe/LVMVnBBeulIaReqFga/lqlNCbL4k7MYIEHDCCBBgCAQEwgakwgZMxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQx
GjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMTkwNwYDVQQDEzBDT01PRE8gQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDdtkNr9tmcvYbJDmGjot15MAkG
BSsOAwIaBQCgggJHMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8X
DTEzMDIwMzE1MTgxNFowIwYJKoZIhvcNAQkEMRYEFBqINSRLkIFRCDHHefRGnU78GhwRMGwG
CSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAO
BggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgw
gboGCSsGAQQBgjcQBDGBrDCBqTCBkzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0
ZWQxOTA3BgNVBAMTMENPTU9ETyBDbGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBF
bWFpbCBDQQIRAN22Q2v22Zy9hskOYaOi3XkwgbwGCyqGSIb3DQEJEAILMYGsoIGpMIGTMQsw
CQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxm
b3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE5MDcGA1UEAxMwQ09NT0RPIENsaWVu
dCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA3bZDa/bZnL2GyQ5ho6Ld
eTANBgkqhkiG9w0BAQEFAASCAQBQWvRebex//Yi8ygS22eb3yKu89uxxnMvmpSriR1Cq+qbq
bHIG5ZYL743Km2esSzVuKdEgCqsCsodOoaw8ue6sMkgyr/i90CRcBCD1fL6mww4VnQV0BBbE
7FQGnSKbltlrFAw8pEmjD868P6gXYJYvFPl1fCl9h1aifw5iVPfHalwUCw3nWXjKWTVecTgX
JC5KpTTMV2cIXrYlwZN2mKji/CqIAveLk6tr+Jj8uurZh7HOjDgAEiyF4RY4IBYHfyCFHdqz
+wObHZ+X/KnoPAJIFaUXkZLZDHxUHFxlpX87dV/JDhfuQtM50pbP5SCj9GJNWejqpVTCgtBP
xgRqe6EtAAAAAAAA
--------------ms060001010903010604030800--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
