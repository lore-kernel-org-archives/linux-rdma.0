From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Subject: Re: [PATCH] mm, oom: distinguish blockable mode for mmu notifiers
Date: Fri, 24 Aug 2018 14:52:26 +0200
Message-ID: <b11df415-baf8-0a41-3c16-60dfe8d32bd3@amd.com>
References: <20180716115058.5559-1-mhocko@kernel.org>
 <8cbfb09f-0c5a-8d43-1f5e-f3ff7612e289@I-love.SAKURA.ne.jp>
 <20180824113248.GH29735@dhcp22.suse.cz>
 <b088e382-e90e-df63-a079-19b2ae2b985d@gmail.com>
 <20180824115226.GK29735@dhcp22.suse.cz>
 <a27ad1a3-34bd-6b7d-fd09-7737ec3c888d@gmail.com>
 <20180824120339.GL29735@dhcp22.suse.cz>
 <eb546bcb-9c5f-7d5d-43a7-bfde489f0e7f@amd.com>
 <20180824123341.GN29735@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20180824123341.GN29735@dhcp22.suse.cz>
Content-Language: en-US
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Michal Hocko <mhocko@kernel.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>
Cc: kvm@vger.kernel.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Sudeep Dutt <sudeep.dutt@intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>, Dimitri Sivanich <sivanich@sgi.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>, Doug Ledford <dledford@redhat.com>, David Rientjes <rientjes@google.com>, xen-devel@lists.xenproject.org, intel-gfx@lists.freedesktop.org, Leon Romanovsky <leonro@mellanox.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, LKML <linux-kernel@vger.kernel.org>, Ashutosh Dixit <ashutosh.dixit@int>
List-Id: linux-rdma@vger.kernel.org

