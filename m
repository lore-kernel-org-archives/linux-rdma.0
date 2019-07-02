From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC] mm/hmm: pass mmu_notifier_range to
 sync_cpu_device_pagetables
Date: Tue, 2 Jul 2019 22:59:16 +0000
Message-ID: <20190702225911.GA11833@mellanox.com>
References: <20190608001452.7922-1-rcampbell@nvidia.com>
 <20190702195317.GT31718@mellanox.com> <20190702224912.GA24043@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190702224912.GA24043-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Content-ID: <C21602A5B8952E41ACC1E76FEF5C90F2-wNKe6lTLrGecE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Felix.Kuehling-5C7GfCeVMHo@public.gmane.org" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCBKdWwgMDMsIDIwMTkgYXQgMTI6NDk6MTJBTSArMDIwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gT24gVHVlLCBKdWwgMDIsIDIwMTkgYXQgMDc6NTM6MjNQTSArMDAwMCwgSmFz
b24gR3VudGhvcnBlIHdyb3RlOgo+ID4gPiBJJ20gc2VuZGluZyB0aGlzIG91dCBub3cgc2luY2Ug
d2UgYXJlIHVwZGF0aW5nIG1hbnkgb2YgdGhlIEhNTSBBUElzCj4gPiA+IGFuZCBJIHRoaW5rIGl0
IHdpbGwgYmUgdXNlZnVsLgo+ID4gCj4gPiBUaGlzIG1ha2Ugc28gbXVjaCBzZW5zZSwgSSdkIGxp
a2UgdG8gYXBwbHkgdGhpcyBpbiBobW0uZ2l0LCBpcyB0aGVyZQo+ID4gYW55IG9iamVjdGlvbj8K
PiAKPiBBcyB0aGlzIGNyZWF0ZXMgYSBzb21ld2hhdCBoYWlyeSBjb25mbGljdCBmb3IgYW1kZ3B1
LCB3b3VsZG4ndCBpdCBiZQo+IGEgYmV0dGVyIGlkZWEgdG8gd2FpdCBhIGJpdCBhbmQgYXBwbHkg
aXQgZmlyc3QgdGhpbmcgZm9yIG5leHQgbWVyZ2UKPiB3aW5kb3c/CgpNeSB0aGlua2luZyBpcyB0
aGF0IEFNRCBHUFUgYWxyZWFkeSBoYXMgYSBtb25zdGVyIGNvbmZsaWN0IGZyb20gdGhpczoKCiBp
bnQgaG1tX3JhbmdlX3JlZ2lzdGVyKHN0cnVjdCBobW1fcmFuZ2UgKnJhbmdlLAotICAgICAgICAg
ICAgICAgICAgICAgIHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLAorICAgICAgICAgICAgICAgICAgICAg
IHN0cnVjdCBobW1fbWlycm9yICptaXJyb3IsCiAgICAgICAgICAgICAgICAgICAgICAgdW5zaWdu
ZWQgbG9uZyBzdGFydCwKICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBsb25nIGVuZCwK
ICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBwYWdlX3NoaWZ0KTsKClNvLCBkZXBlbmRp
bmcgb24gaG93IHRoYXQgaXMgcmVzb2x2ZWQgd2UgbWlnaHQgd2FudCB0byBkbyBib3RoIEFQSQpj
aGFuZ2VzIGF0IG9uY2UuCgpPciB3ZSBtYXkgaGF2ZSB0byByZXZlcnQgdGhlIGFib3ZlIGNoYW5n
ZSBhdCB0aGlzIGxhdGUgZGF0ZS4KCldhaXRpbmcgZm9yIEFNREdQVSB0ZWFtIHRvIGRpc2N1c3Mg
d2hhdCBwcm9jZXNzIHRoZXkgd2FudCB0byB1c2UuCgpKYXNvbgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwphbWQtZ2Z4IG1haWxpbmcgbGlzdAphbWQtZ2Z4
QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWls
bWFuL2xpc3RpbmZvL2FtZC1nZng=
