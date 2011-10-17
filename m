From: Karl Schulz <karl-Tmo6s3XX3Xr5xfTjtVVUew@public.gmane.org>
Subject: Re: OpenSM plugin patch request
Date: Mon, 17 Oct 2011 21:43:23 +0000
Message-ID: <60C1A845-5973-45E1-B78C-BE816F86BEEF@tacc.utexas.edu>
References: <6F2B8AE5-D38D-41B3-A237-CBC26680C4FF@tacc.utexas.edu>
 <20111012151359.f1876bd3.weiny2@llnl.gov>
 <18FD0A9E-4227-4CC9-B6EB-D451B80920F1@tacc.utexas.edu>
 <4E96DE86.109@mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_60C1A845597345E1B78CBE816F86BEEFtaccutexasedu_"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E96DE86.109-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "<kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>" <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--_002_60C1A845597345E1B78CBE816F86BEEFtaccutexasedu_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28E723E8A7285B4589CAC7859EC5A022-H8qjcnOI+J1gYfp1RNbdJ4dd74u8MsAO@public.gmane.org>
Content-Transfer-Encoding: quoted-printable

Thanks for explaining the enum convention - quite logical indeed.  Also, th=
anks for some of the off-list discussion where we tried to see if any of th=
e current event callbacks could be used to achieve the desired support.  As=
 it stands, it still sounds like including light sweep events is the simple=
st solution and I'm attaching an updated patch for consideration which hono=
rs the MAX convention.

Thanks,

Karl


On Oct 13, 2011, at 7:50 AM, Yevgeny Kliteynik wrote:

> Hi Karl,
>=20
>=20
> The idea in that if the received event is >=3D OSM_EVENT_ID_MAX,
>=20
> then the plug-in knows that something went wrong (wrong version,
>=20
> something changed in API, etc).
>=20
>=20
> Also, you might want to know about more stuff if you're pulling
> topology/routing info from SM, such as when SM became stand-by
> and when it became master, and when re-route was done.
>=20
> Please see this patch for reference:
>=20
>=20
> http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg02206.html
>=20
>=20
> It wasn't applied as is back then, but you might want it now.
>=20
>=20
> -- YK
>=20
>=20
>=20
> On 13-Oct-11 4:50 AM, Karl Schulz wrote:
>=20
>> Thanks Ira,
>>=20
>> My apologies for not following the conventional standard.  Should I gene=
rate a new patch?
>>=20
>> -k
>>=20
>> On Oct 12, 2011, at 5:13 PM, Ira Weiny wrote:
>>=20
>>> I think this is a reasonable idea.
>>>=20
>>> Comment on the patch.
>>>=20
>>> -   OSM_EVENT_ID_MAX
>>> +   OSM_EVENT_ID_MAX,
>>> +   OSM_EVENT_ID_LIGHT_SWEEP_START,=20
>>> +   OSM_EVENT_ID_LIGHT_SWEEP_DONE, =20
>>>=20
>>> Traditionally the "MAX" value in the enum is kept at the end.
>>>=20
>>> Ira
>>>=20
>>>=20
>>> On Wed, 12 Oct 2011 14:31:07 -0700
>>> Karl Schulz<karl-Tmo6s3XX3Xr5xfTjtVVUew@public.gmane.org>  wrote:
>>>=20
>>>> Hello,
>>>>=20
>>>> Would it be possible to consider exposing light-sweep events to the cu=
rrent OpenSM plugin interface?  Something along the lines of the attached p=
atch is what we are using locally against opensm-3.3.9.
>>>>=20
>>>> The motivation is to support a plugin module we have written to expose=
 topology information to a query service which can be used by MPI stacks (i=
n user-space) for topology-aware optimization and for topology-aware schedu=
ling via batch systems.
>>>>=20
>>>> Thanks for the consideration,
>>>>=20
>>>> Karl
>>>>=20
>>>=20
>>> --=20
>>> Ira Weiny
>>> Member of Technical Staff
>>> Lawrence Livermore National Lab
>>> 925-423-8008
>>> weiny2-i2BcT+NCU+M@public.gmane.org
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20


--_002_60C1A845597345E1B78CBE816F86BEEFtaccutexasedu_
Content-Type: application/octet-stream; name="opensm.patch"
Content-Description: opensm.patch
Content-Disposition: attachment; filename="opensm.patch"; size=1316;
	creation-date="Mon, 17 Oct 2011 21:43:23 GMT";
	modification-date="Mon, 17 Oct 2011 21:43:23 GMT"
Content-ID: <6BE0A21088954B4FBCEDF70D38ECE369-H8qjcnOI+J1gYfp1RNbdJ4dd74u8MsAO@public.gmane.org>
Content-Transfer-Encoding: base64

LS0tIG9wZW5zbS9vc21fc3RhdGVfbWdyLmMJMjAxMS0wOC0wOCAxODozNjozOC4wMDAwMDAwMDAg
LTA1MDANCisrKyBvcGVuc20vb3NtX3N0YXRlX21nci5jCTIwMTEtMTAtMTIgMTY6MTg6NDMuMDAw
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
KysrIGluY2x1ZGUvb3BlbnNtL29zbV9ldmVudF9wbHVnaW4uaAkyMDExLTEwLTE3IDE2OjEwOjQz
LjAwMDAwMDAwMCAtMDUwMA0KQEAgLTY2LDYgKzY2LDcgQEANCiAvKiogPT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PQ0KICAqIEV2ZW50IHR5cGVzDQogICovDQorDQogdHlwZWRlZiBlbnVtIHsNCiAJT1NNX0VWRU5U
X0lEX1BPUlRfRVJST1JTID0gMCwNCiAJT1NNX0VWRU5UX0lEX1BPUlRfREFUQV9DT1VOVEVSUywN
CkBAIC03Nyw3ICs3OCw5IEBADQogCU9TTV9FVkVOVF9JRF9VQ0FTVF9ST1VUSU5HX0RPTkUsDQog
CU9TTV9FVkVOVF9JRF9TVEFURV9DSEFOR0UsDQogCU9TTV9FVkVOVF9JRF9TQV9EQl9EVU1QRUQs
DQotCU9TTV9FVkVOVF9JRF9NQVgNCisJT1NNX0VWRU5UX0lEX0xJR0hUX1NXRUVQX1NUQVJULAkN
CisJT1NNX0VWRU5UX0lEX0xJR0hUX1NXRUVQX0RPTkUsCQ0KKwlPU01fRVZFTlRfSURfTUFYLA0K
IH0gb3NtX2VwaV9ldmVudF9pZF90Ow0KIA0KIHR5cGVkZWYgc3RydWN0IG9zbV9lcGlfcG9ydF9p
ZCB7DQo=

--_002_60C1A845597345E1B78CBE816F86BEEFtaccutexasedu_--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
