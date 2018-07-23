From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm,
 oom: distinguish blockable mode for mmu notifiers
Date: Mon, 23 Jul 2018 10:43:36 +0200
Message-ID: <20180723084336.GH17905@dhcp22.suse.cz>
References: <20180716115058.5559-1-mhocko@kernel.org>
 <20180716161249.c76240cd487c070fb271d529@linux-foundation.org>
 <20180717081201.GB16803@dhcp22.suse.cz>
 <20180720160125.f3cda46f317a1ff5a2342549@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20180720160125.f3cda46f317a1ff5a2342549@linux-foundation.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kvm@vger.kernel.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, David Airlie <airlied@linux.ie>, Sudeep Dutt <sudeep.dutt@intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>, Dimitri Sivanich <sivanich@sgi.com>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, David Rientjes <rientjes@google.com>, xen-devel@lists.xenproject.org, intel-gfx@lists.freedesktop.org, Leon Romanovsky <leonro@mellanox.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Felix Kuehling <felix.kuehling@amd.com>, LKML <linux-kernel@vger.kerne>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpIDIwLTA3LTE4IDE2OjAxOjI1LCBBbmRyZXcgTW9ydG9uIHdyb3RlOgo+IE9uIFR1ZSwg
MTcgSnVsIDIwMTggMTA6MTI6MDEgKzAyMDAgTWljaGFsIEhvY2tvIDxtaG9ja29Aa2VybmVsLm9y
Zz4gd3JvdGU6Cj4gCj4gPiA+IEFueSBzdWdnZXN0aW9ucyByZWdhcmRpbmcgaG93IHRoZSBkcml2
ZXIgZGV2ZWxvcGVycyBjYW4gdGVzdCB0aGlzIGNvZGUKPiA+ID4gcGF0aD8gIEkgZG9uJ3QgdGhp
bmsgd2UgcHJlc2VudGx5IGhhdmUgYSB3YXkgdG8gZmFrZSBhbiBvb20ta2lsbGluZwo+ID4gPiBl
dmVudD8gIFBlcmhhcHMgd2Ugc2hvdWxkIGFkZCBzdWNoIGEgdGhpbmcsIGdpdmVuIHRoZSBwcm9i
bGVtcyB3ZSdyZQo+ID4gPiBoYXZpbmcgd2l0aCB0aGF0IGZlYXR1cmUuCj4gPiAKPiA+IFRoZSBz
aW1wbGVzdCB3YXkgaXMgdG8gd3JhcCBhbiB1c2Vyc3BhY2UgY29kZSB3aGljaCB1c2VzIHRoZXNl
IG5vdGlmaWVycwo+ID4gaW50byBhIG1lbWNnIGFuZCBzZXQgdGhlIGhhcmQgbGltaXQgdG8gaGl0
IHRoZSBvb20uIFRoaXMgY2FuIGJlIGRvbmUKPiA+IGUuZy4gYWZ0ZXIgdGhlIHRlc3QgZmF1bHRz
IGluIGFsbCB0aGUgbW11IG5vdGlmaWVyIG1hbmFnZWQgbWVtb3J5IGFuZAo+ID4gc2V0IHRoZSBo
YXJkIGxpbWl0IHRvIHNvbWV0aGluZyByZWFsbHkgc21hbGwuIFRoZW4gd2UgYXJlIGxvb2tpbmcg
Zm9yIGEKPiA+IHByb3BlciBwcm9jZXNzIHRlYXIgZG93bi4KPiAKPiBDaGFuY2VzIGFyZSwgc29t
ZSBvZiB0aGUgaW50ZW5kZWQgYXVkaWVuY2UgZG9uJ3Qga25vdyBob3cgdG8gZG8gdGhpcwo+IGFu
ZCB3aWxsIGVpdGhlciBoYXZlIHRvIGh1bnQgZG93biBhIGxvdCBvZiBkb2N1bWVudGF0aW9uIG9y
IHdpbGwganVzdAo+IG5vdCB0ZXN0IGl0LiAgQnV0IHdlIHdhbnQgdGhlbSB0byB0ZXN0IGl0LCBz
byBhIGxpdHRsZSB3b3JrZWQgc3RlcC1ieS1zdGVwCj4gZXhhbXBsZSB3b3VsZCBoZWxwIHRoaW5n
cyBhbG9uZyBwbGVhc2UuCgpJIGFtIHdpbGxpbmcgdG8gZ2l2ZSBtb3JlIHNwZWNpZmljIHN0ZXBz
LiBJcyBhbnlib2R5IGludGVyZXN0ZWQ/IEZyb20gbXkKZXhwZXJpZW5jZSBzbyBmYXIgdGhpcyBp
cyBub3Qgc29tZXRoaW5nIGRyaXZlcnMgZGV2ZWxvcGVycyB1c2luZyBtbXUKbm90aWZpZXJzIHdv
dWxkIGJlIHVuZmFtaWxpYXIgd2l0aC4KCi0tIApNaWNoYWwgSG9ja28KU1VTRSBMYWJzCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkludGVsLWdmeCBtYWls
aW5nIGxpc3QKSW50ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZy
ZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2ludGVsLWdmeAo=
