From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] mm/mmu_notifier: use structure for
 invalidate_range_start/end calls
Date: Wed, 5 Dec 2018 17:28:57 +0100
Message-ID: <20181205162857.GF30615@quack2.suse.cz>
References: <20181203201817.10759-1-jglisse@redhat.com>
 <20181203201817.10759-3-jglisse@redhat.com>
 <20181205110416.GE22304@quack2.suse.cz>
 <20181205155357.GA3536@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20181205155357.GA3536@redhat.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Jerome Glisse <jglisse@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>, Jan Kara <jack@suse.cz>, kvm@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Felix Kuehling <felix.kuehling@amd.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Christian Koenig <christian.koenig@amd.com>, Ross Zwisler <zwisler@kernel.org>, linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkIDA1LTEyLTE4IDEwOjUzOjU3LCBKZXJvbWUgR2xpc3NlIHdyb3RlOgo+IE9uIFdlZCwg
RGVjIDA1LCAyMDE4IGF0IDEyOjA0OjE2UE0gKzAxMDAsIEphbiBLYXJhIHdyb3RlOgo+ID4gSGkg
SmVyb21lIQo+ID4gCj4gPiBPbiBNb24gMDMtMTItMTggMTU6MTg6MTYsIGpnbGlzc2VAcmVkaGF0
LmNvbSB3cm90ZToKPiA+ID4gRnJvbTogSsOpcsO0bWUgR2xpc3NlIDxqZ2xpc3NlQHJlZGhhdC5j
b20+Cj4gPiA+IAo+ID4gPiBUbyBhdm9pZCBoYXZpbmcgdG8gY2hhbmdlIG1hbnkgY2FsbCBzaXRl
cyBldmVyeXRpbWUgd2Ugd2FudCB0byBhZGQgYQo+ID4gPiBwYXJhbWV0ZXIgdXNlIGEgc3RydWN0
dXJlIHRvIGdyb3VwIGFsbCBwYXJhbWV0ZXJzIGZvciB0aGUgbW11X25vdGlmaWVyCj4gPiA+IGlu
dmFsaWRhdGVfcmFuZ2Vfc3RhcnQvZW5kIGNha2tzLiBObyBmdW5jdGlvbmFsIGNoYW5nZXMgd2l0
aCB0aGlzCj4gPiA+IHBhdGNoLgo+ID4gCj4gPiBUd28gc3VnZ2VzdGlvbnMgZm9yIHRoZSBwYXRj
aCBiZWxvdzoKPiA+IAo+ID4gPiBAQCAtNzcyLDcgKzc3NSw4IEBAIHN0YXRpYyB2b2lkIGRheF9l
bnRyeV9ta2NsZWFuKHN0cnVjdCBhZGRyZXNzX3NwYWNlICptYXBwaW5nLCBwZ29mZl90IGluZGV4
LAo+ID4gPiAgCQkgKiBjYWxsIG1tdV9ub3RpZmllcl9pbnZhbGlkYXRlX3JhbmdlX3N0YXJ0KCkg
b24gb3VyIGJlaGFsZgo+ID4gPiAgCQkgKiBiZWZvcmUgdGFraW5nIGFueSBsb2NrLgo+ID4gPiAg
CQkgKi8KPiA+ID4gLQkJaWYgKGZvbGxvd19wdGVfcG1kKHZtYS0+dm1fbW0sIGFkZHJlc3MsICZz
dGFydCwgJmVuZCwgJnB0ZXAsICZwbWRwLCAmcHRsKSkKPiA+ID4gKwkJaWYgKGZvbGxvd19wdGVf
cG1kKHZtYS0+dm1fbW0sIGFkZHJlc3MsICZyYW5nZSwKPiA+ID4gKwkJCQkgICAmcHRlcCwgJnBt
ZHAsICZwdGwpKQo+ID4gPiAgCQkJY29udGludWU7Cj4gPiAKPiA+IFRoZSBjaGFuZ2Ugb2YgZm9s
bG93X3B0ZV9wbWQoKSBhcmd1bWVudHMgbG9va3MgdW5leHBlY3RlZC4gV2h5IHNob3VsZCB0aGF0
Cj4gPiBjYXJlIGFib3V0IG1tdSBub3RpZmllciByYW5nZT8gSSBzZWUgaXQgbWF5IGJlIGNvbnZl
bmllbnQgYnV0IGl0IGRvZXNuJ3QgbG9vawo+ID4gbGlrZSBhIGdvb2QgQVBJIHRvIG1lLgo+IAo+
IFNhZGRseSBpIGRvIG5vdCBzZWUgYSB3YXkgYXJvdW5kIHRoYXQgb25lIHRoaXMgaXMgYmVjYXVz
ZSBvZiBmcy9kYXguYwo+IHdoaWNoIGRvZXMgdGhlIG1tdV9ub3RpZmllcl9pbnZhbGlkYXRlX3Jh
bmdlX2VuZCB3aGlsZSBmb2xsb3dfcHRlX3BtZAo+IGRvIHRoZSBtbXVfbm90aWZpZXJfaW52YWxp
ZGF0ZV9yYW5nZV9zdGFydAoKSSBzZWUgc28gdGhpcyBpcyByZWFsbHkgYSBwcmVleGlzdGluZyBw
cm9ibGVtIHdpdGggZm9sbG93X3B0ZV9wbWQoKSBoYXZpbmcKdWdseSBpbnRlcmZhY2UuIEFmdGVy
IHNvbWUgdGhvdWdodHMgSSB0aGluayB5b3VyIHBhdGNoIGFjdHVhbGx5IHNsaWdodGx5CmltcHJv
dmVzIHRoZSBzaXR1YXRpb24gc28gT0suCgoJCQkJCQkJCUhvbnphCi0tIApKYW4gS2FyYSA8amFj
a0BzdXNlLmNvbT4KU1VTRSBMYWJzLCBDUgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5m
cmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0
aW5mby9kcmktZGV2ZWwK
