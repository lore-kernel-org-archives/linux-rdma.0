From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm,
 oom: distinguish blockable mode for mmu notifiers
Date: Fri, 24 Aug 2018 15:24:42 +0200
Message-ID: <20180824132442.GQ29735@dhcp22.suse.cz>
References: <20180824113248.GH29735@dhcp22.suse.cz>
 <b088e382-e90e-df63-a079-19b2ae2b985d@gmail.com>
 <20180824115226.GK29735@dhcp22.suse.cz>
 <a27ad1a3-34bd-6b7d-fd09-7737ec3c888d@gmail.com>
 <20180824120339.GL29735@dhcp22.suse.cz>
 <eb546bcb-9c5f-7d5d-43a7-bfde489f0e7f@amd.com>
 <20180824123341.GN29735@dhcp22.suse.cz>
 <b11df415-baf8-0a41-3c16-60dfe8d32bd3@amd.com>
 <20180824130132.GP29735@dhcp22.suse.cz>
 <23d071d2-82e4-9b78-1000-be44db5f6523@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <23d071d2-82e4-9b78-1000-be44db5f6523@gmail.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: christian.koenig@amd.com
Cc: kvm@vger.kernel.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Sudeep Dutt <sudeep.dutt@intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>, Dimitri Sivanich <sivanich@sgi.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>, Doug Ledford <dledford@redhat.com>, David Rientjes <rientjes@google.com>, xen-devel@lists.xenproject.org, intel-gfx@lists.freedesktop.org, Leon Romanovsky <leonro@mellanox.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis
List-Id: linux-rdma@vger.kernel.org

T24gRnJpIDI0LTA4LTE4IDE1OjEwOjA4LCBDaHJpc3RpYW4gS8O2bmlnIHdyb3RlOgo+IEFtIDI0
LjA4LjIwMTggdW0gMTU6MDEgc2NocmllYiBNaWNoYWwgSG9ja286Cj4gPiBPbiBGcmkgMjQtMDgt
MTggMTQ6NTI6MjYsIENocmlzdGlhbiBLw7ZuaWcgd3JvdGU6Cj4gPiA+IEFtIDI0LjA4LjIwMTgg
dW0gMTQ6MzMgc2NocmllYiBNaWNoYWwgSG9ja286Cj4gPiBbLi4uXQo+ID4gPiA+IFRoaWtpbmcg
YWJvdXQgaXQgc29tZSBtb3JlLCBJIGNhbiBpbWFnaW5lIHRoYXQgYSBub3RpZmllciBjYWxsYmFj
ayB3aGljaAo+ID4gPiA+IHBlcmZvcm1zIGFuIGFsbG9jYXRpb24gbWlnaHQgdHJpZ2dlciBhIG1l
bW9yeSByZWNsYWltIGFuZCB0aGF0IGluIHR1cm4KPiA+ID4gPiBtaWdodCB0cmlnZ2VyIGEgbm90
aWZpZXIgdG8gYmUgaW52b2tlZCBhbmQgcmVjdXJzZS4gQnV0IG5vdGlmaWVyCj4gPiA+ID4gc2hv
dWxkbid0IHJlYWxseSBhbGxvY2F0ZSBtZW1vcnkuIFRoZXkgYXJlIGNhbGxlZCBmcm9tIGRlZXAg
TU0gY29kZQo+ID4gPiA+IHBhdGhzIGFuZCB0aGlzIHdvdWxkIGJlIGV4dHJlbWVseSBkZWFkbG9j
ayBwcm9uZS4gTWF5YmUgSmVyb21lIGNhbiBjb21lCj4gPiA+ID4gdXAgc29tZSBtb3JlIHJlYWxp
c3RpYyBzY2VuYXJpby4gSWYgbm90IHRoZW4gSSB3b3VsZCBwcm9wb3NlIHRvIHNpbXBsaWZ5Cj4g
PiA+ID4gdGhlIGxvY2tpbmcgaGVyZS4gV2UgaGF2ZSBsb2NrZGVwIHRvIGNhdGNoIHNlbGYgZGVh
ZGxvY2tzIGFuZCBpdCBpcwo+ID4gPiA+IGFsd2F5cyBiZXR0ZXIgdG8gaGFuZGxlIGEgc3BlY2lm
aWMgaXNzdWUgcmF0aGVyIHRoYW4gaGF2aW5nIGEgY29kZQo+ID4gPiA+IHdpdGhvdXQgYSBjbGVh
ciBpbmRpY2F0aW9uIGhvdyBpdCBjYW4gcmVjdXJzZS4KPiA+ID4gV2VsbCBJIGFncmVlIHRoYXQg
d2Ugc2hvdWxkIHByb2JhYmx5IGZpeCB0aGF0LCBidXQgSSBoYXZlIHNvbWUgY29uY2VybnMgdG8K
PiA+ID4gcmVtb3ZlIHRoZSBleGlzdGluZyB3b3JrYXJvdW5kLgo+ID4gPiAKPiA+ID4gU2VlIHdl
IGFkZGVkIHRoYXQgdG8gZ2V0IHJpZCBvZiBhIHJlYWwgcHJvYmxlbSBpbiBhIGN1c3RvbWVyIGVu
dmlyb25tZW50IGFuZAo+ID4gPiBJIGRvbid0IHdhbnQgdG8gdGhhdCB0byBzaG93IHVwIGFnYWlu
Lgo+ID4gSXQgd291bGQgcmVhbGx5IGhlbHAgdG8ga25vdyBtb3JlIGFib3V0IHRoYXQgY2FzZSBh
bmQgZml4IGl0IHByb3Blcmx5Cj4gPiByYXRoZXIgdGhhbiB3b3JrYXJvdW5kIGl0IGxpa2UgdGhp
cy4gQW55d2F5LCBsZXQgbWUgdGhpbmsgaG93IHRvIGhhbmRsZQo+ID4gdGhlIG5vbi1ibG9ja2lu
ZyBub3RpZmllciBpbnZvY2F0aW9uIHRoZW4uIEkgd2FzIG5vdCBhYmxlIHRvIGNvbWUgdXAKPiA+
IHdpdGggYW55dGhpbmcgcmVtb3RlbHkgc2FuZSB5ZXQuCj4gCj4gV2l0aCBhdm9pZGluZyBhbGxv
Y2F0aW5nIG1lbW9yeSBpbiB0aGUgd3JpdGUgbG9jayBwYXRoIEkgZG9uJ3Qgc2VlIGFuIGlzc3Vl
Cj4gYW55IG1vcmUgd2l0aCB0aGF0Lgo+IAo+IEFsbCB3aGF0IHRoZSB3cml0ZSBsb2NrIHBhdGgg
ZG9lcyBub3cgaXMgYWRkaW5nIGl0ZW1zIHRvIGEgbGlua2VkIGxpc3RzLAo+IGFycmF5cyBldGMu
Li4uCgpDYW4gd2UgY2hhbmdlIGl0IHRvIG5vbi1zbGVlcGFibGUgbG9jayB0aGVuPwotLSAKTWlj
aGFsIEhvY2tvClNVU0UgTGFicwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpJbnRlbC1nZnggbWFpbGluZyBsaXN0CkludGVsLWdmeEBsaXN0cy5mcmVlZGVz
a3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9p
bnRlbC1nZngK
