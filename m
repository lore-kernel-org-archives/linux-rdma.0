From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH 00/13] mmu_notifier kill invalidate_page callback
Date: Tue, 29 Aug 2017 20:56:15 -0400
Message-ID: <20170830005615.GA2386@redhat.com>
References: <20170829235447.10050-1-jglisse@redhat.com>
 <CA+55aFz6ArJ-ADXiYCu6xMUzdY=mKBtkzfJmLaBohC6Ub9t2SQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFz6ArJ-ADXiYCu6xMUzdY=mKBtkzfJmLaBohC6Ub9t2SQ@mail.gmail.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bernhard Held <berny156@gmx.de>, KVM list <kvm@vger.kernel.org>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Sudeep Dutt <sudeep.dutt@intel.com>, DRI <dri-devel@lists.freedesktop.org>, linux-mm <linux-mm@kvack.org>, Andrea Arcangeli <aarcange@redhat.com>, Dimitri Sivanich <sivanich@sgi.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, amd-gfx@lists.freedesktop.org, xen-devel <xen-devel@lists.xenproject.org>, Adam Borowski <kilobyte@angband.pl>, Joerg Roedel <jroedel@suse.de>, Jack Steiner <steiner@sgi.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ashutosh Dixit <ashutosh.dixit@intel.com>, "open list:AMD IOMMU (AMD-VI)" <iommu@lists.linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, ppc-dev <linuxppc-dev@lists.ozlabs.org>, Kirill A . S
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCBBdWcgMjksIDIwMTcgYXQgMDU6MTE6MjRQTSAtMDcwMCwgTGludXMgVG9ydmFsZHMg
d3JvdGU6Cj4gT24gVHVlLCBBdWcgMjksIDIwMTcgYXQgNDo1NCBQTSwgSsOpcsO0bWUgR2xpc3Nl
IDxqZ2xpc3NlQHJlZGhhdC5jb20+IHdyb3RlOgo+ID4KPiA+IE5vdGUgdGhpcyBpcyBiYXJlbHkg
dGVzdGVkLiBJIGludGVuZCB0byBkbyBtb3JlIHRlc3Rpbmcgb2YgbmV4dCBmZXcgZGF5cwo+ID4g
YnV0IGkgZG8gbm90IGhhdmUgYWNjZXNzIHRvIGFsbCBoYXJkd2FyZSB0aGF0IG1ha2UgdXNlIG9m
IHRoZSBtbXVfbm90aWZpZXIKPiA+IEFQSS4KPiAKPiBUaGFua3MgZm9yIGRvaW5nIHRoaXMuCj4g
Cj4gPiBGaXJzdCAyIHBhdGNoZXMgY29udmVydCBleGlzdGluZyBjYWxsIG9mIG1tdV9ub3RpZmll
cl9pbnZhbGlkYXRlX3BhZ2UoKQo+ID4gdG8gbW11X25vdGlmaWVyX2ludmFsaWRhdGVfcmFuZ2Uo
KSBhbmQgYnJhY2tldCB0aG9zZSBjYWxsIHdpdGggY2FsbCB0bwo+ID4gbW11X25vdGlmaWVyX2lu
dmFsaWRhdGVfcmFuZ2Vfc3RhcnQoKS9lbmQoKS4KPiAKPiBPaywgdGhvc2UgdHdvIHBhdGNoZXMg
YXJlIGEgYml0IG1vcmUgY29tcGxleCB0aGFuIEkgd2FzIGhvcGluZyBmb3IsCj4gYnV0IG5vdCAq
dG9vKiBiYWQuCj4gCj4gQW5kIHRoZSBmaW5hbCBlbmQgcmVzdWx0IGNlcnRhaW5seSBsb29rcyBu
aWNlOgo+IAo+ID4gIDE2IGZpbGVzIGNoYW5nZWQsIDc0IGluc2VydGlvbnMoKyksIDIxNCBkZWxl
dGlvbnMoLSkKPiAKPiBZZWFoLCByZW1vdmluZyBhbGwgdGhvc2UgaW52YWxpZGF0ZV9wYWdlKCkg
bm90aWZpZXJzIGNlcnRhaW5seSBtYWtlcwo+IGZvciBhIG5pY2UgcGF0Y2guCj4gCj4gQW5kIEkg
YWN0dWFsbHkgdGhpbmsgeW91IG1pc3NlZCBzb21lIG1vcmUgbGluZXMgdGhhdCBjYW4gbm93IGJl
Cj4gcmVtb3ZlZDoga3ZtX2FyY2hfbW11X25vdGlmaWVyX2ludmFsaWRhdGVfcGFnZSgpIHNob3Vs
ZCBubyBsb25nZXIgYmUKPiBuZWVkZWQgZWl0aGVyLCBzbyB5b3UgY2FuIHJlbW92ZSBhbGwgb2Yg
dGhvc2UgdG9vIChtb3N0IG9mIHRoZW0gYXJlCj4gZW1wdHkgaW5saW5lIGZ1bmN0aW9ucywgYnV0
IHg4NiBoYXMgb25lIHRoYXQgYWN0dWFsbHkgZG9lcyBzb21ldGhpbmcuCj4gCj4gU28gdGhlcmUn
cyBhbiBhZGRlZCAzMCBvciBzbyBkZWFkIGxpbmVzIHRoYXQgc2hvdWxkIGJlIHJlbW92ZWQgaW4g
dGhlCj4ga3ZtIHBhdGNoLCBJIHRoaW5rLgoKWWVzIGkgbWlzc2VkIHRoYXQuIEkgd2lsbCB3YWl0
IGZvciBwZW9wbGUgdG8gdGVzdCBhbmQgZm9yIHJlc3VsdCBvZiBteQpvd24gdGVzdCBiZWZvcmUg
cmVwb3N0aW5nIGlmIG5lZWQgYmUsIG90aGVyd2lzZSBpIHdpbGwgcG9zdCBhcyBzZXBhcmF0ZQpw
YXRjaC4KCj4gCj4gQnV0IGZyb20gYSBfdmVyeV8gcXVpY2sgcmVhZC10aHJvdWdoIHRoaXMgbG9v
a3MgZmluZS4gQnV0IGl0IG9idmlvdXNseQo+IG5lZWRzIHRlc3RpbmcuCj4gCj4gUGVvcGxlIC0g
KmVzcGVjaWFsbHkqIHRoZSBwZW9wbGUgd2hvIHNhdyBpc3N1ZXMgdW5kZXIgS1ZNIC0gY2FuIHlv
dQo+IHRyeSBvdXQgSsOpcsO0bWUncyBwYXRjaC1zZXJpZXM/IEkgYWRlZCBzb21lIHBlb3BsZSB0
byB0aGUgY2MsIHRoZSBmdWxsCj4gc2VyaWVzIGlzIG9uIGxrbWwuIErDqXLDtG1lIC0gZG8geW91
IGhhdmUgYSBnaXQgYnJhbmNoIGZvciBwZW9wbGUgdG8KPiB0ZXN0IHRoYXQgdGhleSBjb3VsZCBl
YXNpbHkgcHVsbCBhbmQgdHJ5IG91dD8KCmh0dHBzOi8vY2dpdC5mcmVlZGVza3RvcC5vcmcvfmds
aXNzZS9saW51eCBtbXUtbm90aWZpZXIgYnJhbmNoCmdpdDovL3Blb3BsZS5mcmVlZGVza3RvcC5v
cmcvfmdsaXNzZS9saW51eAoKKFNvcnJ5IGlmIHRoYXQgdHJlZSBpcyBiaXQgYmlnIGl0IGhhcyBh
IGxvdCBvZiBkZWFkIHRoaW5nIGkgbmVlZAogdG8gcHVzaCBhIGNsZWFuIGFuZCBzbGltIG9uZSkK
CkrDqXLDtG1lCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
CmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpo
dHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
