From: Karl Schulz <karl-Tmo6s3XX3Xr5xfTjtVVUew@public.gmane.org>
Subject: OpenSM plugin patch request
Date: Wed, 12 Oct 2011 21:31:07 +0000
Message-ID: <6F2B8AE5-D38D-41B3-A237-CBC26680C4FF@tacc.utexas.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_6F2B8AE5D38D41B3A237CBC26680C4FFtaccutexasedu_"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--_002_6F2B8AE5D38D41B3A237CBC26680C4FFtaccutexasedu_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EAFEA506DB61BB44AE8576A0D5033AC7-H8qjcnOI+J1gYfp1RNbdJ4dd74u8MsAO@public.gmane.org>
Content-Transfer-Encoding: quoted-printable

Hello,

Would it be possible to consider exposing light-sweep events to the current=
 OpenSM plugin interface?  Something along the lines of the attached patch =
is what we are using locally against opensm-3.3.9.

The motivation is to support a plugin module we have written to expose topo=
logy information to a query service which can be used by MPI stacks (in use=
r-space) for topology-aware optimization and for topology-aware scheduling =
via batch systems.=20

Thanks for the consideration,

Karl


--_002_6F2B8AE5D38D41B3A237CBC26680C4FFtaccutexasedu_
Content-Type: application/octet-stream; name="opensm.patch"
Content-Description: opensm.patch
Content-Disposition: attachment; filename="opensm.patch"; size=1316;
	creation-date="Wed, 12 Oct 2011 21:31:07 GMT";
	modification-date="Wed, 12 Oct 2011 21:31:07 GMT"
Content-ID: <6F01D283EC44E647AC87B7CFD9ECB9BD-H8qjcnOI+J1gYfp1RNbdJ4dd74u8MsAO@public.gmane.org>
Content-Transfer-Encoding: base64

LS0tIG9wZW5zbS9vc21fc3RhdGVfbWdyLmMJMjAxMS0wOC0wOCAxODozNjozOC4wMDAwMDAwMDAg
LTA1MDANCisrKyBvcGVuc20vb3NtX3N0YXRlX21nci5jCTIwMTEtMTAtMTIgMTU6NTU6MzkuMDAw
MDAwMDAwIC0wNTAwDQpAQCAtNjIwLDYgKzYyMCwxMSBAQA0KIAl9DQogDQogCU9TTV9MT0dfTVNH
X0JPWChzbS0+cF9sb2csIE9TTV9MT0dfVkVSQk9TRSwgIklOSVRJQVRJTkcgTElHSFQgU1dFRVAi
KTsNCisNCisJb3NtX29wZW5zbV9yZXBvcnRfZXZlbnQoc20tPnBfc3Vibi0+cF9vc20sDQorCQkJ
CU9TTV9FVkVOVF9JRF9MSUdIVF9TV0VFUF9TVEFSVCwgTlVMTCk7DQorDQorDQogCUNMX1BMT0NL
X0FDUVVJUkUoc20tPnBfbG9jayk7DQogCWNsX3FtYXBfYXBwbHlfZnVuYyhwX3N3X3RibCwgc3Rh
dGVfbWdyX2dldF9zd19pbmZvLCBzbSk7DQogCUNMX1BMT0NLX1JFTEVBU0Uoc20tPnBfbG9jayk7
DQpAQCAtNjYzLDYgKzY2OCw5IEBADQogDQogCUNMX1BMT0NLX1JFTEVBU0Uoc20tPnBfbG9jayk7
DQogDQorCW9zbV9vcGVuc21fcmVwb3J0X2V2ZW50KHNtLT5wX3N1Ym4tPnBfb3NtLA0KKwkJCQlP
U01fRVZFTlRfSURfTElHSFRfU1dFRVBfRE9ORSwgTlVMTCk7DQorDQogX2V4aXQ6DQogCU9TTV9M
T0dfRVhJVChzbS0+cF9sb2cpOw0KIAlyZXR1cm4gc3RhdHVzOw0KLS0tIGluY2x1ZGUvb3BlbnNt
L29zbV9ldmVudF9wbHVnaW4uaAkyMDExLTA4LTA4IDE4OjQwOjE5LjAwMDAwMDAwMCAtMDUwMA0K
KysrIGluY2x1ZGUvb3BlbnNtL29zbV9ldmVudF9wbHVnaW4uaAkyMDExLTEwLTEyIDE2OjAyOjMx
LjAwMDAwMDAwMCAtMDUwMA0KQEAgLTY2LDYgKzY2LDcgQEANCiAvKiogPT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PQ0KICAqIEV2ZW50IHR5cGVzDQogICovDQorDQogdHlwZWRlZiBlbnVtIHsNCiAJT1NNX0VWRU5U
X0lEX1BPUlRfRVJST1JTID0gMCwNCiAJT1NNX0VWRU5UX0lEX1BPUlRfREFUQV9DT1VOVEVSUywN
CkBAIC03Nyw3ICs3OCw5IEBADQogCU9TTV9FVkVOVF9JRF9VQ0FTVF9ST1VUSU5HX0RPTkUsDQog
CU9TTV9FVkVOVF9JRF9TVEFURV9DSEFOR0UsDQogCU9TTV9FVkVOVF9JRF9TQV9EQl9EVU1QRUQs
DQotCU9TTV9FVkVOVF9JRF9NQVgNCisJT1NNX0VWRU5UX0lEX01BWCwNCisJT1NNX0VWRU5UX0lE
X0xJR0hUX1NXRUVQX1NUQVJULAkNCisJT1NNX0VWRU5UX0lEX0xJR0hUX1NXRUVQX0RPTkUsCQ0K
IH0gb3NtX2VwaV9ldmVudF9pZF90Ow0KIA0KIHR5cGVkZWYgc3RydWN0IG9zbV9lcGlfcG9ydF9p
ZCB7DQo=

--_002_6F2B8AE5D38D41B3A237CBC26680C4FFtaccutexasedu_--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
