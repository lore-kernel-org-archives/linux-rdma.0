From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: crash unloading mlx4 in 3.2-rc3
Date: Tue, 6 Dec 2011 09:57:50 -0800
Message-ID: <CAL1RGDUkZHZqbLgOBE0PFK7xCV84f1Q-1gYH01p7UKiTYEPRBg@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A82373256536F5@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00151747c696c26ada04b3702d7c
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373256536F5-P5GAC/sN6hlcIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--00151747c696c26ada04b3702d7c
Content-Type: text/plain; charset=ISO-8859-1

Does something like the attached (not even compile tested) help?

(sorry for the email format, just going quick and dirty with webmail
at the moment)

--00151747c696c26ada04b3702d7c
Content-Type: text/plain; charset=US-ASCII; name="mlx4-counter.txt"
Content-Disposition: attachment; filename="mlx4-counter.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gvv7om280

IGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg0L21haW4uYyB8ICAgIDYgKysrKy0tCiAxIGZpbGVz
IGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9k
cml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NC9tYWluLmMgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcv
bWx4NC9tYWluLmMKaW5kZXggNzdmM2RiYy4uMTg4MzZjZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9p
bmZpbmliYW5kL2h3L21seDQvbWFpbi5jCisrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg0
L21haW4uYwpAQCAtMTI0NCw3ICsxMjQ0LDggQEAgZXJyX3JlZzoKIAogZXJyX2NvdW50ZXI6CiAJ
Zm9yICg7IGk7IC0taSkKLQkJbWx4NF9jb3VudGVyX2ZyZWUoaWJkZXYtPmRldiwgaWJkZXYtPmNv
dW50ZXJzW2kgLSAxXSk7CisJCWlmIChpYmRldi0+Y291bnRlcnNbaSAtIDFdICE9IC0xKQorCQkJ
bWx4NF9jb3VudGVyX2ZyZWUoaWJkZXYtPmRldiwgaWJkZXYtPmNvdW50ZXJzW2kgLSAxXSk7CiAK
IGVycl9tYXA6CiAJaW91bm1hcChpYmRldi0+dWFyX21hcCk7CkBAIC0xMjc1LDcgKzEyNzYsOCBA
QCBzdGF0aWMgdm9pZCBtbHg0X2liX3JlbW92ZShzdHJ1Y3QgbWx4NF9kZXYgKmRldiwgdm9pZCAq
aWJkZXZfcHRyKQogCX0KIAlpb3VubWFwKGliZGV2LT51YXJfbWFwKTsKIAlmb3IgKHAgPSAwOyBw
IDwgaWJkZXYtPm51bV9wb3J0czsgKytwKQotCQltbHg0X2NvdW50ZXJfZnJlZShpYmRldi0+ZGV2
LCBpYmRldi0+Y291bnRlcnNbcF0pOworCQlpZiAoaWJkZXYtPmNvdW50ZXJzW3BdICE9IC0xKQor
CQkJbWx4NF9jb3VudGVyX2ZyZWUoaWJkZXYtPmRldiwgaWJkZXYtPmNvdW50ZXJzW3BdKTsKIAlt
bHg0X2ZvcmVhY2hfcG9ydChwLCBkZXYsIE1MWDRfUE9SVF9UWVBFX0lCKQogCQltbHg0X0NMT1NF
X1BPUlQoZGV2LCBwKTsKIAo=
--00151747c696c26ada04b3702d7c--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
