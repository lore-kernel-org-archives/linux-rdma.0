From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH] mm, oom: distinguish blockable mode for mmu notifiers
Date: Fri, 24 Aug 2018 13:33:32 -0400
Message-ID: <20180824173332.GD4244@redhat.com>
References: <20180716115058.5559-1-mhocko@kernel.org>
 <8cbfb09f-0c5a-8d43-1f5e-f3ff7612e289@I-love.SAKURA.ne.jp>
 <20180824113629.GI29735@dhcp22.suse.cz>
 <103b1b33-1a1d-27a1-dcf8-5c8ad60056a6@i-love.sakura.ne.jp>
 <20180824133207.GR29735@dhcp22.suse.cz>
 <72844762-7398-c770-1702-f945573f4059@i-love.sakura.ne.jp>
 <20180824151239.GC4244@redhat.com>
 <20180824164003.GW29735@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20180824164003.GW29735@dhcp22.suse.cz>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Michal Hocko <mhocko@kernel.org>
Cc: kvm@vger.kernel.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Sudeep Dutt <sudeep.dutt@intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>, Dimitri Sivanich <sivanich@sgi.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>, Doug Ledford <dledford@redhat.com>, David Rientjes <rientjes@google.com>, xen-devel@lists.xenproject.org, intel-gfx@lists.freedesktop.org, Leon Romanovsky <leonro@mellanox.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, LKML <linux-kernel@vger.kernel.org>, Christian
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCBBdWcgMjQsIDIwMTggYXQgMDY6NDA6MDNQTSArMDIwMCwgTWljaGFsIEhvY2tvIHdy
b3RlOgo+IE9uIEZyaSAyNC0wOC0xOCAxMToxMjo0MCwgSmVyb21lIEdsaXNzZSB3cm90ZToKPiBb
Li4uXQo+ID4gSSBhbSBmaW5lIHdpdGggTWljaGFsIHBhdGNoLCBpIGFscmVhZHkgc2FpZCBzbyBj
b3VwbGUgbW9udGggYWdvIGZpcnN0IHRpbWUKPiA+IHRoaXMgZGlzY3Vzc2lvbiBkaWQgcG9wIHVw
LCBNaWNoYWwgeW91IGNhbiBhZGQ6Cj4gPiAKPiA+IFJldmlld2VkLWJ5OiBKw6lyw7RtZSBHbGlz
c2UgPGpnbGlzc2VAcmVkaGF0LmNvbT4KPiAKPiBTbyBJIGd1ZXNzIHRoZSBiZWxvdyBpcyB0aGUg
cGF0Y2ggeW91IHdlcmUgdGFsa2luZyBhYm91dD8KPiAKPiBGcm9tIGY3YWM3NTI3N2Q1MjZkY2Nk
MDExZjM0MzgxOGRjNmFmNjI3YWYyYWYgTW9uIFNlcCAxNyAwMDowMDowMCAyMDAxCj4gRnJvbTog
TWljaGFsIEhvY2tvIDxtaG9ja29Ac3VzZS5jb20+Cj4gRGF0ZTogRnJpLCAyNCBBdWcgMjAxOCAx
NTozMjoyNCArMDIwMAo+IFN1YmplY3Q6IFtQQVRDSF0gbW0sIG1tdV9ub3RpZmllcjogYmUgZXhw
bGljaXQgYWJvdXQgcmFuZ2UgaW52YWxpdGlvbgo+ICBub24tYmxvY2tpbmcgbW9kZQo+IAo+IElm
IGludmFsaWRhdGVfcmFuZ2Vfc3RhcnQgaXMgY2FsbGVkIGZvciAhYmxvY2tpbmcgbW9kZSB0aGVu
IGFsbAo+IGNhbGxiYWNrcyBoYXZlIHRvIGd1YXJhbnRlZSB0aGV5IHdpbGwgbm8gYmxvY2svc2xl
ZXAuIFRoZSBzYW1lIG9idmlvdXNseQo+IGFwcGxpZXMgdG8gaW52YWxpZGF0ZV9yYW5nZV9lbmQg
YmVjYXVzZSB0aGlzIG9wZXJhdGlvbiBwYWlycyB3aXRoIHRoZQo+IGZvcm1lciBhbmQgdGhleSBh
cmUgY2FsbGVkIGZyb20gdGhlIHNhbWUgY29udGV4dC4gTWFrZSBzdXJlIHRoaXMgaXMKPiBhcHBy
b3ByaWF0ZWx5IGRvY3VtZW50ZWQuCgpJbiBteSBicmFuY2ggaSBhbHJlYWR5IHVwZGF0ZWQgSE1N
IHRvIGJlIGxpa2Ugb3RoZXIgZXhpc3RpbmcgdXNlcgppZSBhbGwgYmxvY2tpbmcgb3BlcmF0aW9u
IGluIHRoZSBzdGFydCBjYWxsYmFjay4gQnV0IHllcyBpdCB3b3VsZApiZSB3aXNlIHRvIGFkZGVk
IHN1Y2ggY29tbWVudHMuCgoKPiAKPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWwgSG9ja28gPG1ob2Nr
b0BzdXNlLmNvbT4KPiAtLS0KPiAgaW5jbHVkZS9saW51eC9tbXVfbm90aWZpZXIuaCB8IDQgKysr
LQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4gCj4g
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbW11X25vdGlmaWVyLmggYi9pbmNsdWRlL2xpbnV4
L21tdV9ub3RpZmllci5oCj4gaW5kZXggMTMzYmE3ODgyMGVlLi42OThlMzcxYWFmZTMgMTAwNjQ0
Cj4gLS0tIGEvaW5jbHVkZS9saW51eC9tbXVfbm90aWZpZXIuaAo+ICsrKyBiL2luY2x1ZGUvbGlu
dXgvbW11X25vdGlmaWVyLmgKPiBAQCAtMTUzLDcgKzE1Myw5IEBAIHN0cnVjdCBtbXVfbm90aWZp
ZXJfb3BzIHsKPiAgCSAqCj4gIAkgKiBJZiBibG9ja2FibGUgYXJndW1lbnQgaXMgc2V0IHRvIGZh
bHNlIHRoZW4gdGhlIGNhbGxiYWNrIGNhbm5vdAo+ICAJICogc2xlZXAgYW5kIGhhcyB0byByZXR1
cm4gd2l0aCAtRUFHQUlOLiAwIHNob3VsZCBiZSByZXR1cm5lZAo+IC0JICogb3RoZXJ3aXNlLgo+
ICsJICogb3RoZXJ3aXNlLiBQbGVhc2Ugbm90ZSB0aGF0IGlmIGludmFsaWRhdGVfcmFuZ2Vfc3Rh
cnQgYXBwcm92ZXMKPiArCSAqIGEgbm9uLWJsb2NraW5nIGJlaGF2aW9yIHRoZW4gdGhlIHNhbWUg
YXBwbGllcyB0bwo+ICsJICogaW52YWxpZGF0ZV9yYW5nZV9lbmQuCj4gIAkgKgo+ICAJICovCj4g
IAlpbnQgKCppbnZhbGlkYXRlX3JhbmdlX3N0YXJ0KShzdHJ1Y3QgbW11X25vdGlmaWVyICptbiwK
PiAtLSAKPiAyLjE4LjAKPiAKPiAtLSAKPiBNaWNoYWwgSG9ja28KPiBTVVNFIExhYnMKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxp
bmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJl
ZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
