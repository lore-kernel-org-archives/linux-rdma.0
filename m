From: Karl Schulz <karl-Tmo6s3XX3Xr5xfTjtVVUew@public.gmane.org>
Subject: Re: OpenSM plugin patch request
Date: Mon, 24 Oct 2011 18:57:33 +0000
Message-ID: <493B1FB8-7ED1-455D-94B0-4D4B9829C0A1@tacc.utexas.edu>
References: <6F2B8AE5-D38D-41B3-A237-CBC26680C4FF@tacc.utexas.edu>
 <20111012151359.f1876bd3.weiny2@llnl.gov>
 <18FD0A9E-4227-4CC9-B6EB-D451B80920F1@tacc.utexas.edu>
 <4E96DE86.109@mellanox.co.il>
 <60C1A845-5973-45E1-B78C-BE816F86BEEF@tacc.utexas.edu>
 <4E9CAC24.1010101@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_003_493B1FB87ED1455D94B04D4B9829C0A1taccutexasedu_"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E9CAC24.1010101-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "<kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>" <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--_003_493B1FB87ED1455D94B04D4B9829C0A1taccutexasedu_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5CBE98EF6F00A54F8C42742B686E36BC-H8qjcnOI+J1gYfp1RNbdJ4dd74u8MsAO@public.gmane.org>
Content-Transfer-Encoding: quoted-printable

On Oct 17, 2011, at 5:28 PM, Hal Rosenstock wrote:

>=20
> A couple of minor comments:
>=20
> 1. Why not move the OSM_EVENT_ID_LIGHT_SWEEP_DONE event to where "LIGHT
> SWEEP COMPLETE" is indicated in osm_state_mgr.c ? That's actually more
> accurate as all the transactions have completed.
>=20
> 2. The new events should be added to osmeventplugin/src/osmeventplugin.c
> example.
>=20
> Thanks.
>=20
> -- Hal
>=20

Thanks for the comments.  The attached osm_light_sweep.patch addresses the =
points above by moving the OSM_EVENT_ID_LIGHT_SWEEP_DONE event to be with i=
t's corresponding LIGHT SWEEP COMPLETE log message.  Also, the light sweep =
START/DONE events are included in the example event plugin.=20

While adding to the example event plugin, I realized that the autoconf setu=
p in 3.3.9 does not appear to be propagating all user settings down into th=
e default plugin.  Consequently, I was not able to build the plugin when OF=
ED headers were not in the default location.   In case it's useful (and has=
n't already been addressed), the second attached patch adds  $(OSMV_INCLUDE=
S) to the automake directives for the plugin which was sufficient in my cas=
e to resolve necessary headers.

Thanks,

Karl




--_003_493B1FB87ED1455D94B04D4B9829C0A1taccutexasedu_
Content-Type: application/octet-stream; name="osm_light_sweep.patch"
Content-Description: osm_light_sweep.patch
Content-Disposition: attachment; filename="osm_light_sweep.patch"; size=1738;
	creation-date="Mon, 24 Oct 2011 18:57:33 GMT";
	modification-date="Mon, 24 Oct 2011 18:57:33 GMT"
Content-ID: <839D6737961CBD40ACEA36C5B37D5A53-H8qjcnOI+J1gYfp1RNbdJ4dd74u8MsAO@public.gmane.org>
Content-Transfer-Encoding: base64

