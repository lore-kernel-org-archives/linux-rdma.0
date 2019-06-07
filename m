From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v2 hmm 07/11] mm/hmm: Use lockdep instead of comments
Date: Thu, 6 Jun 2019 20:19:33 -0700
Message-ID: <c1916bf0-1cec-9742-da9a-cfb0620be1f6@nvidia.com>
References: <20190606184438.31646-1-jgg@ziepe.ca>
 <20190606184438.31646-8-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190606184438.31646-8-jgg@ziepe.ca>
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
To: Jason Gunthorpe <jgg@ziepe.ca>, Jerome Glisse <jglisse@redhat.com>, Ralph
 Campbell <rcampbell@nvidia.com>, Felix.Kuehling@amd.com
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, linux-mm@kvack.org, Jason Gunthorpe <jgg@mellanox.com>, dri-devel@lists.freedesktop.org
List-Id: linux-rdma@vger.kernel.org

T24gNi82LzE5IDExOjQ0IEFNLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6Cj4gRnJvbTogSmFzb24g
R3VudGhvcnBlIDxqZ2dAbWVsbGFub3guY29tPgo+IAo+IFNvIHdlIGNhbiBjaGVjayBsb2NraW5n
IGF0IHJ1bnRpbWUuCj4gCj4gU2lnbmVkLW9mZi1ieTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVs
bGFub3guY29tPgo+IFJldmlld2VkLWJ5OiBKw6lyw7RtZSBHbGlzc2UgPGpnbGlzc2VAcmVkaGF0
LmNvbT4KPiAtLS0KPiB2Mgo+IC0gRml4IG1pc3NpbmcgJiBpbiBsb2NrZGVwcyAoSmFzb24pCj4g
LS0tCj4gIG1tL2htbS5jIHwgNCArKy0tCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL21tL2htbS5jIGIvbW0vaG1tLmMK
PiBpbmRleCBmNjdiYTMyOTgzZDlmMS4uYzcwMmNkNzI2NTFiNTMgMTAwNjQ0Cj4gLS0tIGEvbW0v
aG1tLmMKPiArKysgYi9tbS9obW0uYwo+IEBAIC0yNTQsMTEgKzI1NCwxMSBAQCBzdGF0aWMgY29u
c3Qgc3RydWN0IG1tdV9ub3RpZmllcl9vcHMgaG1tX21tdV9ub3RpZmllcl9vcHMgPSB7Cj4gICAq
Cj4gICAqIFRvIHN0YXJ0IG1pcnJvcmluZyBhIHByb2Nlc3MgYWRkcmVzcyBzcGFjZSwgdGhlIGRl
dmljZSBkcml2ZXIgbXVzdCByZWdpc3Rlcgo+ICAgKiBhbiBITU0gbWlycm9yIHN0cnVjdC4KPiAt
ICoKPiAtICogVEhFIG1tLT5tbWFwX3NlbSBNVVNUIEJFIEhFTEQgSU4gV1JJVEUgTU9ERSAhCj4g
ICAqLwo+ICBpbnQgaG1tX21pcnJvcl9yZWdpc3RlcihzdHJ1Y3QgaG1tX21pcnJvciAqbWlycm9y
LCBzdHJ1Y3QgbW1fc3RydWN0ICptbSkKPiAgewo+ICsJbG9ja2RlcF9hc3NlcnRfaGVsZF9leGNs
dXNpdmUoJm1tLT5tbWFwX3NlbSk7Cj4gKwo+ICAJLyogU2FuaXR5IGNoZWNrICovCj4gIAlpZiAo
IW1tIHx8ICFtaXJyb3IgfHwgIW1pcnJvci0+b3BzKQo+ICAJCXJldHVybiAtRUlOVkFMOwo+IAoK
ICAgIFJldmlld2VkLWJ5OiBKb2huIEh1YmJhcmQgPGpodWJiYXJkQG52aWRpYS5jb20+CgoKdGhh
bmtzLAotLSAKSm9obiBIdWJiYXJkCk5WSURJQQpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0
cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9s
aXN0aW5mby9kcmktZGV2ZWw=
