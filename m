From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 1/3] mm/mmu_notifier: use structure for
 invalidate_range_start/end callback
Date: Wed, 5 Dec 2018 17:49:32 +0100
Message-ID: <20181205164932.GI30615@quack2.suse.cz>
References: <20181205053628.3210-1-jglisse@redhat.com>
 <20181205053628.3210-2-jglisse@redhat.com>
 <20181205163520.GG30615@quack2.suse.cz>
 <20181205164052.GE3536@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20181205164052.GE3536@redhat.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Jerome Glisse <jglisse@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>, Jan Kara <jack@suse.cz>, kvm@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Felix Kuehling <felix.kuehling@amd.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Christian Koenig <christian.koenig@amd.com>, Ross Zwisler <zwisler@kernel.org>, linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkIDA1LTEyLTE4IDExOjQwOjUyLCBKZXJvbWUgR2xpc3NlIHdyb3RlOgo+IE9uIFdlZCwg
RGVjIDA1LCAyMDE4IGF0IDA1OjM1OjIwUE0gKzAxMDAsIEphbiBLYXJhIHdyb3RlOgo+ID4gT24g
V2VkIDA1LTEyLTE4IDAwOjM2OjI2LCBqZ2xpc3NlQHJlZGhhdC5jb20gd3JvdGU6Cj4gPiA+IGRp
ZmYgLS1naXQgYS9tbS9tbXVfbm90aWZpZXIuYyBiL21tL21tdV9ub3RpZmllci5jCj4gPiA+IGlu
ZGV4IDUxMTlmZjg0Njc2OS4uNWY2NjY1YWUzZWUyIDEwMDY0NAo+ID4gPiAtLS0gYS9tbS9tbXVf
bm90aWZpZXIuYwo+ID4gPiArKysgYi9tbS9tbXVfbm90aWZpZXIuYwo+ID4gPiBAQCAtMTc4LDE0
ICsxNzgsMjAgQEAgaW50IF9fbW11X25vdGlmaWVyX2ludmFsaWRhdGVfcmFuZ2Vfc3RhcnQoc3Ry
dWN0IG1tX3N0cnVjdCAqbW0sCj4gPiA+ICAJCQkJICB1bnNpZ25lZCBsb25nIHN0YXJ0LCB1bnNp
Z25lZCBsb25nIGVuZCwKPiA+ID4gIAkJCQkgIGJvb2wgYmxvY2thYmxlKQo+ID4gPiAgewo+ID4g
PiArCXN0cnVjdCBtbXVfbm90aWZpZXJfcmFuZ2UgX3JhbmdlLCAqcmFuZ2UgPSAmX3JhbmdlOwo+
ID4gCj4gPiBXaHkgdGhlc2UgZ2FtZXMgd2l0aCB0d28gdmFyaWFibGVzPwo+IAo+IFRoaXMgaXMg
YSB0ZW1wb3Jhcnkgc3RlcCBpIGRlZGljZWQgdG8gZG8gdGhlIGNvbnZlcnRpb24gaW4gMiBzdGVw
cywKPiBmaXJzdCBpIGNvbnZlcnQgdGhlIGNhbGxiYWNrIHRvIHVzZSB0aGUgc3RydWN0dXJlIHNv
IHRoYXQgcGVvcGxlCj4gaGF2aW5nIG1tdSBub3RpZmllciBjYWxsYmFjayBvbmx5IGhhdmUgdG8g
cmV2aWV3IHRoaXMgcGF0Y2ggYW5kIGRvCj4gbm90IGdldCBkaXN0cmFjdGVkIGJ5IHRoZSBzZWNv
bmQgc3RlcCB3aGljaCB1cGRhdGUgYWxsIHRoZSBtbSBjYWxsCj4gc2l0ZSB0aGF0IHRyaWdnZXIg
aW52YWxpZGF0aW9uLgo+IAo+IEluIHRoZSBmaW5hbCByZXN1bHQgdGhpcyBjb2RlIGRpc2FwcGVh
ci4gSSBkaWQgaXQgdGhhdCB3YXkgdG8gbWFrZQo+IHRoZSB0aGluZyBtb3JlIHJldmlld2FibGUu
IFNvcnJ5IGlmIHRoYXQgaXMgYSBiaXQgY29uZnVzaW5nLgoKQWhhLCByaWdodC4gVGhhbmtzIGZv
ciBjbGFyaWZpY2F0aW9uLiBZb3UgY2FuIGFkZDoKCkFja2VkLWJ5OiBKYW4gS2FyYSA8amFja0Bz
dXNlLmN6PgoKCQkJCQkJCQlIb256YQotLSAKSmFuIEthcmEgPGphY2tAc3VzZS5jb20+ClNVU0Ug
TGFicywgQ1IKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
ZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0
dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
