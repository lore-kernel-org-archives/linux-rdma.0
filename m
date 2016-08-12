From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [RFI] ucmatose: No effect to set service type for QoS
Date: Fri, 12 Aug 2016 15:10:05 +0200
Message-ID: <CAMGffEmsG7wMnFNP5VWx9imypNRXddaynQT1UU4ia-TTKF+psg@mail.gmail.com>
References: <CAMGffEn=dQsBzV9SPsVTJdsppJ65n_FFiRRASyrjwnmMNmCuDQ@mail.gmail.com>
 <170f9d79-2351-d95f-9ed1-eddedc467d68@dev.mellanox.co.il> <CAMGffEmP_ouVu5v1cGGENqD9dssgtAqTg39-xa6--NaUkf1aVw@mail.gmail.com>
 <dbf070a3-e6c0-74b6-9127-7f77e0594b2f@dev.mellanox.co.il> <CAMGffE=NRqut_4USfa31gDbdao2u7AabJD0BS+tP5mSwtED1Cg@mail.gmail.com>
 <853d9a54-2c05-669a-835b-f87b29d6da38@dev.mellanox.co.il> <fff82d1f-5aa4-0a63-c4d9-cccb8bf582e1@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1142e94c11975a0539df9b4c
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fff82d1f-5aa4-0a63-c4d9-cccb8bf582e1-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--001a1142e94c11975a0539df9b4c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 12, 2016 at 3:03 PM, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wr=
ote:
> On 8/12/2016 7:55 AM, Hal Rosenstock wrote:
>> On 8/12/2016 4:15 AM, Jinpu Wang wrote:
>>> On Thu, Aug 11, 2016 at 11:15 PM, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifUpdFzICT1y@public.gmane.org=
l> wrote:
>>>> On 8/11/2016 8:29 AM, Jinpu Wang wrote:
>>>>> On Wed, Aug 10, 2016 at 8:52 PM, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiiQ@public.gmane.org=
il> wrote:
>>>>>> On 8/9/2016 12:26 PM, Jinpu Wang wrote:
>>>>>>> Hi Sean,
>>>>>>>
>>>>>>> I'm testing QoS support for IB. I notice ucmatose has equally
>>>>>>> performance when set different service type, but set SL in ib_send_=
bw
>>>>>>> works well (different SL show different performance base on opensm
>>>>>>> settings)
>>>>>>>
>>>>>>> I capature packats using ibdump, it shows in in LRH the service lev=
el
>>>>>>> fields are all 0 when running traffic with ucmatose.
>>>>>>>
>>>>>>> When running ib_send_bw, it carries the right service level I set.
>>>>>>>
>>>>>>> Seems in rdma_set_service_type, it sets to tos to id_priv->tos, and
>>>>>>> lter set to path_rec->qos_class or traffic_class but not to sl
>>>>>>> directly, what's the consideration here?
>>>>>>> code snip:
>>>>>>>         switch (cma_family(id_priv)) {
>>>>>>>         case AF_INET:
>>>>>>>                 path_rec->qos_class =3D cpu_to_be16((u16) id_priv->=
tos);
>>>>>>>                 comp_mask |=3D IB_SA_PATH_REC_QOS_CLASS;
>>>>>>>                 break;
>>>>>>>         case AF_INET6:
>>>>>>>                 sin6 =3D (struct sockaddr_in6 *) cma_src_addr(id_pr=
iv);
>>>>>>>                 path_rec->traffic_class =3D (u8)
>>>>>>> (be32_to_cpu(sin6->sin6_flowinfo) >> 20);
>>>>>>>                 comp_mask |=3D IB_SA_PATH_REC_TRAFFIC_CLASS;
>>>>>>>                 break;
>>>>>>>         case AF_IB:
>>>>>>>                 sib =3D (struct sockaddr_ib *) cma_src_addr(id_priv=
);
>>>>>>>                 path_rec->traffic_class =3D (u8)
>>>>>>> (be32_to_cpu(sib->sib_flowinfo) >> 20);
>>>>>>>
>>>>>>>
>>>>>>> Does it make sense we also set sl here, or service type for ucmatos=
e
>>>>>>> is totally different with SL for ib_send_bw?
>>>>>>
>>>>>> I think this is an OpenSM configuration issue. QoS policy needs to b=
e
>>>>>> setup to return the proper SL to use for QoS class or TClass in the
>>>>>> PathRecord response.
>>>>>>
>>>>>> -- Hal
>>>>>>
>>>>> Thanks Hal,
>>>>>
>>>>> Configure extra QoS policy seems quite complex.
>>>>
>>>> Configuration complexity varies depending on the requirements of the Q=
oS
>>>> needs.
>>>>
>>>> Which type of RDMA CM connections are being used (IPv4, IPv6, or nativ=
e
>>>> IB) ?
>>>>
>>>>> Do you think patch attached make sense?
>>>>
>>>> Attached patch doesn't appear to relate to upstream.
>>>
>>> Indeed, it's based on MLNXOFED 3.2
>>>
>>>>
>>>> It also looks incomplete to me. What invokes rdma_set_service_level ? =
Is
>>>> it some option in ucma.c:ucma_set_option ?
>>>
>>> The main purpose is for our in house transport kernel module,
>
> One more thing:
>
> How does transport module know which SL to request ?
>
> In general, SL is based on SM configuration.
>
> Service ID and QoS Class or Traffic Class are the "higher level" IB
> architected ways to obtain the SL.
>
>>> it
>>> supports all 3 connections
>>> (IPv4, IPv6, and native IB, IB is the default).
>>
>>>> Current patch doesn't appear to me to be backward compatible. If
>>>> rdma_set_service_level is not called in flow, then SL should not be se=
t
>>>> in SA PR query which is what happens today.
>>>
>>> Good point, I will add check only set SL if not 0,
>>
>> 0 is a valid SL so an extra bit somewhere is needed to indicate whether
>> a specific SL is being requested.
>>
>>> but if
>>> rdma_set_service_level is not called,
>>> SL should be 0 as before, shouldn't change SA PR query behavior, or I
>>> missed something?
>>
>> Component mask for SL in SA PR query is not on currently so that means
>> it's wildcarded rather than 0.
>>
>>>> Also, if SL is set in query, you probably don't need some of the other
>>>> fields that are being set.
>>>>
>>> Do you mean SL shouldn't be set with other fields, what's the side effe=
ct there?
>>
>> Never mind. It's probably best to leave those other fields as is.
>>

Thanks, I update my patch to address your comments.

For configuration, we introduce a module parameter, sysadmin will set that.
similar for ib_send_bw kinds of perf tools.


--=20
Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin
Tel: +49 30 5770083-42
Fax: +49 30 5770085-98
Email: jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: http://www.profitbricks.de

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B.
Gesch=C3=A4ftsf=C3=BChrer: Andreas Gauger, Achim Weiss.

--001a1142e94c11975a0539df9b4c
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-cma-export-function-to-set-service-level.patch"
Content-Disposition: attachment;
	filename="0001-cma-export-function-to-set-service-level.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_irrrpl610

RnJvbSAzODVlZGM5ZDIxN2I4MTc1ZTFjNTViNTIzMDI1NzFiMWQyMWQ4ZDcxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogV2VkLCAxMCBBdWcgMjAxNiAxMDo1MDo1MyArMDIwMApTdWJqZWN0OiBbUEFUQ0hd
IGNtYTogZXhwb3J0IGZ1bmN0aW9uIHRvIHNldCBzZXJ2aWNlIGxldmVsCgpXZSB3YW50IHRoaXMg
Zm9yIGlzb2xhdGluZyBuZXR3b3JrIHRyYWZmaWMgd2l0aCBzdG9yYWdlIHRyYWZmaWMuCgpTbyBl
eHRlbmQgY21hIHRvIGFsbG93IHVzIHRvIGRvIGl0IGZvciBRb1MsIHRvIGtlZXAgdGhlIG9sZCBi
YWhhdmlvciwKb25seSBhcHBseSBtYXNrIHdoZW4gc2xfb24gaXMgc2V0LgoKU2lnbmVkLW9mZi1i
eTogSmFjayBXYW5nIDxqaW5wdS53YW5nQHByb2ZpdGJyaWNrcy5jb20+Ci0tLQogZHJpdmVycy9p
bmZpbmliYW5kL2NvcmUvY21hLmMgfCAxNyArKysrKysrKysrKysrKysrKwogaW5jbHVkZS9yZG1h
L3JkbWFfY20uaCAgICAgICAgfCAxMyArKysrKysrKysrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDMw
IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9jbWEu
YyBiL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2NtYS5jCmluZGV4IDY2ZTg1MTYuLjRiNGQ0NTMg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2NtYS5jCisrKyBiL2RyaXZlcnMv
aW5maW5pYmFuZC9jb3JlL2NtYS5jCkBAIC0yMjUsNiArMjI1LDggQEAgc3RydWN0IHJkbWFfaWRf
cHJpdmF0ZSB7CiAJdTMyCQkJb3B0aW9uczsKIAl1OAkJCXNycTsKIAl1OAkJCXRvczsKKwl1OAkJ
CXNsOworCWJvb2wJCQlzbF9vbjsKIAl1OAkJCXJldXNlYWRkcjsKIAl1OAkJCWFmb25seTsKIAll
bnVtIGliX2dpZF90eXBlCWdpZF90eXBlOwpAQCAtMjc1Miw2ICsyNzU0LDE3IEBAIHN0YXRpYyB2
b2lkIGNtYV9saXN0ZW5fb25fYWxsKHN0cnVjdCByZG1hX2lkX3ByaXZhdGUgKmlkX3ByaXYpCiAJ
bXV0ZXhfdW5sb2NrKCZsb2NrKTsKIH0KIAordm9pZCByZG1hX3NldF9zZXJ2aWNlX2xldmVsKHN0
cnVjdCByZG1hX2NtX2lkICppZCwgdTggc2wpCit7CisJc3RydWN0IHJkbWFfaWRfcHJpdmF0ZSAq
aWRfcHJpdjsKKworCWlkX3ByaXYgPSBjb250YWluZXJfb2YoaWQsIHN0cnVjdCByZG1hX2lkX3By
aXZhdGUsIGlkKTsKKwlpZF9wcml2LT5zbCA9IHNsOworCWlkX3ByaXYtPnNsX29uID0gdHJ1ZTsK
K30KK0VYUE9SVF9TWU1CT0wocmRtYV9zZXRfc2VydmljZV9sZXZlbCk7CisKKwogdm9pZCByZG1h
X3NldF9zZXJ2aWNlX3R5cGUoc3RydWN0IHJkbWFfY21faWQgKmlkLCBpbnQgdG9zKQogewogCXN0
cnVjdCByZG1hX2lkX3ByaXZhdGUgKmlkX3ByaXY7CkBAIC0yODM4LDYgKzI4NTEsMTAgQEAgc3Rh
dGljIGludCBjbWFfcXVlcnlfaWJfcm91dGUoc3RydWN0IHJkbWFfaWRfcHJpdmF0ZSAqaWRfcHJp
diwgaW50IHRpbWVvdXRfbXMsCiAJcGF0aF9yZWMtPnBrZXkgPSBjcHVfdG9fYmUxNihpYl9hZGRy
X2dldF9wa2V5KCZhZGRyLT5kZXZfYWRkcikpOwogCXBhdGhfcmVjLT5udW1iX3BhdGggPSAxOwog
CXBhdGhfcmVjLT5yZXZlcnNpYmxlID0gMTsKKwlpZiAoaWRfcHJpdi0+c2xfb24pIHsKKwkJcGF0
aF9yZWMtPnNsID0gaWRfcHJpdi0+c2w7CisJCWNvbXBfbWFzayB8PSBJQl9TQV9QQVRIX1JFQ19T
TDsKKwl9CiAJcGF0aF9yZWMtPnNlcnZpY2VfaWQgPSByZG1hX2dldF9zZXJ2aWNlX2lkKCZpZF9w
cml2LT5pZCwgY21hX2RzdF9hZGRyKGlkX3ByaXYpKTsKIAogCWNvbXBfbWFzayB8PSBJQl9TQV9Q
QVRIX1JFQ19QS0VZIHwgSUJfU0FfUEFUSF9SRUNfTlVNQl9QQVRIIHwKZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvcmRtYS9yZG1hX2NtLmggYi9pbmNsdWRlL3JkbWEvcmRtYV9jbS5oCmluZGV4IGIzNGVl
NGUuLmRmNzAzMGUgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvcmRtYS9yZG1hX2NtLmgKKysrIGIvaW5j
bHVkZS9yZG1hL3JkbWFfY20uaApAQCAtMzc0LDYgKzM3NCwxOSBAQCBpbnQgcmRtYV9qb2luX211
bHRpY2FzdChzdHJ1Y3QgcmRtYV9jbV9pZCAqaWQsIHN0cnVjdCBzb2NrYWRkciAqYWRkciwKIHZv
aWQgcmRtYV9sZWF2ZV9tdWx0aWNhc3Qoc3RydWN0IHJkbWFfY21faWQgKmlkLCBzdHJ1Y3Qgc29j
a2FkZHIgKmFkZHIpOwogCiAvKioKKyAqIHJkbWFfc2V0X3NlcnZpY2VfbGV2ZWwgLSBTZXQgdGhl
IGxldmVsIG9mIHNlcnZpY2UgYXNzb2NpYXRlZCB3aXRoIGEKKyAqICAgY29ubmVjdGlvbiBpZGVu
dGlmaWVyLgorICogQGlkOiBDb21tdW5pY2F0aW9uIGlkZW50aWZpZXIgdG8gYXNzb2NpYXRlZCB3
aXRoIHNlcnZpY2UgdHlwZS4KKyAqIEBzbDogc2VydmljZSBsZXZlbC4KKyAqCisgKiBUaGUgc2Vy
dmljZSBsZXZlbCBzaG91bGQgYmUgc3BlY2lmaWVkIGJlZm9yZQorICogcGVyZm9ybWluZyByb3V0
ZSByZXNvbHV0aW9uLCBhcyBleGlzdGluZyBjb21tdW5pY2F0aW9uIG9uIHRoZQorICogY29ubmVj
dGlvbiBpZGVudGlmaWVyIG1heSBiZSB1bmFmZmVjdGVkLiAgVGhlIGxldmVsIG9mIHNlcnZpY2UK
KyAqIHJlcXVlc3RlZCBtYXkgbm90IGJlIHN1cHBvcnRlZCBieSB0aGUgbmV0d29yayB0byBhbGwg
ZGVzdGluYXRpb25zLgorICovCit2b2lkIHJkbWFfc2V0X3NlcnZpY2VfbGV2ZWwoc3RydWN0IHJk
bWFfY21faWQgKmlkLCB1OCBzbCk7CisKKy8qKgogICogcmRtYV9zZXRfc2VydmljZV90eXBlIC0g
U2V0IHRoZSB0eXBlIG9mIHNlcnZpY2UgYXNzb2NpYXRlZCB3aXRoIGEKICAqICAgY29ubmVjdGlv
biBpZGVudGlmaWVyLgogICogQGlkOiBDb21tdW5pY2F0aW9uIGlkZW50aWZpZXIgdG8gYXNzb2Np
YXRlZCB3aXRoIHNlcnZpY2UgdHlwZS4KLS0gCjIuNy40Cgo=
--001a1142e94c11975a0539df9b4c--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
