From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH v2 hmm 07/11] mm/hmm: Use lockdep instead of comments
Date: Thu,  6 Jun 2019 15:44:34 -0300
Message-ID: <20190606184438.31646-8-jgg@ziepe.ca>
References: <20190606184438.31646-1-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190606184438.31646-1-jgg-uk2M96/98Pc@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Felix.Kuehling-5C7GfCeVMHo@public.gmane.org
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

RnJvbTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVsbGFub3guY29tPgoKU28gd2UgY2FuIGNoZWNr
IGxvY2tpbmcgYXQgcnVudGltZS4KClNpZ25lZC1vZmYtYnk6IEphc29uIEd1bnRob3JwZSA8amdn
QG1lbGxhbm94LmNvbT4KUmV2aWV3ZWQtYnk6IErDqXLDtG1lIEdsaXNzZSA8amdsaXNzZUByZWRo
YXQuY29tPgotLS0KdjIKLSBGaXggbWlzc2luZyAmIGluIGxvY2tkZXBzIChKYXNvbikKLS0tCiBt
bS9obW0uYyB8IDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9tbS9obW0uYyBiL21tL2htbS5jCmluZGV4IGY2N2JhMzI5
ODNkOWYxLi5jNzAyY2Q3MjY1MWI1MyAxMDA2NDQKLS0tIGEvbW0vaG1tLmMKKysrIGIvbW0vaG1t
LmMKQEAgLTI1NCwxMSArMjU0LDExIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbW11X25vdGlmaWVy
X29wcyBobW1fbW11X25vdGlmaWVyX29wcyA9IHsKICAqCiAgKiBUbyBzdGFydCBtaXJyb3Jpbmcg
YSBwcm9jZXNzIGFkZHJlc3Mgc3BhY2UsIHRoZSBkZXZpY2UgZHJpdmVyIG11c3QgcmVnaXN0ZXIK
ICAqIGFuIEhNTSBtaXJyb3Igc3RydWN0LgotICoKLSAqIFRIRSBtbS0+bW1hcF9zZW0gTVVTVCBC
RSBIRUxEIElOIFdSSVRFIE1PREUgIQogICovCiBpbnQgaG1tX21pcnJvcl9yZWdpc3RlcihzdHJ1
Y3QgaG1tX21pcnJvciAqbWlycm9yLCBzdHJ1Y3QgbW1fc3RydWN0ICptbSkKIHsKKwlsb2NrZGVw
X2Fzc2VydF9oZWxkX2V4Y2x1c2l2ZSgmbW0tPm1tYXBfc2VtKTsKKwogCS8qIFNhbml0eSBjaGVj
ayAqLwogCWlmICghbW0gfHwgIW1pcnJvciB8fCAhbWlycm9yLT5vcHMpCiAJCXJldHVybiAtRUlO
VkFMOwotLSAKMi4yMS4wCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwphbWQtZ2Z4IG1haWxpbmcgbGlzdAphbWQtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9y
ZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2FtZC1nZng=
