From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 0/9] mmu notifier provide context informations
Date: Fri, 1 Feb 2019 22:02:30 +0100
Message-ID: <20190201210230.GA11643@quack2.suse.cz>
References: <20190123222315.1122-1-jglisse@redhat.com>
 <20190131161006.GA16593@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190131161006.GA16593@redhat.com>
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
Cc: Ralph Campbell <rcampbell@nvidia.com>, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Jason Gunthorpe <jgg@mellanox.com>, Ross Zwisler <zwisler@kernel.org>, linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1IDMxLTAxLTE5IDExOjEwOjA2LCBKZXJvbWUgR2xpc3NlIHdyb3RlOgo+IAo+IEFuZHJl
dyB3aGF0IGlzIHlvdXIgcGxhbiBmb3IgdGhpcyA/IEkgaGFkIGEgZGlzY3Vzc2lvbiB3aXRoIFBl
dGVyIFh1Cj4gYW5kIEFuZHJlYSBhYm91dCBjaGFuZ2VfcHRlKCkgYW5kIGt2bS4gVG9kYXkgdGhl
IGNoYW5nZV9wdGUoKSBrdm0KPiBvcHRpbWl6YXRpb24gaXMgZWZmZWN0aXZlbHkgZGlzYWJsZWQg
YmVjYXVzZSBvZiBpbnZhbGlkYXRlX3JhbmdlCj4gY2FsbHMuIFdpdGggYSBtaW5pbWFsIGNvdXBs
ZSBsaW5lcyBwYXRjaCBvbiB0b3Agb2YgdGhpcyBwYXRjaHNldAo+IHdlIGNhbiBicmluZyBiYWNr
IHRoZSBrdm0gY2hhbmdlX3B0ZSBvcHRpbWl6YXRpb24gYW5kIHdlIGNhbiBhbHNvCj4gb3B0aW1p
emUgc29tZSBvdGhlciBjYXNlcyBsaWtlIGZvciBpbnN0YW5jZSB3aGVuIHdyaXRlIHByb3RlY3Rp
bmcKPiBhZnRlciBmb3JrIChidXQgaSBhbSBub3Qgc3VyZSB0aGlzIGlzIHNvbWV0aGluZyBxZW11
IGRvZXMgb2Z0ZW4gc28KPiBpdCBtaWdodCBub3QgaGVscCBmb3IgcmVhbCBrdm0gd29ya2xvYWQp
Lgo+IAo+IEkgd2lsbCBiZSBwb3N0aW5nIGEgdGhlIGV4dHJhIHBhdGNoIGFzIGFuIFJGQywgYnV0
IGluIHRoZSBtZWFudGltZQo+IGkgd2FudGVkIHRvIGtub3cgd2hhdCB3YXMgdGhlIHN0YXR1cyBm
b3IgdGhpcy4KPiAKPiBKYW4sIENocmlzdGlhbiBkb2VzIHlvdXIgcHJldmlvdXMgQUNLIHN0aWxs
IGhvbGRzIGZvciB0aGlzID8KClllcywgSSBzdGlsbCB0aGluayB0aGUgYXBwcm9hY2ggbWFrZXMg
c2Vuc2UuIERhbidzIGNvbmNlcm4gYWJvdXQgaW4gdHJlZQp1c2VycyBpcyB2YWxpZCBidXQgaXQg
c2VlbXMgeW91IGhhdmUgdGhvc2UganVzdCBub3QgbWVyZ2VkIHlldCwgcmlnaHQ/CgoJCQkJCQkJ
CUhvbnphCgotLSAKSmFuIEthcmEgPGphY2tAc3VzZS5jb20+ClNVU0UgTGFicywgQ1IKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxp
bmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJl
ZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
