From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH] mm,
 oom: distinguish blockable mode for mmu notifiers
Date: Mon, 2 Jul 2018 13:54:23 +0200
Message-ID: <20180702115423.GK19043@dhcp22.suse.cz>
References: <20180622150242.16558-1-mhocko@kernel.org>
 <20180627074421.GF32348@dhcp22.suse.cz>
 <71f4184c-21ea-5af1-eeb6-bf7787614e2d@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <71f4184c-21ea-5af1-eeb6-bf7787614e2d@amd.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: kvm@vger.kernel.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, David Airlie <airlied@linux.ie>, Sudeep Dutt <sudeep.dutt@intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>, Dimitri Sivanich <sivanich@sgi.com>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, David Rientjes <rientjes@google.com>, xen-devel@lists.xenproject.org, intel-gfx@lists.freedesktop.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, LKML <linux-kernel@vger.kernel.org>, Ashutosh Dixit <ashut>
List-Id: linux-rdma@vger.kernel.org

T24gTW9uIDAyLTA3LTE4IDExOjE0OjU4LCBDaHJpc3RpYW4gS8O2bmlnIHdyb3RlOgo+IEFtIDI3
LjA2LjIwMTggdW0gMDk6NDQgc2NocmllYiBNaWNoYWwgSG9ja286Cj4gPiBUaGlzIGlzIHRoZSB2
MiBvZiBSRkMgYmFzZWQgb24gdGhlIGZlZWRiYWNrIEkndmUgcmVjZWl2ZWQgc28gZmFyLiBUaGUK
PiA+IGNvZGUgZXZlbiBjb21waWxlcyBhcyBhIGJvbnVzIDspIEkgaGF2ZW4ndCBydW50aW1lIHRl
c3RlZCBpdCB5ZXQsIG1vc3RseQo+ID4gYmVjYXVzZSBJIGhhdmUgbm8gaWRlYSBob3cuCj4gPiAK
PiA+IEFueSBmdXJ0aGVyIGZlZWRiYWNrIGlzIGhpZ2hseSBhcHByZWNpYXRlZCBvZiBjb3Vyc2Uu
Cj4gCj4gVGhhdCBzb3VuZHMgbGlrZSBpdCBzaG91bGQgd29yayBhbmQgYXQgbGVhc3QgdGhlIGFt
ZGdwdSBjaGFuZ2VzIG5vdyBsb29rCj4gZ29vZCB0byBtZSBvbiBmaXJzdCBnbGFuY2UuCj4gCj4g
Q2FuIHlvdSBzcGxpdCB0aGF0IHVwIGZ1cnRoZXIgaW4gdGhlIHVzdWFsIHdheT8gRS5nLiBhZGRp
bmcgdGhlIGJsb2NrYWJsZQo+IGZsYWcgaW4gb25lIHBhdGNoIGFuZCBmaXhpbmcgYWxsIGltcGxl
bWVudGF0aW9ucyBvZiB0aGUgTU1VIG5vdGlmaWVyIGluCj4gZm9sbG93IHVwIHBhdGNoZXMuCgpC
dXQgc3VjaCBhIGNvZGUgd291bGQgYmUgYnJva2VuLCBubz8gSWdub3JpbmcgdGhlIGJsb2NrYWJs
ZSBzdGF0ZSB3aWxsCnNpbXBseSBsZWFkIHRvIGxvY2t1cHMgdW50aWwgdGhlIGZpeHVwIHBhcnRz
IGdldCBhcHBsaWVkLgpJcyB0aGUgc3BsaXQgdXAgcmVhbGx5IHdvcnRoIGl0PyBJIHdhcyB0aGlu
a2luZyBhYm91dCB0aGF0IGJ1dCBoYWQgaGFyZAp0aW1lcyB0byBlbmQgdXAgd2l0aCBzb21ldGhp
bmcgdGhhdCB3b3VsZCBiZSBiaXNlY3RhYmxlLiBXZWxsLCBleGNlcHQKZm9yIHJldHVybmluZyAt
RUJVU1kgdW50aWwgYWxsIG5vdGlmaWVycyBhcmUgaW1wbGVtZW50ZWQuIFdoaWNoIEkgZm91bmQK
Y29uZnVzaW5nLgoKPiBUaGlzIHdheSBJJ20gcHJldHR5IHN1cmUgRmVsaXggYW5kIEkgY2FuIGdp
dmUgYW4gcmIgb24gdGhlIGFtZGdwdS9hbWRrZmQKPiBjaGFuZ2VzLgoKSWYgeW91IGFyZSB3b3Jy
aWVkIHRvIGdpdmUgci1iIG9ubHkgZm9yIHRob3NlIHRoZW4gdGhpcyBjYW4gYmUgZG9uZSBldmVu
CmZvciBsYXJnZXIgcGF0Y2hlcy4gSnVzdCBtYWtlIHlvdXIgUmV2aWV3ZC1ieSBtb3JlIHNwZWNp
ZmljClItYjogbmFtZSAjIEZvciBCTEEgQkxBCi0tIApNaWNoYWwgSG9ja28KU1VTRSBMYWJzCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkludGVsLWdmeCBt
YWlsaW5nIGxpc3QKSW50ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3Rz
LmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2ludGVsLWdmeAo=
