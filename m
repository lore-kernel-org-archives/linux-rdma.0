From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH] mm,
 oom: distinguish blockable mode for mmu notifiers
Date: Fri, 24 Aug 2018 22:02:23 +0900
Message-ID: <103b1b33-1a1d-27a1-dcf8-5c8ad60056a6@i-love.sakura.ne.jp>
References: <20180716115058.5559-1-mhocko@kernel.org>
 <8cbfb09f-0c5a-8d43-1f5e-f3ff7612e289@I-love.SAKURA.ne.jp>
 <20180824113629.GI29735@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <20180824113629.GI29735@dhcp22.suse.cz>
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
To: Michal Hocko <mhocko@kernel.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>
Cc: kvm@vger.kernel.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, David Airlie <airlied@linux.ie>, Sudeep Dutt <sudeep.dutt@intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>, "David (ChunMing) Zhou" <David1.Zhou@amd.com>, Dimitri Sivanich <sivanich@sgi.com>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, David Rientjes <rientjes@google.com>, xen-devel@lists.xenproject.org, intel-gfx@lists.freedesktop.org, Leon Romanovsky <leonro@mellanox.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Felix Kuehling <felix.kuehling@amd.com>, LKML <linux-kernel@vger.kernel.org>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.ko>
List-Id: linux-rdma@vger.kernel.org

T24gMjAxOC8wOC8yNCAyMDozNiwgTWljaGFsIEhvY2tvIHdyb3RlOgo+PiBUaGF0IGlzLCB0aGlz
IEFQSSBzZWVtcyB0byBiZSBjdXJyZW50bHkgdXNlZCBieSBvbmx5IG91dC1vZi10cmVlIHVzZXJz
LiBTaW5jZQo+PiB3ZSBjYW4ndCBjaGVjayB0aGF0IG5vYm9keSBoYXMgbWVtb3J5IGFsbG9jYXRp
b24gZGVwZW5kZW5jeSwgSSB0aGluayB0aGF0Cj4+IGhtbV9pbnZhbGlkYXRlX3JhbmdlX3N0YXJ0
KCkgc2hvdWxkIHJldHVybiAtRUFHQUlOIGlmIGJsb2NrYWJsZSA9PSBmYWxzZSBmb3Igbm93Lgo+
IAo+IFRoZSBjb2RlIGV4cGVjdHMgdGhhdCB0aGUgaW52YWxpZGF0ZV9yYW5nZV9lbmQgZG9lc24n
dCBibG9jayBpZgo+IGludmFsaWRhdGVfcmFuZ2Vfc3RhcnQgaGFzbid0IGJsb2NrZWQuIFRoYXQg
aXMgdGhlIHJlYXNvbiB3aHkgdGhlIGVuZAo+IGNhbGxiYWNrIGRvZXNuJ3QgaGF2ZSBibG9ja2Fi
bGUgcGFyYW1ldGVyLiBJZiB0aGlzIGRvZXNuJ3QgaG9sZCB0aGVuIHRoZQo+IHdob2xlIHNjaGVt
ZSBpcyBqdXN0IGZyYWdpbGUgYmVjYXVzZSB0aG9zZSB0d28gY2FsbHMgc2hvdWxkIHBhaXIuCj4g
ClRoYXQgaXMKCiAgTW9yZSB3b3JyaXNvbWUgcGFydCBpbiB0aGF0IHBhdGNoIGlzIHRoYXQgSSBk
b24ndCBrbm93IHdoZXRoZXIgdXNpbmcKICB0cnlsb2NrIGlmIGJsb2NrYWJsZSA9PSBmYWxzZSBh
dCBlbnRyeSBpcyByZWFsbHkgc3VmZmljaWVudC4KCi4gU2luY2UgdGhvc2UgdHdvIGNhbGxzIHNo
b3VsZCBwYWlyLCBJIHRoaW5rIHRoYXQgd2UgbmVlZCB0byBkZXRlcm1pbmUgd2hldGhlcgp3ZSBu
ZWVkIHRvIHJldHVybiAtRUFHQUlOIGF0IHN0YXJ0IGNhbGwgYnkgZXZhbHVhdGluZyBib3RoIGNh
bGxzLgoKTGlrZSBtbl9pbnZsX3JhbmdlX3N0YXJ0KCkgaW52b2x2ZXMgc2NoZWR1bGVfZGVsYXll
ZF93b3JrKCkgd2hpY2ggY291bGQgYmUKYmxvY2tlZCBvbiBtZW1vcnkgYWxsb2NhdGlvbiB1bmRl
ciBPT00gc2l0dWF0aW9uLCBJIHdvcnJ5IHRoYXQgKGN1cnJlbnRseQpvdXQtb2YtdHJlZSkgdXNl
cnMgb2YgdGhpcyBBUEkgYXJlIGludm9sdmluZyB3b3JrIC8gcmVjdXJzaW9uLgpBbmQgaG1tX3Jl
bGVhc2UoKSBzYXlzIHRoYXQKCgkvKgoJICogRHJvcCBtaXJyb3JzX3NlbSBzbyBjYWxsYmFjayBj
YW4gd2FpdCBvbiBhbnkgcGVuZGluZwoJICogd29yayB0aGF0IG1pZ2h0IGl0c2VsZiB0cmlnZ2Vy
IG1tdV9ub3RpZmllciBjYWxsYmFjawoJICogYW5kIHRodXMgd291bGQgZGVhZGxvY2sgd2l0aCB1
cy4KCSAqLwoKYW5kIGtlZXBzICJhbGwgb3BlcmF0aW9ucyBwcm90ZWN0ZWQgYnkgaG1tLT5taXJy
b3JzX3NlbSBoZWxkIGZvciB3cml0ZSBhcmUKYXRvbWljIi4gVGhpcyBzdWdnZXN0cyB0aGF0ICJz
b21lIG9wZXJhdGlvbnMgcHJvdGVjdGVkIGJ5IGhtbS0+bWlycm9yc19zZW0gaGVsZApmb3IgcmVh
ZCB3aWxsIHNsZWVwIChhbmQgaW4gdGhlIHdvcnN0IGNhc2UgaW52b2x2ZXMgbWVtb3J5IGFsbG9j
YXRpb24KZGVwZW5kZW5jeSkiLgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KSW50ZWwtZ2Z4IG1haWxpbmcgbGlzdApJbnRlbC1nZnhAbGlzdHMuZnJlZWRl
c2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8v
aW50ZWwtZ2Z4Cg==
