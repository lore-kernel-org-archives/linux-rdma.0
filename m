From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH] mm,
 oom: distinguish blockable mode for mmu notifiers
Date: Fri, 7 Sep 2018 07:46:09 +0900
Message-ID: <841ae1fb-bb5a-8b1e-6383-ca2e70b6e759@i-love.sakura.ne.jp>
References: <20180824120339.GL29735@dhcp22.suse.cz>
 <eb546bcb-9c5f-7d5d-43a7-bfde489f0e7f@amd.com>
 <20180824123341.GN29735@dhcp22.suse.cz>
 <b11df415-baf8-0a41-3c16-60dfe8d32bd3@amd.com>
 <20180824130132.GP29735@dhcp22.suse.cz>
 <23d071d2-82e4-9b78-1000-be44db5f6523@gmail.com>
 <20180824132442.GQ29735@dhcp22.suse.cz>
 <86bd94d5-0ce8-c67f-07a5-ca9ebf399cdd@gmail.com>
 <20180824134009.GS29735@dhcp22.suse.cz>
 <735b0a53-5237-8827-d20e-e57fa24d798f@amd.com>
 <20180824135257.GU29735@dhcp22.suse.cz>
 <b78f8b3a-7bc6-0dea-6752-5ea798eccb6b@i-love.sakura.ne.jp>
 <0e80c531-4e91-fb1d-e7eb-46a7aecc4c9d@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <0e80c531-4e91-fb1d-e7eb-46a7aecc4c9d@amd.com>
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
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Michal Hocko <mhocko@kernel.org>
Cc: kvm@vger.kernel.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, David Airlie <airlied@linux.ie>, Sudeep Dutt <sudeep.dutt@intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>, Dimitri Sivanich <sivanich@sgi.com>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, David Rientjes <rientjes@google.com>, xen-devel@lists.xenproject.org, intel-gfx@lists.freedesktop.org, Leon Romanovsky <leonro@mellanox.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, LKML <linux-kernel@vger.kernel.org>, Ashutosh Dixit <ashutosh.dixit>
List-Id: linux-rdma@vger.kernel.org

T24gMjAxOC8wOC8yNyAxNjo0MSwgQ2hyaXN0aWFuIEvDtm5pZyB3cm90ZToKPiBBbSAyNi4wOC4y
MDE4IHVtIDEwOjQwIHNjaHJpZWIgVGV0c3VvIEhhbmRhOgo+PiBJJ20gbm90IGZvbGxvd2luZy4g
V2h5IGRvbid0IHdlIG5lZWQgdG8gZG8gbGlrZSBiZWxvdyAoZ2l2ZW4gdGhhdAo+PiBub2JvZHkg
ZXhjZXB0IGFtZGdwdV9tbl9yZWFkX2xvY2soKSBob2xkcyAtPnJlYWRfbG9jaykgYmVjYXVzZSBl
LmcuCj4+IGRybV9zY2hlZF9mZW5jZV9jcmVhdGUoKSBmcm9tIGRybV9zY2hlZF9qb2JfaW5pdCgp
IGZyb20gYW1kZ3B1X2NzX3N1Ym1pdCgpCj4+IGlzIGRvaW5nIEdGUF9LRVJORUwgbWVtb3J5IGFs
bG9jYXRpb24gd2l0aCAtPmxvY2sgaGVsZCBmb3Igd3JpdGU/Cj4gCj4gVGhhdCdzIGEgYnVnIHdo
aWNoIG5lZWRzIHRvIGJlIGZpeGVkIHNlcGFyYXRlbHkuCj4gCj4gQWxsb2NhdGluZyBtZW1vcnkg
d2l0aCBHRlBfS0VSTkVMIHdoaWxlIGhvbGRpbmcgYSBsb2NrIHdoaWNoIGlzIGFsc28gdGFrZW4g
aW4gdGhlIHJlY2xhaW0gY29kZSBwYXRoIGlzIGlsbGVnYWwgbm90IG1hdHRlciB3aGF0IHlvdSBk
by4KPiAKPiBQYXRjaGVzIHRvIGZpeCB0aGlzIGFyZSBhbHJlYWR5IG9uIHRoZSBhcHByb3ByaWF0
ZSBtYWlsaW5nIGxpc3QgYW5kIHdpbGwgYmUgcHVzaGVkIHVwc3RyZWFtIHRvZGF5Lgo+IAo+IFJl
Z2FyZHMsCj4gQ2hyaXN0aWFuLgoKQ29tbWl0IDRhMmRlNTRkYzFkNzY2OGYgKCJkcm0vYW1kZ3B1
OiBmaXggaG9sZGluZyBtbl9sb2NrIHdoaWxlIGFsbG9jYXRpbmcgbWVtb3J5IikKc2VlbXMgdG8g
YmUgY2FsbGluZyBhbWRncHVfbW5fdW5sb2NrKCkgd2l0aG91dCBhbWRncHVfbW5fbG9jaygpIHdo
ZW4KZHJtX3NjaGVkX2pvYl9pbml0KCkgZmFpbGVkLi4uIAoKCgpNaWNoYWwsIHlvdSBhcmUgYXNr
aW5nIG1lIHRvIGZpeCBhbGwgYnVncyAoaW5jbHVkaW5nIG91dCBvZiB0cmVlIGNvZGUpIGFuZCBw
cmV2ZW50CmZ1dHVyZSBidWdzIGp1c3QgYmVjYXVzZSB5b3Ugd2FudCB0byBhdm9pZCB1c2luZyB0
aW1lb3V0IGluIG9yZGVyIHRvIGF2b2lkIE9PTSBsb2NrdXAKKCBodHRwczovL21hcmMuaW5mby8/
aT01NWEzZmIzNy0zMjQ2LTczZDctMGY0NS01ODM1YTNmNDgzMWNAaS1sb3ZlLnNha3VyYS5uZS5q
cCApLgpUaGF0IGlzIGEgdG9vIG11Y2ggcmVxdWVzdCB3aGljaCBpcyBpbXBvc3NpYmxlIGZvciBl
dmVuIHlvdS4gTW9yZSB5b3UgY291bnQgb24KdGhlIE9PTSByZWFwZXIsIHdlIGV4cG9uZW50aWFs
bHkgY29tcGxpY2F0ZXMgZGVwZW5kZW5jeSBhbmQgbW9yZSBsaWtlbHkgdG8gc3R1bWJsZQpvdmVy
IHVucmV2aWV3ZWQvdW50ZXN0ZWQgY29kZS4uLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwpJbnRlbC1nZnggbWFpbGluZyBsaXN0CkludGVsLWdmeEBsaXN0
cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9s
aXN0aW5mby9pbnRlbC1nZngK
