From: Bharath Ramesh <bramesh-PjAqaU27lzQ@public.gmane.org>
Subject: Re: Question on mlx4 log_num_mtt and log_mtt_per_seg setting
Date: Mon, 21 Jan 2013 13:13:15 -0500
Message-ID: <50FD853B.7090705@vt.edu>
References: <50FCB147.7090303@vt.edu> <CAL3tnx4XSQ+iozQpH8btYoDVoYy+715mOJ9zundvdek0e4o6Qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms040500060104050205030600"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL3tnx4XSQ+iozQpH8btYoDVoYy+715mOJ9zundvdek0e4o6Qw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms040500060104050205030600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Eli,
     Thanks a lot for this explanation of the MTT and how=20
log_mtt_per_seg log_num_mtt work. I will play around with these values=20
and figure which one works best for our cluster + application environment=
=2E

--
Bharath

On 1/21/2013 11:57 AM, Eli Cohen wrote:
> Hi Bharath,
>
> each MTT entry is used to cover a whole page. Assuming page size in
> you system equals 4K, the max total of registered memory is 2^(12+24)
> which is 64 GB.
> The log_mtt_per_seg param denotes the granularity of the allocator
> managing MTTs. So, in your case, MTTs are allocated in granularity of
> 2. So if you try to allocate 3 MTTs, you'll end up consuming 4.
> Moreover, the MTT allocator is a buddy allocator that allocates power
> of 2 MTT segments. So if you register memory that requires (2^15 + 1)
> MTTs, you'll actually consume 2^16 MTTs!
>
> In your case I would try to use 2^25 MTTs and log_mtt_per_seg=3D1. If
> the driver fails to load (probably because the allocator fails to
> allocate memory), try to use 2^24 and 2^2 etc.
>
> I hope that helps.
>
>
>
> On Mon, Jan 21, 2013 at 5:08 AM, Bharath Ramesh <bramesh-PjAqaU27lzQ@public.gmane.org> wrote:=

>> I am trying to find the correct setting for log_num_mtt and log_mtt_pe=
r_seg
>> should be for our cluster. Each node has 64G of RAM. We are having iss=
ues
>> when running MPI applications, the error is related to registering mem=
ory.
>> The current setting log_num_mtt=3D24 and log_mtt_per_seg=3D1. There ar=
e lot of
>> conflicting documentations available with regards how these settings s=
hould
>> be changed. I was wondering if the community could explain how these
>> settings works so that we can come up with the correct settings that w=
ill
>> work in our environment. This document [1] specifically says that
>> log_mtt_per_seg should always be 1. However, OpenMPI mailing list post=
 [2]
>> talks about different value. Any help on this is appreciated. I am not=

>> subscribed to the list so would really appreciate if I am copied in th=
e
>> replies.
>>
>> [1] http://www.open-mpi.org/faq/?category=3Dopenfabrics#ib-low-reg-mem=

>> [2] http://www.open-mpi.org/community/lists/users/2011/09/17222.php
>>
>> --
>> Bharath
>>
>>


--=20
Bharath



--------------ms040500060104050205030600
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
DTEzMDEyMTE4MTMxNVowIwYJKoZIhvcNAQkEMRYEFMf1/MDW6pTHKqsytreQgNwF5dOGMGwG
CSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAO
BggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgw
gboGCSsGAQQBgjcQBDGBrDCBqTCBkzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0
ZWQxOTA3BgNVBAMTMENPTU9ETyBDbGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBF
bWFpbCBDQQIRAN22Q2v22Zy9hskOYaOi3XkwgbwGCyqGSIb3DQEJEAILMYGsoIGpMIGTMQsw
CQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxm
b3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE5MDcGA1UEAxMwQ09NT0RPIENsaWVu
dCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA3bZDa/bZnL2GyQ5ho6Ld
eTANBgkqhkiG9w0BAQEFAASCAQBXrQ7OzV1GtjXYdOgq4RQ+JuAhLYqLm0EVgbioC2eMSgTg
QkMtJRxepaGKm+9zp/VPDUrv2fG9mtzX+VWTUwEQOiq1svn47zJleJ/4GHbPbAigwgJph2us
NcBpOkwtN8KdSA6L3RTPDMol14+ozVJ7XSlLSFtYpApJ07NfZ6ylVU/gOavQi4ozWBzL8ioZ
+vG4Pprn3BNpntiaZwaVXOcuxnm8G9yh7sEygM2eH3bphryh/U0R+fnB3ky+1FONF3Hofexs
yhIWe/rC0y4PX7cA6ZxxdQoj06eYqYyHWPKTv2qk3nH26kDwzz064DX1PdkybibwmckquWzU
+cnxhzCAAAAAAAAA
--------------ms040500060104050205030600--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
