From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH] mm, oom: distinguish blockable mode for mmu notifiers
Date: Tue, 10 Jul 2018 16:14:10 +0200
Message-ID: <20180710141410.GP14284@dhcp22.suse.cz>
References: <20180622150242.16558-1-mhocko@kernel.org>
 <20180627074421.GF32348@dhcp22.suse.cz>
 <20180709122908.GJ22049@dhcp22.suse.cz>
 <20180710134040.GG3014@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20180710134040.GG3014@mtr-leonro.mtl.com>
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
Cc: kvm@vger.kernel.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, David Airlie <airlied@linux.ie>, Sudeep Dutt <sudeep.dutt@intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Felix Kuehling <felix.kuehling@amd.com>, Andrea Arcangeli <aarcange@redhat.com>, Dimitri Sivanich <sivanich@sgi.com>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, David Rientjes <rientjes@google.com>, xen-devel@lists.xenproject.org, intel-gfx@lists.freedesktop.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, LKML <linux-kernel@vger.kernel.org>, Ashutosh Dixit <ashutosh.dixi>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlIDEwLTA3LTE4IDE2OjQwOjQwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6Cj4gT24gTW9u
LCBKdWwgMDksIDIwMTggYXQgMDI6Mjk6MDhQTSArMDIwMCwgTWljaGFsIEhvY2tvIHdyb3RlOgo+
ID4gT24gV2VkIDI3LTA2LTE4IDA5OjQ0OjIxLCBNaWNoYWwgSG9ja28gd3JvdGU6Cj4gPiA+IFRo
aXMgaXMgdGhlIHYyIG9mIFJGQyBiYXNlZCBvbiB0aGUgZmVlZGJhY2sgSSd2ZSByZWNlaXZlZCBz
byBmYXIuIFRoZQo+ID4gPiBjb2RlIGV2ZW4gY29tcGlsZXMgYXMgYSBib251cyA7KSBJIGhhdmVu
J3QgcnVudGltZSB0ZXN0ZWQgaXQgeWV0LCBtb3N0bHkKPiA+ID4gYmVjYXVzZSBJIGhhdmUgbm8g
aWRlYSBob3cuCj4gPiA+Cj4gPiA+IEFueSBmdXJ0aGVyIGZlZWRiYWNrIGlzIGhpZ2hseSBhcHBy
ZWNpYXRlZCBvZiBjb3Vyc2UuCj4gPgo+ID4gQW55IG90aGVyIGZlZWRiYWNrIGJlZm9yZSBJIHBv
c3QgdGhpcyBhcyBub24tUkZDPwo+IAo+IEZyb20gbWx4NSBwZXJzcGVjdGl2ZSwgd2hvIGlzIHBy
aW1hcnkgdXNlciBvZiB1bWVtX29kcC5jIHlvdXIgY2hhbmdlIGxvb2tzIG9rLgoKQ2FuIEkgYXNz
dW1lIHlvdXIgQWNrZWQtYnk/CgpUaGFua3MgZm9yIHlvdXIgcmV2aWV3IQotLSAKTWljaGFsIEhv
Y2tvClNVU0UgTGFicwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5v
cmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2
ZWwK
