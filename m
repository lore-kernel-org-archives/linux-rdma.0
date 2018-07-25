From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm,
 oom: distinguish blockable mode for mmu notifiers
Date: Wed, 25 Jul 2018 08:13:55 +0200
Message-ID: <20180725061355.GS28386@dhcp22.suse.cz>
References: <20180716115058.5559-1-mhocko@kernel.org>
 <20180720170902.d1137060c23802d55426aa03@linux-foundation.org>
 <20180724141747.GP28386@dhcp22.suse.cz>
 <alpine.DEB.2.21.1807241405450.191477@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1807241405450.191477@chino.kir.corp.google.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: David Rientjes <rientjes@google.com>
Cc: kvm@vger.kernel.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, David Airlie <airlied@linux.ie>, Sudeep Dutt <sudeep.dutt@intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>, Dimitri Sivanich <sivanich@sgi.com>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, xen-devel@lists.xenproject.org, intel-gfx@lists.freedesktop.org, Leon Romanovsky <leonro@mellanox.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, LKML <linux-kernel@vger.kernel.org>, Christian
List-Id: linux-rdma@vger.kernel.org

T24gVHVlIDI0LTA3LTE4IDE0OjA3OjQ5LCBEYXZpZCBSaWVudGplcyB3cm90ZToKWy4uLl0KPiBt
bS9vb21fa2lsbC5jOiBjbGVhbiB1cCBvb21fcmVhcF90YXNrX21tKCkgZml4Cj4gCj4gaW5kaWNh
dGUgcmVhcGluZyBoYXMgYmVlbiBwYXJ0aWFsbHkgc2tpcHBlZCBzbyB3ZSBjYW4gZXhwZWN0IGZ1
dHVyZSBza2lwcyAKPiBvciBhbm90aGVyIHN0YXJ0IGJlZm9yZSBmaW5pc2guCgpCdXQgd2UgYXJl
IG5vdCBza2lwcGluZy4gVGhpcyBpcyBlc3NlbnRpYWxseSB0aGUgc2FtZSBjYXNlIGFzIG1tYXBf
c2VtCnRyeWxvY2sgZmFpbC4gTWF5YmUgd2UgY2FuIGFkZCBhIGJvb2wgcGFyYW1ldGVyIHRvIHRy
YWNlX2ZpbmlzaF90YXNrX3JlYXBpbmcKdG8gZGVub3RlIHBhcnRpYWwgc3VjY2Vzcz8KCj4gU2ln
bmVkLW9mZi1ieTogRGF2aWQgUmllbnRqZXMgPHJpZW50amVzQGdvb2dsZS5jb20+Cj4gLS0tCj4g
IG1tL29vbV9raWxsLmMgfCA2ICsrKystLQo+ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9tbS9vb21fa2lsbC5jIGIvbW0v
b29tX2tpbGwuYwo+IC0tLSBhL21tL29vbV9raWxsLmMKPiArKysgYi9tbS9vb21fa2lsbC5jCj4g
QEAgLTU2OSwxMCArNTY5LDEyIEBAIHN0YXRpYyBib29sIG9vbV9yZWFwX3Rhc2tfbW0oc3RydWN0
IHRhc2tfc3RydWN0ICp0c2ssIHN0cnVjdCBtbV9zdHJ1Y3QgKm1tKQo+ICAKPiAgCXRyYWNlX3N0
YXJ0X3Rhc2tfcmVhcGluZyh0c2stPnBpZCk7Cj4gIAo+IC0JLyogZmFpbGVkIHRvIHJlYXAgcGFy
dCBvZiB0aGUgYWRkcmVzcyBzcGFjZS4gVHJ5IGFnYWluIGxhdGVyICovCj4gIAlyZXQgPSBfX29v
bV9yZWFwX3Rhc2tfbW0obW0pOwo+IC0JaWYgKCFyZXQpCj4gKwlpZiAoIXJldCkgewo+ICsJCS8q
IEZhaWxlZCB0byByZWFwIHBhcnQgb2YgdGhlIGFkZHJlc3Mgc3BhY2UuIFRyeSBhZ2FpbiBsYXRl
ciAqLwo+ICsJCXRyYWNlX3NraXBfdGFza19yZWFwaW5nKHRzay0+cGlkKTsKPiAgCQlnb3RvIG91
dF9maW5pc2g7Cj4gKwl9Cj4gIAo+ICAJcHJfaW5mbygib29tX3JlYXBlcjogcmVhcGVkIHByb2Nl
c3MgJWQgKCVzKSwgbm93IGFub24tcnNzOiVsdWtCLCBmaWxlLXJzczolbHVrQiwgc2htZW0tcnNz
OiVsdWtCXG4iLAo+ICAJCQl0YXNrX3BpZF9ucih0c2spLCB0c2stPmNvbW0sCgotLSAKTWljaGFs
IEhvY2tvClNVU0UgTGFicwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpJbnRlbC1nZnggbWFpbGluZyBsaXN0CkludGVsLWdmeEBsaXN0cy5mcmVlZGVza3Rv
cC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9pbnRl
bC1nZngK
