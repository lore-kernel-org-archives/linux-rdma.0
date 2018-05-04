From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v4 00/14] Copy Offload in NVMe Fabrics with P2P PCI Memory
Date: Fri, 4 May 2018 09:52:26 -0600
Message-ID: <aa542739-17c1-870d-bac8-1d53eb32ff70@deltatee.com>
References: <20180423233046.21476-1-logang@deltatee.com>
 <b8acf835-df94-9967-2327-8f0e39d88511@amd.com>
 <805645c1-ea40-2e57-88eb-5dd34e579b2e@deltatee.com>
 <3e4e0126-f444-8d88-6793-b5eb97c61f76@amd.com>
 <ce2e5351-f32a-bd80-1c77-b7fc38842175@deltatee.com>
 <38d866cf-f7b4-7118-d737-5a5dcd9f3784@amd.com>
 <2d59aa02-f2fa-bd88-1b6c-923117a6ad28@deltatee.com>
 <17e7bc28-f499-c7f7-f91a-9f6778de5fd3@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <17e7bc28-f499-c7f7-f91a-9f6778de5fd3-5C7GfCeVMHo@public.gmane.org>
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
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

CgpPbiAwNC8wNS8xOCAwODoyNyBBTSwgQ2hyaXN0aWFuIEvDtm5pZyB3cm90ZToKPiBBcmUgeW91
IHN1cmUgdGhhdCB0aGlzIGlzIG1vcmUgY29udmVuaWVudD8gQXQgbGVhc3Qgb24gZmlyc3QgZ2xh
bmNlIGl0IAo+IGZlZWxzIG92ZXJseSBjb21wbGljYXRlZC4KPiAKPiBJIG1lYW4gd2hhdCdzIHRo
ZSBkaWZmZXJlbmNlIGJldHdlZW4gdGhlIHR3byBhcHByb2FjaGVzPwo+IAo+ICDCoMKgwqAgc3Vt
ID0gcGNpX3AycGRtYV9kaXN0YW5jZSh0YXJnZXQsIFtBLCBCLCBDLCB0YXJnZXRdKTsKPiAKPiBh
bmQKPiAKPiAgwqDCoMKgIHN1bSA9IHBjaV9wMnBkbWFfZGlzdGFuY2UodGFyZ2V0LCBBKTsKPiAg
wqDCoMKgIHN1bSArPSBwY2lfcDJwZG1hX2Rpc3RhbmNlKHRhcmdldCwgQik7Cj4gIMKgwqDCoCBz
dW0gKz0gcGNpX3AycGRtYV9kaXN0YW5jZSh0YXJnZXQsIEMpOwoKV2VsbCwgaXQncyBtb3JlIGZv
ciBjb25zaXN0ZW5jeSB3aXRoIHRoZSBwY2lfcDJwZG1hX2ZpbmQoKSB3aGljaCBoYXMgdG8KdGFr
ZSBhIGxpc3Qgb2YgZGV2aWNlcyB0byBmaW5kIGEgcmVzb3VyY2Ugd2hpY2ggbWF0Y2hlcyBhbGwg
b2YgdGhlbS4KKFlvdSBjYW4ndCB1c2UgbXVsdGlwbGUgY2FsbHMgaW4gdGhhdCBjYXNlIGJlY2F1
c2UgYWxsIHRoZSBkZXZpY2VzIGluCnRoZSBsaXN0IG1pZ2h0IG5vdCBoYXZlIHRoZSBzYW1lIHNl
dCBvZiBjb21wYXRpYmxlIHByb3ZpZGVycy4pIFRoYXQgd2F5CndlIGNhbiB1c2UgdGhlIHNhbWUg
bGlzdCB0byBjaGVjayB0aGUgZGlzdGFuY2UgKHdoZW4gdGhlIHVzZXIgc3BlY2lmaWVzCmEgZGV2
aWNlKSBhcyB3ZSBkbyB0byBmaW5kIGEgY29tcGF0aWJsZSBkZXZpY2UgKHdoZW4gdGhlIHVzZXIg
d2FudHMgdG8KYXV0b21hdGljYWxseSBmaW5kIG9uZS4KCkxvZ2FuCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QK
TGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xp
c3RpbmZvL2xpbnV4LW52ZGltbQo=
