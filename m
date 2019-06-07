From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v2 hmm 10/11] mm/hmm: Do not use list*_rcu() for
 hmm->ranges
Date: Fri, 7 Jun 2019 16:02:46 -0700
Message-ID: <20190607230246.GI14559@iweiny-DESK2.sc.intel.com>
References: <20190606184438.31646-1-jgg@ziepe.ca>
 <20190606184438.31646-11-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190606184438.31646-11-jgg@ziepe.ca>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Ralph Campbell <rcampbell@nvidia.com>, linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Felix.Kuehling@amd.com, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Jerome Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, amd-gfx@lists.freedesktop.org
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCBKdW4gMDYsIDIwMTkgYXQgMDM6NDQ6MzdQTSAtMDMwMCwgSmFzb24gR3VudGhvcnBl
IHdyb3RlOgo+IEZyb206IEphc29uIEd1bnRob3JwZSA8amdnQG1lbGxhbm94LmNvbT4KPiAKPiBU
aGlzIGxpc3QgaXMgYWx3YXlzIHJlYWQgYW5kIHdyaXR0ZW4gd2hpbGUgaG9sZGluZyBobW0tPmxv
Y2sgc28gdGhlcmUgaXMKPiBubyBuZWVkIGZvciB0aGUgY29uZnVzaW5nIF9yY3UgYW5ub3RhdGlv
bnMuCj4gCj4gU2lnbmVkLW9mZi1ieTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVsbGFub3guY29t
Pgo+IFJldmlld2VkLWJ5OiBKw6lyw7RtZSBHbGlzc2UgPGpnbGlzc2VAcmVkaGF0LmNvbT4KClJl
dmlld2VkLWJ5OiBJcmEgV2VpbnkgPGl3ZWlueUBpbnRlbC5jb20+Cgo+IC0tLQo+ICBtbS9obW0u
YyB8IDQgKystLQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9u
cygtKQo+IAo+IGRpZmYgLS1naXQgYS9tbS9obW0uYyBiL21tL2htbS5jCj4gaW5kZXggYzJmZWNi
M2VjYjExZTEuLjcwOWQxMzhkZDQ5MDI3IDEwMDY0NAo+IC0tLSBhL21tL2htbS5jCj4gKysrIGIv
bW0vaG1tLmMKPiBAQCAtOTExLDcgKzkxMSw3IEBAIGludCBobW1fcmFuZ2VfcmVnaXN0ZXIoc3Ry
dWN0IGhtbV9yYW5nZSAqcmFuZ2UsCj4gIAltdXRleF9sb2NrKCZobW0tPmxvY2spOwo+ICAKPiAg
CXJhbmdlLT5obW0gPSBobW07Cj4gLQlsaXN0X2FkZF9yY3UoJnJhbmdlLT5saXN0LCAmaG1tLT5y
YW5nZXMpOwo+ICsJbGlzdF9hZGQoJnJhbmdlLT5saXN0LCAmaG1tLT5yYW5nZXMpOwo+ICAKPiAg
CS8qCj4gIAkgKiBJZiB0aGVyZSBhcmUgYW55IGNvbmN1cnJlbnQgbm90aWZpZXJzIHdlIGhhdmUg
dG8gd2FpdCBmb3IgdGhlbSBmb3IKPiBAQCAtOTQxLDcgKzk0MSw3IEBAIHZvaWQgaG1tX3Jhbmdl
X3VucmVnaXN0ZXIoc3RydWN0IGhtbV9yYW5nZSAqcmFuZ2UpCj4gIAkJcmV0dXJuOwo+ICAKPiAg
CW11dGV4X2xvY2soJmhtbS0+bG9jayk7Cj4gLQlsaXN0X2RlbF9yY3UoJnJhbmdlLT5saXN0KTsK
PiArCWxpc3RfZGVsKCZyYW5nZS0+bGlzdCk7Cj4gIAltdXRleF91bmxvY2soJmhtbS0+bG9jayk7
Cj4gIAo+ICAJLyogRHJvcCByZWZlcmVuY2UgdGFrZW4gYnkgaG1tX3JhbmdlX3JlZ2lzdGVyKCkg
Ki8KPiAtLSAKPiAyLjIxLjAKPiAKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRl
c2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8v
ZHJpLWRldmVs
