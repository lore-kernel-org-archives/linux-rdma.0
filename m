From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm,
 oom: distinguish blockable mode for mmu notifiers
Date: Tue, 24 Jul 2018 12:53:07 -0700
Message-ID: <20180724125307.d6035c447adf46b2d74dfbd7@linux-foundation.org>
References: <20180716115058.5559-1-mhocko@kernel.org>
 <20180720170902.d1137060c23802d55426aa03@linux-foundation.org>
 <20180724141747.GP28386@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <20180724141747.GP28386@dhcp22.suse.cz>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Michal Hocko <mhocko@kernel.org>
Cc: kvm@vger.kernel.org, Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, David Airlie <airlied@linux.ie>, Sudeep Dutt <sudeep.dutt@intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>, Dimitri Sivanich <sivanich@sgi.com>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, David Rientjes <rientjes@google.com>, xen-devel@lists.xenproject.org, intel-gfx@lists.freedesktop.org, Leon Romanovsky <leonro@mellanox.com>, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Felix Kuehling <felix.kuehling@amd.com>, LKML <linux-kerne>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyNCBKdWwgMjAxOCAxNjoxNzo0NyArMDIwMCBNaWNoYWwgSG9ja28gPG1ob2Nrb0Br
ZXJuZWwub3JnPiB3cm90ZToKCj4gT24gRnJpIDIwLTA3LTE4IDE3OjA5OjAyLCBBbmRyZXcgTW9y
dG9uIHdyb3RlOgo+IFsuLi5dCj4gPiAtIFVuZG9jdW1lbnRlZCByZXR1cm4gdmFsdWUuCj4gPiAK
PiA+IC0gY29tbWVudCAiZmFpbGVkIHRvIHJlYXAgcGFydC4uLiIgaXMgbWlzbGVhZGluZyAtIHNv
dW5kcyBsaWtlIGl0J3MKPiA+ICAgcmVmZXJyaW5nIHRvIHNvbWV0aGluZyB3aGljaCBoYXBwZW5l
ZCBpbiB0aGUgcGFzdCwgaXMgaW4gZmFjdAo+ID4gICByZWZlcnJpbmcgdG8gc29tZXRoaW5nIHdo
aWNoIG1pZ2h0IGhhcHBlbiBpbiB0aGUgZnV0dXJlLgo+ID4gCj4gPiAtIGZhaWxzIHRvIGNhbGwg
dHJhY2VfZmluaXNoX3Rhc2tfcmVhcGluZygpIGluIG9uZSBjYXNlCj4gPiAKPiA+IC0gY29kZSBk
dXBsaWNhdGlvbi4KPiA+IAo+ID4gLSBJbmNyZWFzZXMgbW1hcF9zZW0gaG9sZCB0aW1lIGEgbGl0
dGxlIGJ5IG1vdmluZwo+ID4gICB0cmFjZV9maW5pc2hfdGFza19yZWFwaW5nKCkgaW5zaWRlIHRo
ZSBsb2NrZWQgcmVnaW9uLiAgU28gc3VlIG1lIDspCj4gPiAKPiA+IC0gU2hhcmluZyB0aGUgZmlu
aXNoOiBwYXRoIG1lYW5zIHRoYXQgdGhlIHRyYWNlIGV2ZW50IHdvbid0Cj4gPiAgIGRpc3Rpbmd1
aXNoIGJldHdlZW4gdGhlIHR3byBzb3VyY2VzIG9mIGZpbmlzaGluZy4KPiA+IAo+ID4gUGxlYXNl
IHRha2UgYSBsb29rPwo+IAo+IG9vbV9yZWFwX3Rhc2tfbW0gc2hvdWxkIHJldHVybiBmYWxzZSB3
aGVuIF9fb29tX3JlYXBfdGFza19tbSByZXR1cm4KPiBmYWxzZS4gVGhpcyBpcyB3aGF0IG15IHBh
dGNoIGRpZCBidXQgaXQgc2VlbXMgdGhpcyBjaGFuZ2VkIGJ5Cj4gaHR0cDovL3d3dy5vemxhYnMu
b3JnL35ha3BtL21tb3RtL2Jyb2tlbi1vdXQvbW0tb29tLXJlbW92ZS1vb21fbG9jay1mcm9tLW9v
bV9yZWFwZXIucGF0Y2gKPiBzbyB0aGF0IG9uZSBzaG91bGQgYmUgZml4ZWQuCj4gCj4gZGlmZiAt
LWdpdCBhL21tL29vbV9raWxsLmMgYi9tbS9vb21fa2lsbC5jCj4gaW5kZXggMTA0ZWY0YTAxYTU1
Li44ODY1N2UwMTg3MTQgMTAwNjQ0Cj4gLS0tIGEvbW0vb29tX2tpbGwuYwo+ICsrKyBiL21tL29v
bV9raWxsLmMKPiBAQCAtNTY1LDcgKzU2NSw3IEBAIHN0YXRpYyBib29sIG9vbV9yZWFwX3Rhc2tf
bW0oc3RydWN0IHRhc2tfc3RydWN0ICp0c2ssIHN0cnVjdCBtbV9zdHJ1Y3QgKm1tKQo+ICAJLyog
ZmFpbGVkIHRvIHJlYXAgcGFydCBvZiB0aGUgYWRkcmVzcyBzcGFjZS4gVHJ5IGFnYWluIGxhdGVy
ICovCj4gIAlpZiAoIV9fb29tX3JlYXBfdGFza19tbShtbSkpIHsKPiAgCQl1cF9yZWFkKCZtbS0+
bW1hcF9zZW0pOwo+IC0JCXJldHVybiB0cnVlOwo+ICsJCXJldHVybiBmYWxzZTsKPiAgCX0KPiAg
Cj4gIAlwcl9pbmZvKCJvb21fcmVhcGVyOiByZWFwZWQgcHJvY2VzcyAlZCAoJXMpLCBub3cgYW5v
bi1yc3M6JWx1a0IsIGZpbGUtcnNzOiVsdWtCLCBzaG1lbS1yc3M6JWx1a0JcbiIsCgpPSywgdGhh
bmtzLCBJIGFkZGVkIHRoYXQuCgo+IAo+IE9uIHRvcCBvZiB0aGF0IHRoZSBwcm9wb3NlZCBjbGVh
bnVwIGxvb2tzIGFzIGZvbGxvd3M6Cj4gCgpMb29rcyBnb29kIHRvIG1lLiAgU2VlbXMgYSBiaXQg
c3RyYW5nZSB0aGF0IHdlIG9taXQgdGhlIHByX2luZm8oKQpvdXRwdXQgaWYgdGhlIG1tIHdhcyBw
YXJ0aWFsbHkgcmVhcGVkIC0gcGVvcGxlIHdvdWxkIHN0aWxsIHdhbnQgdG8ga25vdwp0aGlzPyAg
IE5vdCB2ZXJ5IGltcG9ydGFudCB0aG91Z2guCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwpJbnRlbC1nZnggbWFpbGluZyBsaXN0CkludGVsLWdmeEBsaXN0
cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9s
aXN0aW5mby9pbnRlbC1nZngK
