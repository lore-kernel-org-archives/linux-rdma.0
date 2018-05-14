From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 01/21] drm/i915: Move u64-to-ptr helpers to
 general header
Date: Mon, 14 May 2018 14:10:54 -0600
Message-ID: <20180514201054.GF21531@ziepe.ca>
References: <20180503133715.15276-1-leon@kernel.org>
 <20180503133715.15276-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20180503133715.15276-2-leon@kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: David Airlie <airlied@linux.ie>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, dri-devel@lists.freedesktop.org, Rodrigo Vivi <rodrigo.vivi@intel.com>, intel-gfx@lists.freedesktop.org
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCBNYXkgMDMsIDIwMTggYXQgMDQ6MzY6NTVQTSArMDMwMCwgTGVvbiBSb21hbm92c2t5
IHdyb3RlOgo+IEZyb206IExlb24gUm9tYW5vdnNreSA8bGVvbnJvQG1lbGxhbm94LmNvbT4KPiAK
PiBUaGUgbWFjcm8gdTY0X3RvX3B0cigpIGFuZCBmdW5jdGlvbiBwdHJfdG9fdTY0KCkgYXJlIHVz
ZWZ1bCBlbm91Z2gKPiB0byBiZSBwYXJ0IG9mIGdlbmVyYWwgaGVhZGVyLCBzbyBtb3ZlIHRoZW0g
dGhlcmUgYW5kIGFsbG93IFJETUEKPiBzdWJzeXN0ZW0gcmV1c2UgdGhlbS4KPiAKPiBTaWduZWQt
b2ZmLWJ5OiBMZW9uIFJvbWFub3Zza3kgPGxlb25yb0BtZWxsYW5veC5jb20+Cj4gLS0tCj4gIGRy
aXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfdXRpbHMuaCB8IDEyICsrLS0tLS0tLS0tLQo+ICBpbmNs
dWRlL2xpbnV4L2tlcm5lbC5oICAgICAgICAgICAgfCAxMiArKysrKysrKysrKysKPiAgMiBmaWxl
cyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkKClRoaXMgcGF0Y2gg
YW5kIHRoZSBuZXh0IG9uZSB0byBrZXJuZWwuaCB3aWxsIG5lZWQgdG8gYmUgQWNrJ2QgYmUKc29t
ZW9uZS4uIEJ1dCBJIGFtIG5vdCBzdXJlIHdoby4uIEFuZHJld00gcGVyaGFwcz8KCkphc29uCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZlbCBt
YWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3Rz
LmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
