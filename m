From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 0/9] mmu notifier provide context informations
Date: Tue, 19 Feb 2019 12:15:55 -0800
Message-ID: <CAPcyv4gq23RXk3BTqP2O+gi3FGE85NSGXD8bdLk+_cgtZrn+Kg@mail.gmail.com>
References: <20190219200430.11130-1-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190219200430.11130-1-jglisse@redhat.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>
Cc: Jan Kara <jack@suse.cz>, KVM list <kvm@vger.kernel.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, Ross Zwisler <zwisler@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, linux-rdma <linux-rdma@vger.kernel.org>, Jason Gunthorpe <jgg@mellanox.com>, Ralph Campbell <rcampbell@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCBGZWIgMTksIDIwMTkgYXQgMTI6MDQgUE0gPGpnbGlzc2VAcmVkaGF0LmNvbT4gd3Jv
dGU6Cj4KPiBGcm9tOiBKw6lyw7RtZSBHbGlzc2UgPGpnbGlzc2VAcmVkaGF0LmNvbT4KPgo+IFNp
bmNlIGxhc3QgdmVyc2lvbiBbNF0gaSBhZGRlZCB0aGUgZXh0cmEgYml0cyBuZWVkZWQgZm9yIHRo
ZSBjaGFuZ2VfcHRlCj4gb3B0aW1pemF0aW9uICh3aGljaCBpcyBhIEtTTSB0aGluZykuIEhlcmUg
aSBhbSBub3QgcG9zdGluZyB1c2VycyBvZgo+IHRoaXMsIHRoZXkgd2lsbCBiZSBwb3N0ZWQgdG8g
dGhlIGFwcHJvcHJpYXRlIHN1Yi1zeXN0ZW1zIChLVk0sIEdQVSwKPiBSRE1BLCAuLi4pIG9uY2Ug
dGhpcyBzZXJpZSBnZXQgdXBzdHJlYW0uIElmIHlvdSB3YW50IHRvIGxvb2sgYXQgdXNlcnMKPiBv
ZiB0aGlzIHNlZSBbNV0gWzZdLiBJZiB0aGlzIGdldHMgaW4gNS4xIHRoZW4gaSB3aWxsIGJlIHN1
Ym1pdHRpbmcKPiB0aG9zZSB1c2VycyBmb3IgNS4yIChpbmNsdWRpbmcgS1ZNIGlmIEtWTSBmb2xr
cyBmZWVsIGNvbWZvcnRhYmxlIHdpdGgKPiBpdCkuCgpUaGUgdXNlcnMgbG9vayBzbWFsbCBhbmQg
c3RyYWlnaHRmb3J3YXJkLiBXaHkgbm90IGF3YWl0IGFja3MgYW5kCnJldmlld2VkLWJ5J3MgZm9y
IHRoZSB1c2VycyBsaWtlIGEgdHlwaWNhbCB1cHN0cmVhbSBzdWJtaXNzaW9uIGFuZAptZXJnZSB0
aGVtIHRvZ2V0aGVyPyBJcyBhbGwgb2YgdGhlIGZ1bmN0aW9uYWxpdHkgb2YgdGhpcwppbmZyYXN0
cnVjdHVyZSBjb25zdW1lZCBieSB0aGUgcHJvcG9zZWQgdXNlcnM/IExhc3QgdGltZSBJIGNoZWNr
ZWQgaXQKd2FzIG9ubHkgYSBzdWJzZXQuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZy
ZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3Rp
bmZvL2RyaS1kZXZlbA==
