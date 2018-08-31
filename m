From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v5 01/13] PCI/P2PDMA: Support peer-to-peer memory
Date: Fri, 31 Aug 2018 09:48:40 -0600
Message-ID: <439181bb-6cd6-0ab2-bca6-fc820845166e@deltatee.com>
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-2-logang@deltatee.com>
 <2711b3a7-f582-0dda-8ac2-530be7bda1bb@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <2711b3a7-f582-0dda-8ac2-530be7bda1bb-5C7GfCeVMHo@public.gmane.org>
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
Cc: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

CgpPbiAzMS8wOC8xOCAwMjowNCBBTSwgQ2hyaXN0aWFuIEvDtm5pZyB3cm90ZToKPiBBbSAzMC4w
OC4yMDE4IHVtIDIwOjUzIHNjaHJpZWIgTG9nYW4gR3VudGhvcnBlOgo+PiBTb21lIFBDSSBkZXZp
Y2VzIG1heSBoYXZlIG1lbW9yeSBtYXBwZWQgaW4gYSBCQVIgc3BhY2UgdGhhdCdzCj4+IGludGVu
ZGVkIGZvciB1c2UgaW4gcGVlci10by1wZWVyIHRyYW5zYWN0aW9ucy4gSW4gb3JkZXIgdG8gZW5h
YmxlCj4+IHN1Y2ggdHJhbnNhY3Rpb25zIHRoZSBtZW1vcnkgbXVzdCBiZSByZWdpc3RlcmVkIHdp
dGggWk9ORV9ERVZJQ0UgcGFnZXMKPj4gc28gaXQgY2FuIGJlIHVzZWQgYnkgRE1BIGludGVyZmFj
ZXMgaW4gZXhpc3RpbmcgZHJpdmVycy4KPiAKPiBXZSB3YW50IHRvIHVzZSB0aGF0IGZlYXR1cmUg
d2l0aG91dCBaT05FX0RFVklDRSBwYWdlcyBmb3IgRE1BLWJ1ZiBhcyB3ZWxsLgo+IAo+IEhvdyBo
YXJkIHdvdWxkIGl0IGJlIHRvIHNlcGFyYXRlIGVuYWJsaW5nIFAyUCBkZXRlY3Rpb24gKGUuZy4g
ZGlzdGFuY2UgCj4gYmV0d2VlbiB0d28gZGV2aWNlcykgZnJvbSB0aGlzPwoKUHJldHR5IGVhc3ku
IFAyUCBkZXRlY3Rpb24gaXMgcHJldHR5IG11Y2gganVzdCBwY2lfcDJwZG1hX2Rpc3RhbmNlKCkg
LAp3aGljaCBoYXMgbm90aGluZyB0byBkbyB3aXRoIHRoZSBaT05FX0RFVklDRSBzdXBwb3J0LgoK
KEFuZCB0aGUgZGlzdGFuY2UgZnVuY3Rpb24gbWFrZXMgdXNlIG9mIGEgbnVtYmVyIG9mIHN0YXRp
YyBmdW5jdGlvbnMKd2hpY2ggY291bGQgYmUgY29tYmluZWQgaW50byBhIHNpbXBsZXIgaW50ZXJm
YWNlLCBzaG91bGQgd2UgbmVlZCBpdC4pCgpMb2dhbgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52
ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9s
aW51eC1udmRpbW0K
