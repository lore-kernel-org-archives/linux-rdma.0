From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v8 13/13] nvmet: Optionally use PCI P2P memory
Date: Mon, 1 Oct 2018 15:23:25 -0700
Message-ID: <b790b11f-41df-f495-fdd1-d8bd6d6b7dd6@grimberg.me>
References: <20180927165420.5290-1-logang@deltatee.com>
 <20180927165420.5290-14-logang@deltatee.com>
 <5ddeed51-0580-9581-cf12-c75e18b4f7cc@grimberg.me>
 <69cd8aab-b94e-98f5-5397-48bb875e8280@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <69cd8aab-b94e-98f5-5397-48bb875e8280-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Cj4+PiArLyoKPj4+ICsgKiBJZiBhbGxvd19wMnBtZW0gaXMgc2V0LCB3ZSB3aWxsIHRyeSB0byB1
c2UgUDJQIG1lbW9yeSBmb3IgdGhlIFNHTCBsaXN0cyBmb3IKPj4+ICsgKiDOmS9PIGNvbW1hbmRz
LiBUaGlzIHJlcXVpcmVzIHRoZSBQQ0kgcDJwIGRldmljZSB0byBiZSBjb21wYXRpYmxlIHdpdGgg
dGhlCj4+PiArICogYmFja2luZyBkZXZpY2UgZm9yIGV2ZXJ5IG5hbWVzcGFjZSBvbiB0aGlzIGNv
bnRyb2xsZXIuCj4+PiArICovCj4+PiArc3RhdGljIHZvaWQgbnZtZXRfc2V0dXBfcDJwbWVtKHN0
cnVjdCBudm1ldF9jdHJsICpjdHJsLCBzdHJ1Y3QgbnZtZXRfcmVxICpyZXEpCj4+PiArewo+Pj4g
KwlzdHJ1Y3QgbnZtZXRfbnMgKm5zOwo+Pj4gKwlpbnQgcmV0Owo+Pj4gKwo+Pj4gKwlpZiAoIXJl
cS0+cG9ydC0+dXNlX3AycG1lbSB8fCAhcmVxLT5wMnBfY2xpZW50KQo+Pj4gKwkJcmV0dXJuOwo+
Pgo+PiBOaXQsIElNTyB3b3VsZCBiZSBiZXR0ZXIgdG8gY2hlY2sgYXQgdGhlIGNhbGwtc2l0ZSwg
YnV0IG5vdCBhIGhhcmQKPj4gbXVzdC4uLgo+IAo+IEknZCByYXRoZXIga2VlcCB0aGUgbG9naWMg
Zm9yIHdoZXRoZXIgdG8gZW5hYmxlIHAycG1lbSBpbiBpdCdzIG93bgo+IGZ1bmN0aW9uLiBudm1l
X2FsbG9jX2N0cmwoKSBpcyBhbHJlYWR5IHZlcnkgbG9uZyBhbmQgY29tcGxpY2F0ZWQuCgpGYWly
IGVub3VnaC4uCgo+PiBJIHN0aWxsIGRvIG5vdCBmdWxseSB1bmRlcnN0YW5kIHdoeSBwMnBfZGV2
IGhhcyB0byBiZSBjdHJsLXdpZGUgYW5kIG5vdAo+PiBwZXIgbmFtZXNwYWNlLiBTb3JyeSB0byBr
ZWVwIGJyaW5naW5nIHRoaXMgdXAgKGFnYWluKS4gQnV0IGlmIHBlb3BsZSBhcmUKPj4gT0sgd2l0
aCBpdCB0aGVuIEkgZ3Vlc3MgSSBjYW4gc3RvcCBhc2tpbmcgYWJvdXQgdGhpcy4uLgo+IAo+IEJl
Y2F1c2UgeW91IG5ldmVyIGFuc3dlcmVkIG15IHF1ZXN0aW9uIGJhY2sgaW4gTWFyY2hbMV0gKHdo
aWNoIEkgdGhpbmsKPiB5b3UndmUgYW5zd2VyZWQgYmVsb3cpLi4uLgoKSSdtIHNvcnJ5Li4uIEkg
bG9zdCB0cmFja2luZyBvbiB0aGlzLi4uCgo+PiBJIHRoaW5rIHRoYXQgYXQgc29tZSBwb2ludCB3
ZSBzYWlkIHRoYXQgdGhpcyBsb29rcyBsaWtlIGl0IHNob3VsZCBmYWxsCj4+IGJhY2sgdG8gaG9z
dCBtZW1vcnkgZm9yIHRob3NlIG5hbWVzcGFjZXMuLiB3aGVuIHdlIGFsbG9jYXRlIHRoZSBzZ2wg
d2UKPj4gYWxyZWFkeSBhc3NpZ25lZCBhIG5hbWVzcGFjZSB0byB0aGUgcmVxdWVzdCAobnZtZXRf
cmVxX2luaXQpLgo+IAo+IEkgZGlkIG5vdCByZWFsaXplIHRoZSBuYW1lc3BhY2Ugd291bGQgYmUg
YXZhaWxhYmxlIGF0IHRoaXMgdGltZS4gSSBndWVzcwo+IEkgY2FuIGdpdmUgdGhpcyBhIHRyeSwg
YnV0IGl0J3MgZ29pbmcgdG8gYmUgYSBmYWlybHkgYmlnIGNoYW5nZSBmcm9tCj4gd2hhdCdzIHBy
ZXNlbnRlZCBoZXJlLi4uIFRob3VnaCwgSSBhZ3JlZSBpdCdsbCBwcm9iYWJseSBiZSBhbiBpbXBy
b3ZlbWVudC4KClRoYW5rcywgaWYgaXQgdHVybnMgb3V0IHRvIGNyZWF0ZSB0byBtdWNoIG9mIGEg
Y2h1cm4sIHdlIGNvdWxkIGRlZmVyCnRoYXQgdG8gYSBsYXRlciBzdGFnZSwgYnV0IHdlIGNhbiBh
dCBsZWFzdCBkb2N1bWVudCBpdC4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMu
MDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1t
Cg==
