From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [RFI] ucmatose: No effect to set service type for QoS
Date: Thu, 11 Aug 2016 14:29:13 +0200
Message-ID: <CAMGffEmP_ouVu5v1cGGENqD9dssgtAqTg39-xa6--NaUkf1aVw@mail.gmail.com>
References: <CAMGffEn=dQsBzV9SPsVTJdsppJ65n_FFiRRASyrjwnmMNmCuDQ@mail.gmail.com>
 <170f9d79-2351-d95f-9ed1-eddedc467d68@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113f12ba1cd48f0539caebbb
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <170f9d79-2351-d95f-9ed1-eddedc467d68-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--001a113f12ba1cd48f0539caebbb
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 10, 2016 at 8:52 PM, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wr=
ote:
> On 8/9/2016 12:26 PM, Jinpu Wang wrote:
>> Hi Sean,
>>
>> I'm testing QoS support for IB. I notice ucmatose has equally
>> performance when set different service type, but set SL in ib_send_bw
>> works well (different SL show different performance base on opensm
>> settings)
>>
>> I capature packats using ibdump, it shows in in LRH the service level
>> fields are all 0 when running traffic with ucmatose.
>>
>> When running ib_send_bw, it carries the right service level I set.
>>
>> Seems in rdma_set_service_type, it sets to tos to id_priv->tos, and
>> lter set to path_rec->qos_class or traffic_class but not to sl
>> directly, what's the consideration here?
>> code snip:
>>         switch (cma_family(id_priv)) {
>>         case AF_INET:
>>                 path_rec->qos_class =3D cpu_to_be16((u16) id_priv->tos);
>>                 comp_mask |=3D IB_SA_PATH_REC_QOS_CLASS;
>>                 break;
>>         case AF_INET6:
>>                 sin6 =3D (struct sockaddr_in6 *) cma_src_addr(id_priv);
>>                 path_rec->traffic_class =3D (u8)
>> (be32_to_cpu(sin6->sin6_flowinfo) >> 20);
>>                 comp_mask |=3D IB_SA_PATH_REC_TRAFFIC_CLASS;
>>                 break;
>>         case AF_IB:
>>                 sib =3D (struct sockaddr_ib *) cma_src_addr(id_priv);
>>                 path_rec->traffic_class =3D (u8)
>> (be32_to_cpu(sib->sib_flowinfo) >> 20);
>>
>>
>> Does it make sense we also set sl here, or service type for ucmatose
>> is totally different with SL for ib_send_bw?
>
> I think this is an OpenSM configuration issue. QoS policy needs to be
> setup to return the proper SL to use for QoS class or TClass in the
> PathRecord response.
>
> -- Hal
>
Thanks Hal,

Configure extra QoS policy seems quite complex.
Do you think patch attached make sense?





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

--001a113f12ba1cd48f0539caebbb
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-cma-export-function-to-set-service-level.patch"
Content-Disposition: attachment;
	filename="0001-cma-export-function-to-set-service-level.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_irq4f2zk0

RnJvbSBiZWVjM2EyZmMyNWQzN2Q0ZjczNWM1NTIzMWY0ZTBmYmUzZjE4MGFjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogV2VkLCAxMCBBdWcgMjAxNiAxMDo1MDo1MyArMDIwMApTdWJqZWN0OiBbUEFUQ0hd
IGNtYTogZXhwb3J0IGZ1bmN0aW9uIHRvIHNldCBzZXJ2aWNlIGxldmVsCgpXZSB3YW50IHRoaXMg
Zm9yIGlzb2xhdGluZyBuZXR3b3JrIHRyYWZmaWMgd2l0aCBzdG9yYWdlIHRyYWZmaWMuCgpTbyBl
eHRlbmQgY21hIHRvIGFsbG93IHVzIHRvIGRvIGl0IGZvciBRb1MuCgpTaWduZWQtb2ZmLWJ5OiBK
YWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNvbT4KLS0tCiBkcml2ZXJzL2luZmlu
aWJhbmQvY29yZS9jbWEuYyB8IDE0ICsrKysrKysrKysrKystCiBpbmNsdWRlL3JkbWEvcmRtYV9j
bS5oICAgICAgICB8IDEzICsrKysrKysrKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgMjYgaW5zZXJ0
aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9j
b3JlL2NtYS5jIGIvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvY21hLmMKaW5kZXggNjZlODUxNi4u
YzQ2NGFhNyAxMDA2NDQKLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvY21hLmMKKysrIGIv
ZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvY21hLmMKQEAgLTIyNSw2ICsyMjUsNyBAQCBzdHJ1Y3Qg
cmRtYV9pZF9wcml2YXRlIHsKIAl1MzIJCQlvcHRpb25zOwogCXU4CQkJc3JxOwogCXU4CQkJdG9z
OworCXU4CQkJc2w7CiAJdTgJCQlyZXVzZWFkZHI7CiAJdTgJCQlhZm9ubHk7CiAJZW51bSBpYl9n
aWRfdHlwZQlnaWRfdHlwZTsKQEAgLTI3NTIsNiArMjc1MywxNiBAQCBzdGF0aWMgdm9pZCBjbWFf
bGlzdGVuX29uX2FsbChzdHJ1Y3QgcmRtYV9pZF9wcml2YXRlICppZF9wcml2KQogCW11dGV4X3Vu
bG9jaygmbG9jayk7CiB9CiAKK3ZvaWQgcmRtYV9zZXRfc2VydmljZV9sZXZlbChzdHJ1Y3QgcmRt
YV9jbV9pZCAqaWQsIHU4IHNsKQoreworCXN0cnVjdCByZG1hX2lkX3ByaXZhdGUgKmlkX3ByaXY7
CisKKwlpZF9wcml2ID0gY29udGFpbmVyX29mKGlkLCBzdHJ1Y3QgcmRtYV9pZF9wcml2YXRlLCBp
ZCk7CisJaWRfcHJpdi0+c2wgPSBzbDsKK30KK0VYUE9SVF9TWU1CT0wocmRtYV9zZXRfc2Vydmlj
ZV9sZXZlbCk7CisKKwogdm9pZCByZG1hX3NldF9zZXJ2aWNlX3R5cGUoc3RydWN0IHJkbWFfY21f
aWQgKmlkLCBpbnQgdG9zKQogewogCXN0cnVjdCByZG1hX2lkX3ByaXZhdGUgKmlkX3ByaXY7CkBA
IC0yODM4LDkgKzI4NDksMTAgQEAgc3RhdGljIGludCBjbWFfcXVlcnlfaWJfcm91dGUoc3RydWN0
IHJkbWFfaWRfcHJpdmF0ZSAqaWRfcHJpdiwgaW50IHRpbWVvdXRfbXMsCiAJcGF0aF9yZWMtPnBr
ZXkgPSBjcHVfdG9fYmUxNihpYl9hZGRyX2dldF9wa2V5KCZhZGRyLT5kZXZfYWRkcikpOwogCXBh
dGhfcmVjLT5udW1iX3BhdGggPSAxOwogCXBhdGhfcmVjLT5yZXZlcnNpYmxlID0gMTsKKwlwYXRo
X3JlYy0+c2wgPSBpZF9wcml2LT5zbDsKIAlwYXRoX3JlYy0+c2VydmljZV9pZCA9IHJkbWFfZ2V0
X3NlcnZpY2VfaWQoJmlkX3ByaXYtPmlkLCBjbWFfZHN0X2FkZHIoaWRfcHJpdikpOwogCi0JY29t
cF9tYXNrIHw9IElCX1NBX1BBVEhfUkVDX1BLRVkgfCBJQl9TQV9QQVRIX1JFQ19OVU1CX1BBVEgg
fAorCWNvbXBfbWFzayB8PSBJQl9TQV9QQVRIX1JFQ19QS0VZIHwgSUJfU0FfUEFUSF9SRUNfTlVN
Ql9QQVRIIHwgSUJfU0FfUEFUSF9SRUNfU0wgfAogCQkgICAgSUJfU0FfUEFUSF9SRUNfUkVWRVJT
SUJMRSB8IElCX1NBX1BBVEhfUkVDX1NFUlZJQ0VfSUQ7CiAKIAlzd2l0Y2ggKGNtYV9mYW1pbHko
aWRfcHJpdikpIHsKZGlmZiAtLWdpdCBhL2luY2x1ZGUvcmRtYS9yZG1hX2NtLmggYi9pbmNsdWRl
L3JkbWEvcmRtYV9jbS5oCmluZGV4IGIzNGVlNGUuLmRmNzAzMGUgMTAwNjQ0Ci0tLSBhL2luY2x1
ZGUvcmRtYS9yZG1hX2NtLmgKKysrIGIvaW5jbHVkZS9yZG1hL3JkbWFfY20uaApAQCAtMzc0LDYg
KzM3NCwxOSBAQCBpbnQgcmRtYV9qb2luX211bHRpY2FzdChzdHJ1Y3QgcmRtYV9jbV9pZCAqaWQs
IHN0cnVjdCBzb2NrYWRkciAqYWRkciwKIHZvaWQgcmRtYV9sZWF2ZV9tdWx0aWNhc3Qoc3RydWN0
IHJkbWFfY21faWQgKmlkLCBzdHJ1Y3Qgc29ja2FkZHIgKmFkZHIpOwogCiAvKioKKyAqIHJkbWFf
c2V0X3NlcnZpY2VfbGV2ZWwgLSBTZXQgdGhlIGxldmVsIG9mIHNlcnZpY2UgYXNzb2NpYXRlZCB3
aXRoIGEKKyAqICAgY29ubmVjdGlvbiBpZGVudGlmaWVyLgorICogQGlkOiBDb21tdW5pY2F0aW9u
IGlkZW50aWZpZXIgdG8gYXNzb2NpYXRlZCB3aXRoIHNlcnZpY2UgdHlwZS4KKyAqIEBzbDogc2Vy
dmljZSBsZXZlbC4KKyAqCisgKiBUaGUgc2VydmljZSBsZXZlbCBzaG91bGQgYmUgc3BlY2lmaWVk
IGJlZm9yZQorICogcGVyZm9ybWluZyByb3V0ZSByZXNvbHV0aW9uLCBhcyBleGlzdGluZyBjb21t
dW5pY2F0aW9uIG9uIHRoZQorICogY29ubmVjdGlvbiBpZGVudGlmaWVyIG1heSBiZSB1bmFmZmVj
dGVkLiAgVGhlIGxldmVsIG9mIHNlcnZpY2UKKyAqIHJlcXVlc3RlZCBtYXkgbm90IGJlIHN1cHBv
cnRlZCBieSB0aGUgbmV0d29yayB0byBhbGwgZGVzdGluYXRpb25zLgorICovCit2b2lkIHJkbWFf
c2V0X3NlcnZpY2VfbGV2ZWwoc3RydWN0IHJkbWFfY21faWQgKmlkLCB1OCBzbCk7CisKKy8qKgog
ICogcmRtYV9zZXRfc2VydmljZV90eXBlIC0gU2V0IHRoZSB0eXBlIG9mIHNlcnZpY2UgYXNzb2Np
YXRlZCB3aXRoIGEKICAqICAgY29ubmVjdGlvbiBpZGVudGlmaWVyLgogICogQGlkOiBDb21tdW5p
Y2F0aW9uIGlkZW50aWZpZXIgdG8gYXNzb2NpYXRlZCB3aXRoIHNlcnZpY2UgdHlwZS4KLS0gCjIu
Ny40Cgo=
--001a113f12ba1cd48f0539caebbb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
