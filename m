From: "Kuehling, Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v3 hmm 11/12] mm/hmm: Remove confusing comment and logic
 from hmm_release
Date: Wed, 19 Jun 2019 00:53:55 +0000
Message-ID: <be4f8573-6284-04a6-7862-23bb357bfe3c@amd.com>
References: <20190614004450.20252-1-jgg@ziepe.ca>
 <20190614004450.20252-12-jgg@ziepe.ca> <20190615142106.GK17724@infradead.org>
 <20190618004509.GE30762@ziepe.ca> <20190618053733.GA25048@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190618053733.GA25048-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Content-ID: <BDC9BD32EDDEB14C9515C4D0AC9287F7-asWib9pRmPqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Yang,
 Philip" <Philip.Yang-5C7GfCeVMHo@public.gmane.org>, Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Ben Skeggs <bskeggs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gMjAxOS0wNi0xOCAxOjM3LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gT24gTW9uLCBK
dW4gMTcsIDIwMTkgYXQgMDk6NDU6MDlQTSAtMDMwMCwgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0K
Pj4gQW0gSSBsb29raW5nIGF0IHRoZSB3cm9uZyB0aGluZz8gTG9va3MgbGlrZSBpdCBjYWxscyBp
dCB0aHJvdWdoIGEgd29yaw0KPj4gcXVldWUgc2hvdWxkIHNob3VsZCBiZSBPSy4uDQo+IFllcywg
aXQgY2FsbHMgaXQgdGhyb3VnaCBhIHdvcmsgcXVldWUuICBJIGd1ZXNzIHRoYXQgaXMgZmluZSBi
ZWNhdXNlDQo+IGl0IG5lZWRzIHRvIHRha2UgdGhlIGxvY2sgYWdhaW4uDQo+DQo+PiBUaG91Z2gg
dmVyeSBzdHJhbmdlIHRoYXQgYW1kZ3B1IG9ubHkgZGVzdHJveXMgdGhlIG1pcnJvciB2aWEgcmVs
ZWFzZSwNCj4+IHRoYXQgY2Fubm90IGJlIHJpZ2h0Lg0KPiBBcyBzYWlkIHRoZSB3aG9sZSB0aGlu
Z3MgbG9va3MgcmF0aGVyIG9kZCB0byBtZS4NCg0KVGhpcyBjb2RlIGlzIGRlcml2ZWQgZnJvbSBv
dXIgb2xkIE1NVSBub3RpZmllciBjb2RlLiBCZWZvcmUgSE1NIHdlIHVzZWQgDQp0byByZWdpc3Rl
ciBhIHNpbmdsZSBNTVUgbm90aWZpZXIgcGVyIG1tX3N0cnVjdCBhbmQgbG9vayB1cCB2aXJ0dWFs
IA0KYWRkcmVzcyByYW5nZXMgdGhhdCBoYWQgYmVlbiByZWdpc3RlcmVkIGZvciBtaXJyb3Jpbmcg
dmlhIGRyaXZlciBBUEkgDQpjYWxscy4gVGhlIGlkZWEgd2FzIHRvIHJldXNlIGEgc2luZ2xlIE1N
VSBub3RpZmllciBmb3IgdGhlIGxpZmUgdGltZSBvZiANCnRoZSBwcm9jZXNzLiBJdCB3b3VsZCBy
ZW1haW4gcmVnaXN0ZXJlZCB1bnRpbCB3ZSBnb3QgYSBub3RpZmllcl9yZWxlYXNlLg0KDQpobW1f
bWlycm9yIHRvb2sgdGhlIHBsYWNlIG9mIHRoYXQgd2hlbiB3ZSBjb252ZXJ0ZWQgdGhlIGNvZGUg
dG8gSE1NLg0KDQpJIHN1cHBvc2Ugd2UgY291bGQgZGVzdHJveSB0aGUgbWlycm9yIGVhcmxpZXIs
IHdoZW4gd2UgaGF2ZSBubyBtb3JlIA0KcmVnaXN0ZXJlZCB2aXJ0dWFsIGFkZHJlc3MgcmFuZ2Vz
LCBhbmQgY3JlYXRlIGEgbmV3IG9uZSBpZiBuZWVkZWQgbGF0ZXIuDQoNClJlZ2FyZHMsDQogwqAg
RmVsaXgNCg0KDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
XwphbWQtZ2Z4IG1haWxpbmcgbGlzdAphbWQtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRw
czovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2FtZC1nZng=