LS0tIGluY2x1ZGUvb3BlbnNtL29zbV9ldmVudF9wbHVnaW4uaAkyMDExLTA4LTA4IDE4OjQwOjE5
LjAwMDAwMDAwMCAtMDUwMA0KKysrIGluY2x1ZGUvb3BlbnNtL29zbV9ldmVudF9wbHVnaW4uaAky
MDExLTEwLTI0IDA4OjEzOjA1LjAwMDAwMDAwMCAtMDUwMA0KQEAgLTc3LDcgKzc3LDkgQEANCiAJ
T1NNX0VWRU5UX0lEX1VDQVNUX1JPVVRJTkdfRE9ORSwNCiAJT1NNX0VWRU5UX0lEX1NUQVRFX0NI
QU5HRSwNCiAJT1NNX0VWRU5UX0lEX1NBX0RCX0RVTVBFRCwNCi0JT1NNX0VWRU5UX0lEX01BWA0K
KwlPU01fRVZFTlRfSURfTElHSFRfU1dFRVBfU1RBUlQsDQorCU9TTV9FVkVOVF9JRF9MSUdIVF9T
V0VFUF9ET05FLA0KKwlPU01fRVZFTlRfSURfTUFYLA0KIH0gb3NtX2VwaV9ldmVudF9pZF90Ow0K
DQogdHlwZWRlZiBzdHJ1Y3Qgb3NtX2VwaV9wb3J0X2lkIHsNCi0tLSBvcGVuc20vb3NtX3N0YXRl
X21nci5jLm9yaWcJMjAxMS0wOC0wOCAxODozNjozOC4wMDAwMDAwMDAgLTA1MDANCisrKyBvcGVu
c20vb3NtX3N0YXRlX21nci5jCTIwMTEtMTAtMjQgMDg6NTc6NDguMDAwMDAwMDAwIC0wNTAwDQpA
QCAtNjIwLDYgKzYyMCw5IEBADQogCX0NCg0KIAlPU01fTE9HX01TR19CT1goc20tPnBfbG9nLCBP
U01fTE9HX1ZFUkJPU0UsICJJTklUSUFUSU5HIExJR0hUIFNXRUVQIik7DQorCW9zbV9vcGVuc21f
cmVwb3J0X2V2ZW50KHNtLT5wX3N1Ym4tPnBfb3NtLA0KKwkJCQlPU01fRVZFTlRfSURfTElHSFRf
U1dFRVBfU1RBUlQsIE5VTEwpOw0KKw0KIAlDTF9QTE9DS19BQ1FVSVJFKHNtLT5wX2xvY2spOw0K
IAljbF9xbWFwX2FwcGx5X2Z1bmMocF9zd190YmwsIHN0YXRlX21ncl9nZXRfc3dfaW5mbywgc20p
Ow0KIAlDTF9QTE9DS19SRUxFQVNFKHNtLT5wX2xvY2spOw0KQEAgLTExMTMsNiArMTExNiw4IEBA
DQogCQkJCQlPU01fRVZFTlRfSURfU0FfREJfRFVNUEVELCBOVUxMKTsNCiAJCQlPU01fTE9HX01T
R19CT1goc20tPnBfbG9nLCBPU01fTE9HX1ZFUkJPU0UsDQogCQkJCQkiTElHSFQgU1dFRVAgQ09N
UExFVEUiKTsNCisJCQlvc21fb3BlbnNtX3JlcG9ydF9ldmVudChzbS0+cF9zdWJuLT5wX29zbSwN
CisJCQkJCQlPU01fRVZFTlRfSURfTElHSFRfU1dFRVBfRE9ORSwgTlVMTCk7DQogCQkJcmV0dXJu
Ow0KIAkJfQ0KIAl9DQotLS0gb3NtZXZlbnRwbHVnaW4vc3JjL29zbWV2ZW50cGx1Z2luLmMJMjAx
MS0xMC0yNCAwODowNTowNC4wMDAwMDAwMDAgLTA1MDANCisrKyBvc21ldmVudHBsdWdpbi9zcmMv
b3NtZXZlbnRwbHVnaW4uYwkyMDExLTEwLTI0IDA4OjA1OjU1LjAwMDAwMDAwMCAtMDUwMA0KQEAg
LTE3Niw2ICsxNzYsMTIgQEANCiAJY2FzZSBPU01fRVZFTlRfSURfU1VCTkVUX1VQOg0KIAkJZnBy
aW50Zihsb2ctPmxvZ19maWxlLCAiU3VibmV0IHVwIHJlcG9ydGVkXG4iKTsNCiAJCWJyZWFrOw0K
KwljYXNlIE9TTV9FVkVOVF9JRF9MSUdIVF9TV0VFUF9TVEFSVDoNCisJCWZwcmludGYobG9nLT5s
b2dfZmlsZSwgIkxpZ2h0IHN3ZWVwIHN0YXJ0ZWRcbiIpOw0KKwkJYnJlYWs7DQorCWNhc2UgT1NN
X0VWRU5UX0lEX0xJR0hUX1NXRUVQX0RPTkU6DQorCQlmcHJpbnRmKGxvZy0+bG9nX2ZpbGUsICJM
aWdodCBzd2VlcCBjb21wbGV0ZWRcbiIpOw0KKwkJYnJlYWs7DQogCWNhc2UgT1NNX0VWRU5UX0lE
X0hFQVZZX1NXRUVQX1NUQVJUOg0KIAkJZnByaW50Zihsb2ctPmxvZ19maWxlLCAiSGVhdnkgc3dl
ZXAgc3RhcnRlZFxuIik7DQogCQlicmVhazsNCg==

--_003_493B1FB87ED1455D94B04D4B9829C0A1taccutexasedu_
Content-Type: application/octet-stream; name="build.patch"
Content-Description: build.patch
Content-Disposition: attachment; filename="build.patch"; size=324;
	creation-date="Mon, 24 Oct 2011 18:57:33 GMT";
	modification-date="Mon, 24 Oct 2011 18:57:33 GMT"
Content-ID: <F9A6131E0334234E966A7E57070D4A16-H8qjcnOI+J1gYfp1RNbdJ4dd74u8MsAO@public.gmane.org>
Content-Transfer-Encoding: base64

LS0tIG9zbWV2ZW50cGx1Z2luL01ha2VmaWxlLmFtCTIwMTEtMTAtMjQgMDk6MjE6MjUuMDAwMDAw
MDAwIC0wNTAwDQorKysgb3NtZXZlbnRwbHVnaW4vTWFrZWZpbGUuYW0JMjAxMS0xMC0yNCAwOTox
ODowMC4wMDAwMDAwMDAgLTA1MDANCkBAIC0xLDYgKzEsNiBAQA0KIA0KIElOQ0xVREVTID0gLUkk
KHNyY2RpcikvLi4vaW5jbHVkZSBcDQotCSAgIC1JJChpbmNsdWRlZGlyKS9pbmZpbmliYW5kDQor
CSAgIC1JJChpbmNsdWRlZGlyKS9pbmZpbmliYW5kICQoT1NNVl9JTkNMVURFUykNCiANCiBsaWJf
TFRMSUJSQVJJRVMgPSBsaWJvc21ldmVudHBsdWdpbi5sYQ0KIA0K

--_003_493B1FB87ED1455D94B04D4B9829C0A1taccutexasedu_--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
