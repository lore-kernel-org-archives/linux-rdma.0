From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Subject: Re: [RFC PATCH] mm,
 oom: distinguish blockable mode for mmu notifiers
Date: Mon, 2 Jul 2018 14:13:42 +0200
Message-ID: <725cb1ad-01b0-42b5-56f0-c08c29804cb4@amd.com>
References: <20180622150242.16558-1-mhocko@kernel.org>
 <20180627074421.GF32348@dhcp22.suse.cz>
 <71f4184c-21ea-5af1-eeb6-bf7787614e2d@amd.com>
 <20180702115423.GK19043@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <20180702115423.GK19043@dhcp22.suse.cz>
Content-Language: en-US
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Michal Hocko <mhocko@kernel.org>
Cc: kvm@vger.kernel.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, David Airlie <airlied@linux.ie>, Sudeep Dutt <sudeep.dutt@intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>, Dimitri Sivanich <sivanich@sgi.com>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, David Rientjes <rientjes@google.com>, xen-devel@lists.xenproject.org, intel-gfx@lists.freedesktop.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, LKML <linux-kernel@vger.kernel.org>, Ashutosh Dixit <ash>
List-Id: linux-rdma@vger.kernel.org

QW0gMDIuMDcuMjAxOCB1bSAxMzo1NCBzY2hyaWViIE1pY2hhbCBIb2NrbzoKPiBPbiBNb24gMDIt
MDctMTggMTE6MTQ6NTgsIENocmlzdGlhbiBLw7ZuaWcgd3JvdGU6Cj4+IEFtIDI3LjA2LjIwMTgg
dW0gMDk6NDQgc2NocmllYiBNaWNoYWwgSG9ja286Cj4+PiBUaGlzIGlzIHRoZSB2MiBvZiBSRkMg
YmFzZWQgb24gdGhlIGZlZWRiYWNrIEkndmUgcmVjZWl2ZWQgc28gZmFyLiBUaGUKPj4+IGNvZGUg
ZXZlbiBjb21waWxlcyBhcyBhIGJvbnVzIDspIEkgaGF2ZW4ndCBydW50aW1lIHRlc3RlZCBpdCB5
ZXQsIG1vc3RseQo+Pj4gYmVjYXVzZSBJIGhhdmUgbm8gaWRlYSBob3cuCj4+Pgo+Pj4gQW55IGZ1
cnRoZXIgZmVlZGJhY2sgaXMgaGlnaGx5IGFwcHJlY2lhdGVkIG9mIGNvdXJzZS4KPj4gVGhhdCBz
b3VuZHMgbGlrZSBpdCBzaG91bGQgd29yayBhbmQgYXQgbGVhc3QgdGhlIGFtZGdwdSBjaGFuZ2Vz
IG5vdyBsb29rCj4+IGdvb2QgdG8gbWUgb24gZmlyc3QgZ2xhbmNlLgo+Pgo+PiBDYW4geW91IHNw
bGl0IHRoYXQgdXAgZnVydGhlciBpbiB0aGUgdXN1YWwgd2F5PyBFLmcuIGFkZGluZyB0aGUgYmxv
Y2thYmxlCj4+IGZsYWcgaW4gb25lIHBhdGNoIGFuZCBmaXhpbmcgYWxsIGltcGxlbWVudGF0aW9u
cyBvZiB0aGUgTU1VIG5vdGlmaWVyIGluCj4+IGZvbGxvdyB1cCBwYXRjaGVzLgo+IEJ1dCBzdWNo
IGEgY29kZSB3b3VsZCBiZSBicm9rZW4sIG5vPyBJZ25vcmluZyB0aGUgYmxvY2thYmxlIHN0YXRl
IHdpbGwKPiBzaW1wbHkgbGVhZCB0byBsb2NrdXBzIHVudGlsIHRoZSBmaXh1cCBwYXJ0cyBnZXQg
YXBwbGllZC4KCldlbGwgdG8gc3RpbGwgYmUgYmlzZWN0LWFibGUgeW91IG9ubHkgbmVlZCB0byBn
ZXQgdGhlIGludGVyZmFjZSBjaGFuZ2UgCmluIGZpcnN0IHdpdGggZml4aW5nIHRoZSBmdW5jdGlv
biBzaWduYXR1cmUgb2YgdGhlIGltcGxlbWVudGF0aW9ucy4KClRoZW4gYWRkIGFsbCB0aGUgbmV3
IGNvZGUgdG8gdGhlIGltcGxlbWVudGF0aW9ucyBhbmQgbGFzdCBzdGFydCB0byAKYWN0dWFsbHkg
dXNlIHRoZSBuZXcgaW50ZXJmYWNlLgoKVGhhdCBpcyBhIHBhdHRlcm4gd2UgdXNlIHJlZ3VsYXJs
eSBhbmQgSSB0aGluayBpdCdzIGdvb2QgcHJhY3RpY2UgdG8gZG8gCnRoaXMuCgo+IElzIHRoZSBz
cGxpdCB1cCByZWFsbHkgd29ydGggaXQ/IEkgd2FzIHRoaW5raW5nIGFib3V0IHRoYXQgYnV0IGhh
ZCBoYXJkCj4gdGltZXMgdG8gZW5kIHVwIHdpdGggc29tZXRoaW5nIHRoYXQgd291bGQgYmUgYmlz
ZWN0YWJsZS4gV2VsbCwgZXhjZXB0Cj4gZm9yIHJldHVybmluZyAtRUJVU1kgdW50aWwgYWxsIG5v
dGlmaWVycyBhcmUgaW1wbGVtZW50ZWQuIFdoaWNoIEkgZm91bmQKPiBjb25mdXNpbmcuCgpJdCBh
dCBsZWFzdCBtYWtlcyByZXZpZXdpbmcgY2hhbmdlcyBtdWNoIGVhc2llciwgY2F1c2UgYXMgZHJp
dmVyIAptYWludGFpbmVyIEkgY2FuIGNvbmNlbnRyYXRlIG9uIHRoZSBzdHVmZiBvbmx5IHJlbGF0
ZWQgdG8gbWUuCgpBZGRpdGlvbmFsIHRvIHRoYXQgd2hlbiB5b3UgY2F1c2Ugc29tZSB1bnJlbGF0
ZWQgc2lkZSBlZmZlY3QgaW4gYSBkcml2ZXIgCndlIGNhbiBtdWNoIGVhc2llciBwaW5wb2ludCB0
aGUgYWN0dWFsIGNoYW5nZSBsYXRlciBvbiB3aGVuIHRoZSBwYXRjaCBpcyAKc21hbGxlci4KCj4K
Pj4gVGhpcyB3YXkgSSdtIHByZXR0eSBzdXJlIEZlbGl4IGFuZCBJIGNhbiBnaXZlIGFuIHJiIG9u
IHRoZSBhbWRncHUvYW1ka2ZkCj4+IGNoYW5nZXMuCj4gSWYgeW91IGFyZSB3b3JyaWVkIHRvIGdp
dmUgci1iIG9ubHkgZm9yIHRob3NlIHRoZW4gdGhpcyBjYW4gYmUgZG9uZSBldmVuCj4gZm9yIGxh
cmdlciBwYXRjaGVzLiBKdXN0IG1ha2UgeW91ciBSZXZpZXdkLWJ5IG1vcmUgc3BlY2lmaWMKPiBS
LWI6IG5hbWUgIyBGb3IgQkxBIEJMQQoKWWVhaCwgcG9zc2libGUgYWx0ZXJuYXRpdmUgYnV0IG1v
cmUgd29yayBmb3IgbWUgd2hlbiBJIHJldmlldyBpdCA6KQoKUmVnYXJkcywKQ2hyaXN0aWFuLgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpJbnRlbC1nZngg
bWFpbGluZyBsaXN0CkludGVsLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0
cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9pbnRlbC1nZngK