QW0gMjQuMDguMjAxOCB1bSAxNDozMyBzY2hyaWViIE1pY2hhbCBIb2NrbzoKPiBPbiBGcmkgMjQt
MDgtMTggMTQ6MTg6NDQsIENocmlzdGlhbiBLw7ZuaWcgd3JvdGU6Cj4+IEFtIDI0LjA4LjIwMTgg
dW0gMTQ6MDMgc2NocmllYiBNaWNoYWwgSG9ja286Cj4+PiBPbiBGcmkgMjQtMDgtMTggMTM6NTc6
NTIsIENocmlzdGlhbiBLw7ZuaWcgd3JvdGU6Cj4+Pj4gQW0gMjQuMDguMjAxOCB1bSAxMzo1MiBz
Y2hyaWViIE1pY2hhbCBIb2NrbzoKPj4+Pj4gT24gRnJpIDI0LTA4LTE4IDEzOjQzOjE2LCBDaHJp
c3RpYW4gS8O2bmlnIHdyb3RlOgo+Pj4gWy4uLl0KPj4+Pj4+IFRoYXQgd29uJ3Qgd29yayBsaWtl
IHRoaXMgdGhlcmUgbWlnaHQgYmUgbXVsdGlwbGUKPj4+Pj4+IGludmFsaWRhdGVfcmFuZ2Vfc3Rh
cnQoKS9pbnZhbGlkYXRlX3JhbmdlX2VuZCgpIHBhaXJzIG9wZW4gYXQgdGhlIHNhbWUgdGltZS4K
Pj4+Pj4+IEUuZy4gdGhlIGxvY2sgbWlnaHQgYmUgdGFrZW4gcmVjdXJzaXZlbHkgYW5kIHRoYXQg
aXMgaWxsZWdhbCBmb3IgYQo+Pj4+Pj4gcndfc2VtYXBob3JlLgo+Pj4+PiBJIGFtIG5vdCBzdXJl
IEkgZm9sbG93LiBBcmUgeW91IHNheWluZyB0aGF0IG9uZSBpbnZhbGlkYXRlX3JhbmdlIG1pZ2h0
Cj4+Pj4+IHRyaWdnZXIgYW5vdGhlciBvbmUgZnJvbSB0aGUgc2FtZSBwYXRoPwo+Pj4+IE5vLCBi
dXQgd2hhdCBjYW4gaGFwcGVuIGlzOgo+Pj4+Cj4+Pj4gaW52YWxpZGF0ZV9yYW5nZV9zdGFydChB
LEIpOwo+Pj4+IGludmFsaWRhdGVfcmFuZ2Vfc3RhcnQoQyxEKTsKPj4+PiAuLi4KPj4+PiBpbnZh
bGlkYXRlX3JhbmdlX2VuZChDLEQpOwo+Pj4+IGludmFsaWRhdGVfcmFuZ2VfZW5kKEEsQik7Cj4+
Pj4KPj4+PiBHcmFiYmluZyB0aGUgcmVhZCBsb2NrIHR3aWNlIHdvdWxkIGJlIGlsbGVnYWwgaW4g
dGhpcyBjYXNlLgo+Pj4gSSBhbSBzb3JyeSBidXQgSSBzdGlsbCBkbyBub3QgZm9sbG93LiBXaGF0
IGlzIHRoZSBjb250ZXh0IHRoZSB0d28gYXJlCj4+PiBjYWxsZWQgZnJvbT8KPj4gSSBkb24ndCBo
YXZlIHRoZSBzbGlnaHRlc3QgaWRlYS4KPj4KPj4+IENhbiB5b3UgZ2l2ZSBtZSBhbiBleGFtcGxl
LiBJIHNpbXBseSBkbyBub3Qgc2VlIGl0IGluIHRoZQo+Pj4gY29kZSwgbW9zdGx5IGJlY2F1c2Ug
SSBhbSBub3QgZmFtaWxpYXIgd2l0aCBpdC4KPj4gSSdtIG5laXRoZXIuCj4+Cj4+IFdlIHN0dW1i
bGVkIG92ZXIgdGhhdCBieSBwdXJlIG9ic2VydmF0aW9uIGFuZCBhZnRlciBkaXNjdXNzaW5nIHRo
ZSBwcm9ibGVtCj4+IHdpdGggSmVyb21lIGNhbWUgdXAgd2l0aCB0aGlzIHNvbHV0aW9uLgo+Pgo+
PiBObyBpZGVhIHdoZXJlIGV4YWN0bHkgdGhhdCBjYXNlIGNvbWVzIGZyb20sIGJ1dCBJIGNhbiBj
b25maXJtIHRoYXQgaXQgaW5kZWVkCj4+IGhhcHBlbnMuCj4gVGhpa2luZyBhYm91dCBpdCBzb21l
IG1vcmUsIEkgY2FuIGltYWdpbmUgdGhhdCBhIG5vdGlmaWVyIGNhbGxiYWNrIHdoaWNoCj4gcGVy
Zm9ybXMgYW4gYWxsb2NhdGlvbiBtaWdodCB0cmlnZ2VyIGEgbWVtb3J5IHJlY2xhaW0gYW5kIHRo
YXQgaW4gdHVybgo+IG1pZ2h0IHRyaWdnZXIgYSBub3RpZmllciB0byBiZSBpbnZva2VkIGFuZCBy
ZWN1cnNlLiBCdXQgbm90aWZpZXIKPiBzaG91bGRuJ3QgcmVhbGx5IGFsbG9jYXRlIG1lbW9yeS4g
VGhleSBhcmUgY2FsbGVkIGZyb20gZGVlcCBNTSBjb2RlCj4gcGF0aHMgYW5kIHRoaXMgd291bGQg
YmUgZXh0cmVtZWx5IGRlYWRsb2NrIHByb25lLiBNYXliZSBKZXJvbWUgY2FuIGNvbWUKPiB1cCBz
b21lIG1vcmUgcmVhbGlzdGljIHNjZW5hcmlvLiBJZiBub3QgdGhlbiBJIHdvdWxkIHByb3Bvc2Ug
dG8gc2ltcGxpZnkKPiB0aGUgbG9ja2luZyBoZXJlLiBXZSBoYXZlIGxvY2tkZXAgdG8gY2F0Y2gg
c2VsZiBkZWFkbG9ja3MgYW5kIGl0IGlzCj4gYWx3YXlzIGJldHRlciB0byBoYW5kbGUgYSBzcGVj
aWZpYyBpc3N1ZSByYXRoZXIgdGhhbiBoYXZpbmcgYSBjb2RlCj4gd2l0aG91dCBhIGNsZWFyIGlu
ZGljYXRpb24gaG93IGl0IGNhbiByZWN1cnNlLgoKV2VsbCBJIGFncmVlIHRoYXQgd2Ugc2hvdWxk
IHByb2JhYmx5IGZpeCB0aGF0LCBidXQgSSBoYXZlIHNvbWUgY29uY2VybnMgCnRvIHJlbW92ZSB0
aGUgZXhpc3Rpbmcgd29ya2Fyb3VuZC4KClNlZSB3ZSBhZGRlZCB0aGF0IHRvIGdldCByaWQgb2Yg
YSByZWFsIHByb2JsZW0gaW4gYSBjdXN0b21lciBlbnZpcm9ubWVudCAKYW5kIEkgZG9uJ3Qgd2Fu
dCB0byB0aGF0IHRvIHNob3cgdXAgYWdhaW4uCgpJbiB0aGUgbWVhbnRpbWUgSSd2ZSBzZW5kIG91
dCBhIGZpeCB0byBhdm9pZCBhbGxvY2F0aW5nIG1lbW9yeSB3aGlsZSAKaG9sZGluZyB0aGUgbW5f
bG9jay4KClRoYW5rcyBmb3IgcG9pbnRpbmcgdGhhdCBvdXQsCkNocmlzdGlhbi4KX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcg
bGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRl
c2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
