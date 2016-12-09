From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH] cma: resolve to first active IB port
Date: Fri, 9 Dec 2016 10:31:00 +0100
Message-ID: <CAMGffEkGcxdYutV0cZYAzeu_kZOgTmuqTbMNfnPuFbHj+oT+2g@mail.gmail.com>
References: <CAMGffE=mSpm+zuG9wo-GV0HT4-ewg34uvOKCUrPRC61ATjxyVg@mail.gmail.com>
 <CAMGffEnBfUnvKFHOKDuzXopa6m63RBOmHRhpeZun-UddXGjzvg@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A82373AB0BC8BE@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113aced8b2d30d0543366af5
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0BC8BE-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--001a113aced8b2d30d0543366af5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Hefty,

On Thu, Dec 8, 2016 at 6:47 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> > diff --git a/drivers/infiniband/core/cma.c
>> b/drivers/infiniband/core/cma.c
>> > index 2a6fc47..9e46b42 100644
>> > --- a/drivers/infiniband/core/cma.c
>> > +++ b/drivers/infiniband/core/cma.c
>> > @@ -684,6 +684,8 @@ static int cma_resolve_ib_dev(struct
>> > rdma_id_private *id_priv)
>> >              for (i =3D 0; !ib_get_cached_gid(cur_dev->device, p, i,
>> >                                 &gid, NULL);
>> >                   i++) {
>> > +                struct ib_port_attr attr;
>> > +
>> >                  if (!memcmp(&gid, dgid, sizeof(gid))) {
>> >                      cma_dev =3D cur_dev;
>> >                      sgid =3D gid;
>> > @@ -692,7 +694,9 @@ static int cma_resolve_ib_dev(struct
>> > rdma_id_private *id_priv)
>> >                  }
>> >
>> >                  if (!cma_dev && (gid.global.subnet_prefix =3D=3D
>> > -                         dgid->global.subnet_prefix)) {
>> > +                    dgid->global.subnet_prefix) &&
>> > +                    (!ib_query_port(cur_dev->device, p, &attr) &&
>> > +                    attr.state =3D=3D IB_PORT_ACTIVE)) {
>
> I do have a concern about accessing non-cached port data as part of this =
call.  Can we cache the port state and use that instead?

Thanks for review.

Sure, I updated the v2 patch as attached, is this what you want?

Note: in cma_resolve_loopback, it does the same, I leave it like that
for now, I can also update this part if you like.


--=20
Jinpu Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss

--001a113aced8b2d30d0543366af5
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-cma-resolve-to-first-active-ib_port.patch"
Content-Disposition: attachment;
	filename="0001-cma-resolve-to-first-active-ib_port.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iwhlaqtr0

RnJvbSBmODkwNzgyMTI3YjdmZWJiMTFmOTBhMTczM2E4MjIwYmNjOTQ0YzQ3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogVHVlLCA2IERlYyAyMDE2IDA5OjAxOjA0ICswMTAwClN1YmplY3Q6IFtQQVRDSF0g
Y21hOiByZXNvbHZlIHRvIGZpcnN0IGFjdGl2ZSBpYl9wb3J0CgpXaGVuIHJlc29sdmUgYWRkciBp
ZiB3ZSBkb24ndCBnaXZlIHNyYyBhZGRyLCBjbWEgY29yZSB3aWxsIHRyeSB0byByZXNvbHZlIHRv
CmliIGRldmljZSBvbiBpdHNlbGYsIGN1cnJlbnQgbG9naWMgaXMgb25seSBjaGVjayBpZiBpdCBo
YXMgc2FtZQpzdWJuZXRfcHJlZml4LCB3aGljaCBpcyBub3QgZW5vdWdoIGlmIHdlIHVzZSBkZWZh
dWx0IHdlbGwga25vd24gZ2lkLAp3ZSBzaG91bGQgYWxzbyBjaGVjayBpZiBwb3J0IGlzIGFjdGl2
ZS4KCnYyOiBjYWNoZSBwb3J0X2FjdGl2ZSBzdGF0ZSBpbiBjbWFfYWRkX29uZSwgYWxzbyByZWdp
c3RlciBldmVudF9oYW5kbGVyCiAgICB0byB0cmFjayBwb3J0IGV2ZW50cy4KClNpZ25lZC1vZmYt
Ynk6IEphY2sgV2FuZyA8amlucHUud2FuZ0Bwcm9maXRicmlja3MuY29tPgotLS0KIGRyaXZlcnMv
aW5maW5pYmFuZC9jb3JlL2NtYS5jIHwgNDIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKystCiAxIGZpbGUgY2hhbmdlZCwgNDEgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2NtYS5jIGIvZHJpdmVy
cy9pbmZpbmliYW5kL2NvcmUvY21hLmMKaW5kZXggMmE2ZmM0Ny4uYzdhNzY4OSAxMDA2NDQKLS0t
IGEvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvY21hLmMKKysrIGIvZHJpdmVycy9pbmZpbmliYW5k
L2NvcmUvY21hLmMKQEAgLTE1MSwxMCArMTUxLDEyIEBAIHN0YXRpYyBzdHJ1Y3QgaWRyICpjbWFf
cGVybmV0X2lkcihzdHJ1Y3QgbmV0ICpuZXQsIGVudW0gcmRtYV9wb3J0X3NwYWNlIHBzKQogc3Ry
dWN0IGNtYV9kZXZpY2UgewogCXN0cnVjdCBsaXN0X2hlYWQJbGlzdDsKIAlzdHJ1Y3QgaWJfZGV2
aWNlCSpkZXZpY2U7CisJc3RydWN0IGliX2V2ZW50X2hhbmRsZXIgZXZlbnRfaGFuZGxlcjsKIAlz
dHJ1Y3QgY29tcGxldGlvbgljb21wOwogCWF0b21pY190CQlyZWZjb3VudDsKIAlzdHJ1Y3QgbGlz
dF9oZWFkCWlkX2xpc3Q7CiAJZW51bSBpYl9naWRfdHlwZQkqZGVmYXVsdF9naWRfdHlwZTsKKwlp
bnQJCQkqcG9ydF9hY3RpdmU7CiB9OwogCiBzdHJ1Y3QgcmRtYV9iaW5kX2xpc3QgewpAQCAtNjky
LDcgKzY5NCw4IEBAIHN0YXRpYyBpbnQgY21hX3Jlc29sdmVfaWJfZGV2KHN0cnVjdCByZG1hX2lk
X3ByaXZhdGUgKmlkX3ByaXYpCiAJCQkJfQogCiAJCQkJaWYgKCFjbWFfZGV2ICYmIChnaWQuZ2xv
YmFsLnN1Ym5ldF9wcmVmaXggPT0KLQkJCQkJCSBkZ2lkLT5nbG9iYWwuc3VibmV0X3ByZWZpeCkp
IHsKKwkJCQkgICAgZGdpZC0+Z2xvYmFsLnN1Ym5ldF9wcmVmaXgpICYmCisJCQkJICAgIGN1cl9k
ZXYtPnBvcnRfYWN0aXZlW3BdKSB7CiAJCQkJCWNtYV9kZXYgPSBjdXJfZGV2OwogCQkJCQlzZ2lk
ID0gZ2lkOwogCQkJCQlpZF9wcml2LT5pZC5wb3J0X251bSA9IHA7CkBAIC00MTcwLDE3ICs0MTcz
LDQzIEBAIHN0YXRpYyBzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgY21hX25iID0gewogCS5ub3RpZmll
cl9jYWxsID0gY21hX25ldGRldl9jYWxsYmFjawogfTsKIAorc3RhdGljIHZvaWQgY21hX2V2ZW50
X2hhbmRsZXIoc3RydWN0IGliX2V2ZW50X2hhbmRsZXIgKmhhbmRsZXIsCisJCQkgICAgICBzdHJ1
Y3QgaWJfZXZlbnQgKmV2ZW50KQoreworCXN0cnVjdCBjbWFfZGV2aWNlICpjbWFfZGV2ID0KKwkJ
Y29udGFpbmVyX29mKGhhbmRsZXIsIHR5cGVvZigqY21hX2RldiksIGV2ZW50X2hhbmRsZXIpOwor
CXU4IHBvcnQgPSBldmVudC0+ZWxlbWVudC5wb3J0X251bTsKKworCS8qIHdlJ3JlIG9ubHkgaW50
ZXJlc3RlZCBpbiBwb3J0IFVwL0Rvd24gZXZlbnRzICovCisJaWYgKCBldmVudC0+ZXZlbnQgIT0g
SUJfRVZFTlRfUE9SVF9BQ1RJVkUgJiYKKwkgICAgIGV2ZW50LT5ldmVudCAhPSBJQl9FVkVOVF9Q
T1JUX0VSUikKKwkJcmV0dXJuOworCisJLyogY2FjaGUgdGhlIHN0YXRlIG9mIHRoZSBwb3J0ICov
CisJaWYgKGV2ZW50LT5ldmVudCA9PSBJQl9FVkVOVF9QT1JUX0FDVElWRSkKKwkJY21hX2Rldi0+
cG9ydF9hY3RpdmVbcG9ydF0gPSAxOworCWVsc2UKKwkJY21hX2Rldi0+cG9ydF9hY3RpdmVbcG9y
dF0gPSAwOworfQorCiBzdGF0aWMgdm9pZCBjbWFfYWRkX29uZShzdHJ1Y3QgaWJfZGV2aWNlICpk
ZXZpY2UpCiB7CiAJc3RydWN0IGNtYV9kZXZpY2UgKmNtYV9kZXY7CiAJc3RydWN0IHJkbWFfaWRf
cHJpdmF0ZSAqaWRfcHJpdjsKIAl1bnNpZ25lZCBpbnQgaTsKIAl1bnNpZ25lZCBsb25nIHN1cHBv
cnRlZF9naWRzID0gMDsKKwlzdHJ1Y3QgaWJfcG9ydF9hdHRyIHBvcnRfYXR0cjsKIAogCWNtYV9k
ZXYgPSBrbWFsbG9jKHNpemVvZiAqY21hX2RldiwgR0ZQX0tFUk5FTCk7CiAJaWYgKCFjbWFfZGV2
KQogCQlyZXR1cm47CiAKKwljbWFfZGV2LT5wb3J0X2FjdGl2ZSA9IGttYWxsb2Moc2l6ZW9mICgq
Y21hX2Rldi0+cG9ydF9hY3RpdmUpICoKKwkJCQkgICAgICAgKGRldmljZS0+cGh5c19wb3J0X2Nu
dCArIDEpLCBHRlBfS0VSTkVMKTsKKwlpZiAoIWNtYV9kZXYtPnBvcnRfYWN0aXZlKSB7CisJCWtm
cmVlKGNtYV9kZXYpOworCQlyZXR1cm47CisJfQogCWNtYV9kZXYtPmRldmljZSA9IGRldmljZTsK
IAljbWFfZGV2LT5kZWZhdWx0X2dpZF90eXBlID0ga2NhbGxvYyhkZXZpY2UtPnBoeXNfcG9ydF9j
bnQsCiAJCQkJCSAgICBzaXplb2YoKmNtYV9kZXYtPmRlZmF1bHRfZ2lkX3R5cGUpLApAQCAtNDE5
NCwxMiArNDIyMywyMSBAQCBzdGF0aWMgdm9pZCBjbWFfYWRkX29uZShzdHJ1Y3QgaWJfZGV2aWNl
ICpkZXZpY2UpCiAJCVdBUk5fT04oIXN1cHBvcnRlZF9naWRzKTsKIAkJY21hX2Rldi0+ZGVmYXVs
dF9naWRfdHlwZVtpIC0gcmRtYV9zdGFydF9wb3J0KGRldmljZSldID0KIAkJCWZpbmRfZmlyc3Rf
Yml0KCZzdXBwb3J0ZWRfZ2lkcywgQklUU19QRVJfTE9ORyk7CisJCWlmICghaWJfcXVlcnlfcG9y
dChjbWFfZGV2LT5kZXZpY2UsIGksICZwb3J0X2F0dHIpKSB7CisJCQljbWFfZGV2LT5wb3J0X2Fj
dGl2ZVtpXSA9CisJCQkJcG9ydF9hdHRyLnN0YXRlID09IElCX1BPUlRfQUNUSVZFID8gMSA6IDA7
CisJCX0gZWxzZQorCQkJY21hX2Rldi0+cG9ydF9hY3RpdmVbaV0gPSAwOwogCX0KIAogCWluaXRf
Y29tcGxldGlvbigmY21hX2Rldi0+Y29tcCk7CiAJYXRvbWljX3NldCgmY21hX2Rldi0+cmVmY291
bnQsIDEpOwogCUlOSVRfTElTVF9IRUFEKCZjbWFfZGV2LT5pZF9saXN0KTsKIAlpYl9zZXRfY2xp
ZW50X2RhdGEoZGV2aWNlLCAmY21hX2NsaWVudCwgY21hX2Rldik7CisJSU5JVF9JQl9FVkVOVF9I
QU5ETEVSKCZjbWFfZGV2LT5ldmVudF9oYW5kbGVyLCBkZXZpY2UsCisJCQkgICAgICBjbWFfZXZl
bnRfaGFuZGxlcik7CisJaWYgKGliX3JlZ2lzdGVyX2V2ZW50X2hhbmRsZXIoJmNtYV9kZXYtPmV2
ZW50X2hhbmRsZXIpKQorCQlwcl93YXJuKCJmYWlsIHRvIHJlZ2lzdGVyIGV2ZW50IGhhbmRsZXJc
biIpOwogCiAJbXV0ZXhfbG9jaygmbG9jayk7CiAJbGlzdF9hZGRfdGFpbCgmY21hX2Rldi0+bGlz
dCwgJmRldl9saXN0KTsKQEAgLTQyNjksMTIgKzQzMDcsMTQgQEAgc3RhdGljIHZvaWQgY21hX3Jl
bW92ZV9vbmUoc3RydWN0IGliX2RldmljZSAqZGV2aWNlLCB2b2lkICpjbGllbnRfZGF0YSkKIAlp
ZiAoIWNtYV9kZXYpCiAJCXJldHVybjsKIAorCWliX3VucmVnaXN0ZXJfZXZlbnRfaGFuZGxlcigm
Y21hX2Rldi0+ZXZlbnRfaGFuZGxlcik7CiAJbXV0ZXhfbG9jaygmbG9jayk7CiAJbGlzdF9kZWwo
JmNtYV9kZXYtPmxpc3QpOwogCW11dGV4X3VubG9jaygmbG9jayk7CiAKIAljbWFfcHJvY2Vzc19y
ZW1vdmUoY21hX2Rldik7CiAJa2ZyZWUoY21hX2Rldi0+ZGVmYXVsdF9naWRfdHlwZSk7CisJa2Zy
ZWUoY21hX2Rldi0+cG9ydF9hY3RpdmUpOwogCWtmcmVlKGNtYV9kZXYpOwogfQogCi0tIAoyLjcu
NAoK
--001a113aced8b2d30d0543366af5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
