From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] Fixing segfault in libibverbs
Date: Fri, 27 May 2011 09:22:07 -0700
Message-ID: <BANLkTik4e-kygpRTnxfpTdRMSTbyYNO1_Q@mail.gmail.com>
References: <OFC348E58C.B4C03447-ONC125789D.0035F094-C125789D.0036C4F7@ch.ibm.com>
 <1306493434.1835.4.camel@deela.quest-ce.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=000e0cd15818f5fefc04a44457a4
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1306493434.1835.4.camel-H/AUWmsJYVeqvyCYKW+Xr6xOck334EZe@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Animesh K Trivedi1 <ATR-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--000e0cd15818f5fefc04a44457a4
Content-Type: text/plain; charset=ISO-8859-1

>> This patch fixes SEGFAULT in libibverbs in case when there are no user
>> space drivers found. I've cloned the libibverbs from
>> git://git.openfabrics.org/ofed_1_1_5/libibverbs.git (I hope this is
>> correct)

Thanks for the patches.  I think I would prefer to fix this more like the
following (sorry for the attachment, using the gmail web interface ATM).
This actually simplifies things I think, and sticks to the original idea
that we should only be calling ibverbs_init once.

I only compile tested this, can one of you guys confirm this also fixes
the problem?

Thanks!
  Roland

--000e0cd15818f5fefc04a44457a4
Content-Type: text/x-diff; charset=US-ASCII; name="ibverbs-multiple-init.diff"
Content-Disposition: attachment; filename="ibverbs-multiple-init.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_go7c9hfh0

IHNyYy9kZXZpY2UuYyB8ICAgMjAgKysrKysrKysrKy0tLS0tLS0tLS0KIDEgZmlsZXMgY2hhbmdl
ZCwgMTAgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvc3JjL2Rl
dmljZS5jIGIvc3JjL2RldmljZS5jCmluZGV4IDE4NWY0YTYuLjU3OTg4OTUgMTAwNjQ0Ci0tLSBh
L3NyYy9kZXZpY2UuYworKysgYi9zcmMvZGV2aWNlLmMKQEAgLTQ5LDMyICs0OSwzNCBAQAogCiAj
aW5jbHVkZSAiaWJ2ZXJicy5oIgogCi1zdGF0aWMgcHRocmVhZF9tdXRleF90IGRldmljZV9saXN0
X2xvY2sgPSBQVEhSRUFEX01VVEVYX0lOSVRJQUxJWkVSOworc3RhdGljIHB0aHJlYWRfb25jZV90
IGRldmljZV9saXN0X29uY2UgPSBQVEhSRUFEX09OQ0VfSU5JVDsKIHN0YXRpYyBpbnQgbnVtX2Rl
dmljZXM7CiBzdGF0aWMgc3RydWN0IGlidl9kZXZpY2UgKipkZXZpY2VfbGlzdDsKIAorc3RhdGlj
IHZvaWQgY291bnRfZGV2aWNlcyh2b2lkKQoreworCW51bV9kZXZpY2VzID0gaWJ2ZXJic19pbml0
KCZkZXZpY2VfbGlzdCk7Cit9CisKIHN0cnVjdCBpYnZfZGV2aWNlICoqX19pYnZfZ2V0X2Rldmlj
ZV9saXN0KGludCAqbnVtKQogewotCXN0cnVjdCBpYnZfZGV2aWNlICoqbCA9IDA7CisJc3RydWN0
IGlidl9kZXZpY2UgKipsOwogCWludCBpOwogCiAJaWYgKG51bSkKIAkJKm51bSA9IDA7CiAKLQlw
dGhyZWFkX211dGV4X2xvY2soJmRldmljZV9saXN0X2xvY2spOwotCi0JaWYgKCFudW1fZGV2aWNl
cykKLQkJbnVtX2RldmljZXMgPSBpYnZlcmJzX2luaXQoJmRldmljZV9saXN0KTsKKwlwdGhyZWFk
X29uY2UoJmRldmljZV9saXN0X29uY2UsIGNvdW50X2RldmljZXMpOwogCiAJaWYgKG51bV9kZXZp
Y2VzIDwgMCkgewogCQllcnJubyA9IC1udW1fZGV2aWNlczsKLQkJZ290byBvdXQ7CisJCXJldHVy
biBOVUxMOwogCX0KIAogCWwgPSBjYWxsb2MobnVtX2RldmljZXMgKyAxLCBzaXplb2YgKHN0cnVj
dCBpYnZfZGV2aWNlICopKTsKIAlpZiAoIWwpIHsKIAkJZXJybm8gPSBFTk9NRU07Ci0JCWdvdG8g
b3V0OworCQlyZXR1cm4gTlVMTDsKIAl9CiAKIAlmb3IgKGkgPSAwOyBpIDwgbnVtX2RldmljZXM7
ICsraSkKQEAgLTgyLDggKzg0LDYgQEAgc3RydWN0IGlidl9kZXZpY2UgKipfX2lidl9nZXRfZGV2
aWNlX2xpc3QoaW50ICpudW0pCiAJaWYgKG51bSkKIAkJKm51bSA9IG51bV9kZXZpY2VzOwogCi1v
dXQ6Ci0JcHRocmVhZF9tdXRleF91bmxvY2soJmRldmljZV9saXN0X2xvY2spOwogCXJldHVybiBs
OwogfQogZGVmYXVsdF9zeW12ZXIoX19pYnZfZ2V0X2RldmljZV9saXN0LCBpYnZfZ2V0X2Rldmlj
ZV9saXN0KTsK
--000e0cd15818f5fefc04a44457a4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
