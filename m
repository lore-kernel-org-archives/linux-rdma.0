From: zhoucm1 <david1.zhou-5C7GfCeVMHo@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Mon, 28 Nov 2016 13:31:55 +0800
Message-ID: <583BC14B.2040809@amd.com>
References: <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
 <20161125193252.GC16504@obsidianresearch.com>
 <d9e064a0-9c47-3e41-3154-cece8c70a119@mellanox.com>
 <0087fba9-7bcb-8bb3-c26e-4ef3e4970c34@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <0087fba9-7bcb-8bb3-c26e-4ef3e4970c34-5C7GfCeVMHo@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Haggai
 Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Yu, Qiang" <Qiang.Yu-5C7GfCeVMHo@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Kuehling,
 Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, Serguei Sagalovitch <serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Sander,
 Ben" <ben.sander-5C7GfCeVMHo@public.gmane.org>, "Suthikulpanit,
 Suravee" <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Deucher,
 Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Blinzer, Paul" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, "Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

K1FpYW5nLCB3aG8gaXMgd29ya2luZyBvbiBpdC4KCk9uIDIwMTblubQxMeaciDI35pelIDIyOjA3
LCBDaHJpc3RpYW4gS8O2bmlnIHdyb3RlOgo+IEFtIDI3LjExLjIwMTYgdW0gMTU6MDIgc2Nocmll
YiBIYWdnYWkgRXJhbjoKPj4gT24gMTEvMjUvMjAxNiA5OjMyIFBNLCBKYXNvbiBHdW50aG9ycGUg
d3JvdGU6Cj4+PiBPbiBGcmksIE5vdiAyNSwgMjAxNiBhdCAwMjoyMjoxN1BNICswMTAwLCBDaHJp
c3RpYW4gS8O2bmlnIHdyb3RlOgo+Pj4KPj4+Pj4gTGlrZSB5b3Ugc2F5IGJlbG93IHdlIGhhdmUg
dG8gaGFuZGxlIHNob3J0IGxpdmVkIGluIHRoZSB1c3VhbCB3YXksIAo+Pj4+PiBhbmQKPj4+Pj4g
dGhhdCBjb3ZlcnMgYmFzaWNhbGx5IGV2ZXJ5IGRldmljZSBleGNlcHQgSUIgTVJzLCBpbmNsdWRp
bmcgdGhlCj4+Pj4+IGNvbW1hbmQgcXVldWUgb24gYSBOVk1lIGRyaXZlLgo+Pj4+IFdlbGwgYSBw
cm9ibGVtIHdoaWNoIHdhc24ndCBtZW50aW9uZWQgc28gZmFyIGlzIHRoYXQgd2hpbGUgR1BVcyBk
byAKPj4+PiBoYXZlIGEKPj4+PiBwYWdlIHRhYmxlIHRvIG1pcnJvciB0aGUgQ1BVIHBhZ2UgdGFi
bGUsIHRoZXkgdXN1YWxseSBjYW4ndCByZWNvdmVyIAo+Pj4+IGZyb20KPj4+PiBwYWdlIGZhdWx0
cy4KPj4+PiBTbyB3aGF0IHdlIGRvIGlzIG1ha2luZyBzdXJlIHRoYXQgYWxsIG1lbW9yeSBhY2Nl
c3NlZCBieSB0aGUgR1BVIAo+Pj4+IEpvYnMgc3RheXMKPj4+PiBpbiBwbGFjZSB3aGlsZSB0aG9z
ZSBqb2JzIHJ1biAocHJldHR5IG11Y2ggdGhlIHNhbWUgcGlubmluZyB5b3UgZG8gCj4+Pj4gZm9y
IHRoZQo+Pj4+IERNQSkuCj4+PiBZZXMsIGl0IGlzIERNQSwgc28gdGhpcyBpcyBhIHZhbGlkIGFw
cHJvYWNoLgo+Pj4KPj4+IEJ1dCwgeW91IGRvbid0IG5lZWQgcGFnZSBmYXVsdHMgZnJvbSB0aGUg
R1BVIHRvIGRvIHByb3BlciBjb2hlcmVudAo+Pj4gcGFnZSB0YWJsZSBtaXJyb3JpbmcuIEJhc2lj
YWxseSB3aGVuIHRoZSBkcml2ZXIgc3VibWl0cyB0aGUgd29yayB0bwo+Pj4gdGhlIEdQVSBpdCAn
ZmF1bHRzJyB0aGUgcGFnZXMgaW50byB0aGUgQ1BVIGFuZCBtaXJyb3IgdHJhbnNsYXRpb24KPj4+
IHRhYmxlIChpbnN0ZWFkIG9mIHBpbm5pbmcpLgo+Pj4KPj4+IExpa2UgaW4gT0RQLCBNTVUgbm90
aWZpZXJzL0hNTSBhcmUgdXNlZCB0byBtb25pdG9yIGZvciB0cmFuc2xhdGlvbgo+Pj4gY2hhbmdl
cy4gSWYgYSBjaGFuZ2UgY29tZXMgaW4gdGhlIEdQVSBkcml2ZXIgY2hlY2tzIGlmIGFuIGV4ZWN1
dGluZwo+Pj4gY29tbWFuZCBpcyB0b3VjaGluZyB0aG9zZSBwYWdlcyBhbmQgYmxvY2tzIHRoZSBN
TVUgbm90aWZpZXIgdW50aWwgdGhlCj4+PiBjb21tYW5kIGZsdXNoZXMsIHRoZW4gdW5mYXVsdHMg
dGhlIHBhZ2UgKGJsb2NraW5nIGZ1dHVyZSBjb21tYW5kcykgYW5kCj4+PiB1bmJsb2NrcyB0aGUg
bW11IG5vdGlmaWVyLgo+PiBJIHRoaW5rIGJsb2NraW5nIG1tdSBub3RpZmllcnMgYWdhaW5zdCBz
b21ldGhpbmcgdGhhdCBpcyBiYXNpY2FsbHkKPj4gY29udHJvbGxlZCBieSB1c2VyLXNwYWNlIGNh
biBiZSBwcm9ibGVtYXRpYy4gVGhpcyBjYW4gYmxvY2sgdGhpbmdzIGxpa2UKPj4gbWVtb3J5IHJl
Y2xhaW0uIElmIHlvdSBoYXZlIHVzZXItc3BhY2UgYWNjZXNzIHRvIHRoZSBkZXZpY2UncyBxdWV1
ZXMsCj4+IHVzZXItc3BhY2UgY2FuIGJsb2NrIHRoZSBtbXUgbm90aWZpZXIgZm9yZXZlci4KPiBS
ZWFsbHkgZ29vZCBwb2ludC4KPgo+IEkgdGhpbmsgdGhpcyBtZWFucyB0aGUgYmFyZSBtaW5pbXVt
IGlmIHdlIGRvbid0IGhhdmUgcmVjb3ZlcmFibGUgcGFnZSAKPiBmYXVsdHMgaXMgdG8gaGF2ZSBw
cmVlbXB0aW9uIHN1cHBvcnQgbGlrZSBGZWxpeCBkZXNjcmliZWQgaW4gaGlzIAo+IGFuc3dlciBh
cyB3ZWxsLgo+Cj4gR29pbmcgdG8ga2VlcCB0aGF0IGluIG1pbmQsCj4gQ2hyaXN0aWFuLgo+Cj4g
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPiBkcmktZGV2
ZWwgbWFpbGluZyBsaXN0Cj4gZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwo+IGh0dHBz
Oi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0g
bWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5v
cmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
