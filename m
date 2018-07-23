From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm,
 oom: distinguish blockable mode for mmu notifiers
Date: Mon, 23 Jul 2018 10:11:07 +0200
Message-ID: <20180723081006.GD17905@dhcp22.suse.cz>
References: <20180716115058.5559-1-mhocko@kernel.org>
 <20180720170902.d1137060c23802d55426aa03@linux-foundation.org>
 <20180723070306.GB17905@dhcp22.suse.cz>
 <20180723071154.GC17905@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20180723071154.GC17905@dhcp22.suse.cz>
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

T24gTW9uIDIzLTA3LTE4IDA5OjExOjU0LCBNaWNoYWwgSG9ja28gd3JvdGU6Cj4gT24gTW9uIDIz
LTA3LTE4IDA5OjAzOjA2LCBNaWNoYWwgSG9ja28gd3JvdGU6Cj4gPiBPbiBGcmkgMjAtMDctMTgg
MTc6MDk6MDIsIEFuZHJldyBNb3J0b24gd3JvdGU6Cj4gPiBbLi4uXQo+ID4gPiBQbGVhc2UgdGFr
ZSBhIGxvb2s/Cj4gPiAKPiA+IEFyZSB5b3UgT0sgdG8gaGF2ZSB0aGVzZSBpbiBhIHNlcGFyYXRl
IHBhdGNoPwo+IAo+IEJ0dy4gSSB3aWxsIHJlYmFzZSB0aGlzIHBhdGNoIG9uY2Ugb29tIHN0dWZm
IGluIGxpbnV4LW5leHQgc2V0dGxlcy4gQXQKPiBsZWFzdCBvb21fbG9jayByZW1vdmFsIGZyb20g
b29tX3JlYXBlciB3aWxsIGNvbmZsaWN0LgoKSG1tLCBJIGhhdmUganVzdCBjaGVja2VkIEFuZHJl
dydzIGFrcG0gYW5kIHRoZSBwYXRjaCBpcyBhbHJlYWR5IGluIGFuZApBbmRyZXcgaGFzIHJlc29s
dmVkIHRoZSBjb25mbGljdCB3aXRoIHRoZSBvb21fbG9jayBwYXRjaC4gSXQganVzdCBzZWVtcwp0
aGF0IGxpbnV4LW5leHQgKG5leHQtMjAxODA3MjApIGRvZXNuJ3QgaGF2ZSB0aGUgbmV3ZXN0IG1t
b3RtIHRyZWUuCgpBbnl3YXksIEkgd2lsbCBnbyB3aXRoIHRoZSBpbmNyZW1lbnRhbCBjbGVhbnVw
IHBhdGNoIHBlciBBbmRyZXcncwpjb21tZW50cyBhcyBzb29uIGFzIGxpbnV4LW5leHQgY2F0Y2hl
cyB1cC4KCi0tIApNaWNoYWwgSG9ja28KU1VTRSBMYWJzCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCkludGVsLWdmeCBtYWlsaW5nIGxpc3QKSW50ZWwtZ2Z4
QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWls
bWFuL2xpc3RpbmZvL2ludGVsLWdmeAo=
