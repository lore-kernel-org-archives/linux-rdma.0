From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] infiniband: i40iw,
 nes: don't use wall time for TCP sequence numbers
Date: Wed, 27 Jun 2018 15:24:08 +0200
Message-ID: <CAK8P3a2NVHFLGd58+1p-ZAr9RQoyC4nbcE+Q29R+_xY0oa-tOg@mail.gmail.com>
References: <20180618144443.137068-1-arnd@arndb.de>
 <20180623000137.GA17264@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20180623000137.GA17264@ssaleem-MOBL4.amr.corp.intel.com>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: "Ismail, Mustafa" <mustafa.ismail@intel.com>, Kees Cook <keescook@chromium.org>, "Latif, Faisal" <faisal.latif@intel.com>, "y2038@lists.linaro.org" <y2038@lists.linaro.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yuval Shaia <yuval.shaia@oracle.com>, "Orosco, Henry" <henry.orosco@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, Jia-Ju Bai <baijiaju1990@gmail.com>, "Nikolova,
 Tatyana E" <tatyana.e.nikolova@intel.com>, Bart Van Assche <bart.vanassche@wdc.com>, "David S. Miller" <davem@davemloft.net>, "Reshetova,
 Elena" <elena.reshetova@intel.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

T24gU2F0LCBKdW4gMjMsIDIwMTggYXQgMjowMSBBTSwgU2hpcmF6IFNhbGVlbSA8c2hpcmF6LnNh
bGVlbUBpbnRlbC5jb20+IHdyb3RlOgoKPj4gQEAgLTIxNjQsNyArMjE2NSw2IEBAIHN0YXRpYyBz
dHJ1Y3QgaTQwaXdfY21fbm9kZSAqaTQwaXdfbWFrZV9jbV9ub2RlKAo+PiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgaTQwaXdfY21fbGlzdGVuZXIgKmxpc3RlbmVyKQo+
PiAgewo+PiAgICAgICBzdHJ1Y3QgaTQwaXdfY21fbm9kZSAqY21fbm9kZTsKPj4gLSAgICAgc3Ry
dWN0IHRpbWVzcGVjIHRzOwo+PiAgICAgICBpbnQgb2xkYXJwaW5kZXg7Cj4+ICAgICAgIGludCBh
cnBpbmRleDsKPj4gICAgICAgc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldiA9IGl3ZGV2LT5uZXRk
ZXY7Cj4+IEBAIC0yMjE0LDggKzIyMTQsMTAgQEAgc3RhdGljIHN0cnVjdCBpNDBpd19jbV9ub2Rl
ICppNDBpd19tYWtlX2NtX25vZGUoCj4+ICAgICAgIGNtX25vZGUtPnRjcF9jbnR4dC5yY3Zfd3Nj
YWxlID0gSTQwSVdfQ01fREVGQVVMVF9SQ1ZfV05EX1NDQUxFOwo+PiAgICAgICBjbV9ub2RlLT50
Y3BfY250eHQucmN2X3duZCA9Cj4+ICAgICAgICAgICAgICAgICAgICAgICBJNDBJV19DTV9ERUZB
VUxUX1JDVl9XTkRfU0NBTEVEID4+IEk0MElXX0NNX0RFRkFVTFRfUkNWX1dORF9TQ0FMRTsKPj4g
LSAgICAgdHMgPSBjdXJyZW50X2tlcm5lbF90aW1lKCk7Cj4+IC0gICAgIGNtX25vZGUtPnRjcF9j
bnR4dC5sb2Nfc2VxX251bSA9IHRzLnR2X25zZWM7Cj4+ICsgICAgIGNtX25vZGUtPnRjcF9jbnR4
dC5sb2Nfc2VxX251bSA9IHNlY3VyZV90Y3Bfc2VxKGh0b25sKGNtX25vZGUtPmxvY19hZGRyWzBd
KSwKPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgaHRvbmwoY21fbm9kZS0+cmVtX2FkZHJbMF0pLAo+PiArICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBodG9ucyhjbV9ub2RlLT5sb2NfcG9ydCks
Cj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGh0b25zKGNtX25vZGUtPnJlbV9wb3J0KSk7Cj4KPiBTaG91bGQgd2Ugbm90IGJlIHVzaW5nIHNl
Y3VyZV90Y3B2Nl9zZXEoKSB3aGVuIHdlIGFyZSBpcHY2PwoKSSBoYWQgbm90IHJlYWxpemVkIHRo
YXQgdGhlcmUgaXMgYSBkaWZmZXJlbmNlLCBidXQgeWVzLCBmcm9tIGxvb2tpbmcKYXQgdGhhdCBm
dW5jdGlvbiBpdCBzZWVtcyB0aGF0IHdlIHNob3VsZC4gdjIgY29taW5nIG5vdy4KCiAgICAgICBB
cm5kCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4
IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJv
Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4Cg==
