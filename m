From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm,
 oom: distinguish blockable mode for mmu notifiers
Date: Fri, 24 Aug 2018 18:40:03 +0200
Message-ID: <20180824164003.GW29735@dhcp22.suse.cz>
References: <20180716115058.5559-1-mhocko@kernel.org>
 <8cbfb09f-0c5a-8d43-1f5e-f3ff7612e289@I-love.SAKURA.ne.jp>
 <20180824113629.GI29735@dhcp22.suse.cz>
 <103b1b33-1a1d-27a1-dcf8-5c8ad60056a6@i-love.sakura.ne.jp>
 <20180824133207.GR29735@dhcp22.suse.cz>
 <72844762-7398-c770-1702-f945573f4059@i-love.sakura.ne.jp>
 <20180824151239.GC4244@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20180824151239.GC4244@redhat.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Jerome Glisse <jglisse@redhat.com>
Cc: kvm@vger.kernel.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Sudeep Dutt <sudeep.dutt@intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>, Dimitri Sivanich <sivanich@sgi.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>, Doug Ledford <dledford@redhat.com>, David Rientjes <rientjes@google.com>, xen-devel@lists.xenproject.org, intel-gfx@lists.freedesktop.org, Leon Romanovsky <leonro@mellanox.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, LKML <linux-kernel@vger>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpIDI0LTA4LTE4IDExOjEyOjQwLCBKZXJvbWUgR2xpc3NlIHdyb3RlOgpbLi4uXQo+IEkg
YW0gZmluZSB3aXRoIE1pY2hhbCBwYXRjaCwgaSBhbHJlYWR5IHNhaWQgc28gY291cGxlIG1vbnRo
IGFnbyBmaXJzdCB0aW1lCj4gdGhpcyBkaXNjdXNzaW9uIGRpZCBwb3AgdXAsIE1pY2hhbCB5b3Ug
Y2FuIGFkZDoKPiAKPiBSZXZpZXdlZC1ieTogSsOpcsO0bWUgR2xpc3NlIDxqZ2xpc3NlQHJlZGhh
dC5jb20+CgpTbyBJIGd1ZXNzIHRoZSBiZWxvdyBpcyB0aGUgcGF0Y2ggeW91IHdlcmUgdGFsa2lu
ZyBhYm91dD8KCkZyb20gZjdhYzc1Mjc3ZDUyNmRjY2QwMTFmMzQzODE4ZGM2YWY2MjdhZjJhZiBN
b24gU2VwIDE3IDAwOjAwOjAwIDIwMDEKRnJvbTogTWljaGFsIEhvY2tvIDxtaG9ja29Ac3VzZS5j
b20+CkRhdGU6IEZyaSwgMjQgQXVnIDIwMTggMTU6MzI6MjQgKzAyMDAKU3ViamVjdDogW1BBVENI
XSBtbSwgbW11X25vdGlmaWVyOiBiZSBleHBsaWNpdCBhYm91dCByYW5nZSBpbnZhbGl0aW9uCiBu
b24tYmxvY2tpbmcgbW9kZQoKSWYgaW52YWxpZGF0ZV9yYW5nZV9zdGFydCBpcyBjYWxsZWQgZm9y
ICFibG9ja2luZyBtb2RlIHRoZW4gYWxsCmNhbGxiYWNrcyBoYXZlIHRvIGd1YXJhbnRlZSB0aGV5
IHdpbGwgbm8gYmxvY2svc2xlZXAuIFRoZSBzYW1lIG9idmlvdXNseQphcHBsaWVzIHRvIGludmFs
aWRhdGVfcmFuZ2VfZW5kIGJlY2F1c2UgdGhpcyBvcGVyYXRpb24gcGFpcnMgd2l0aCB0aGUKZm9y
bWVyIGFuZCB0aGV5IGFyZSBjYWxsZWQgZnJvbSB0aGUgc2FtZSBjb250ZXh0LiBNYWtlIHN1cmUg
dGhpcyBpcwphcHByb3ByaWF0ZWx5IGRvY3VtZW50ZWQuCgpTaWduZWQtb2ZmLWJ5OiBNaWNoYWwg
SG9ja28gPG1ob2Nrb0BzdXNlLmNvbT4KLS0tCiBpbmNsdWRlL2xpbnV4L21tdV9ub3RpZmllci5o
IHwgNCArKystCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
CgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tbXVfbm90aWZpZXIuaCBiL2luY2x1ZGUvbGlu
dXgvbW11X25vdGlmaWVyLmgKaW5kZXggMTMzYmE3ODgyMGVlLi42OThlMzcxYWFmZTMgMTAwNjQ0
Ci0tLSBhL2luY2x1ZGUvbGludXgvbW11X25vdGlmaWVyLmgKKysrIGIvaW5jbHVkZS9saW51eC9t
bXVfbm90aWZpZXIuaApAQCAtMTUzLDcgKzE1Myw5IEBAIHN0cnVjdCBtbXVfbm90aWZpZXJfb3Bz
IHsKIAkgKgogCSAqIElmIGJsb2NrYWJsZSBhcmd1bWVudCBpcyBzZXQgdG8gZmFsc2UgdGhlbiB0
aGUgY2FsbGJhY2sgY2Fubm90CiAJICogc2xlZXAgYW5kIGhhcyB0byByZXR1cm4gd2l0aCAtRUFH
QUlOLiAwIHNob3VsZCBiZSByZXR1cm5lZAotCSAqIG90aGVyd2lzZS4KKwkgKiBvdGhlcndpc2Uu
IFBsZWFzZSBub3RlIHRoYXQgaWYgaW52YWxpZGF0ZV9yYW5nZV9zdGFydCBhcHByb3ZlcworCSAq
IGEgbm9uLWJsb2NraW5nIGJlaGF2aW9yIHRoZW4gdGhlIHNhbWUgYXBwbGllcyB0bworCSAqIGlu
dmFsaWRhdGVfcmFuZ2VfZW5kLgogCSAqCiAJICovCiAJaW50ICgqaW52YWxpZGF0ZV9yYW5nZV9z
dGFydCkoc3RydWN0IG1tdV9ub3RpZmllciAqbW4sCi0tIAoyLjE4LjAKCi0tIApNaWNoYWwgSG9j
a28KU1VTRSBMYWJzCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCkludGVsLWdmeCBtYWlsaW5nIGxpc3QKSW50ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9y
ZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2ludGVsLWdm
eAo=
