From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
Date: Thu, 1 Mar 2018 12:33:59 -0700
Message-ID: <112b6d99-8aac-3d45-486e-ebea62fb8670@deltatee.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <90b658d9-da8a-af36-ad8f-a72ef0c6e3c1@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <90b658d9-da8a-af36-ad8f-a72ef0c6e3c1-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
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
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

CgpPbiAwMS8wMy8xOCAwMzozMSBBTSwgU2FnaSBHcmltYmVyZyB3cm90ZToKPj4gKiBXZSBhbHNv
IHJlamVjdCB1c2luZyBkZXZpY2VzIHRoYXQgZW1wbG95ICdkbWFfdmlydF9vcHMnIHdoaWNoIHNo
b3VsZAo+PiDCoMKgIGZhaXJseSBzaW1wbHkgaGFuZGxlIEphc29uJ3MgY29uY2VybnMgdGhhdCB0
aGlzIHdvcmsgbWlnaHQgYnJlYWsgd2l0aAo+PiDCoMKgIHRoZSBIRkksIFFJQiBhbmQgcnhlIGRy
aXZlcnMgdGhhdCB1c2UgdGhlIHZpcnR1YWwgb3BzIHRvIGltcGxlbWVudAo+PiDCoMKgIHRoZWly
IG93biBzcGVjaWFsIERNQSBvcGVyYXRpb25zLgo+IAo+IFRoYXQncyBnb29kLCBidXQgd2hhdCB3
b3VsZCBoYXBwZW4gZm9yIHRoZXNlIGRldmljZXM/IHNpbXBseSBmYWlsIHRoZQo+IG1hcHBpbmcg
Y2F1c2luZyB0aGUgdWxwIHRvIGZhaWwgaXRzIHJkbWEgb3BlcmF0aW9uPyBJIHdvdWxkIHRoaW5r
Cj4gdGhhdCB3ZSBuZWVkIGEgY2FwYWJpbGl0eSBmbGFnIGZvciBkZXZpY2VzIHRoYXQgc3VwcG9y
dCBpdC4KCnBjaV9wMnBtZW1fZmluZCgpIHdpbGwgc2ltcGx5IG5vdCByZXR1cm4gYW55IGRldmlj
ZXMgd2hlbiBhbnkgY2xpZW50IAp0aGF0IHVzZXMgZG1hX3ZpcnRfb3BzLiBTbyBpbiB0aGUgTlZN
ZSB0YXJnZXQgY2FzZSBpdCBzaW1wbHkgd2lsbCBub3QgCnVzZSBQMlAgbWVtb3J5LgoKQW5kIGp1
c3QgaW4gY2FzZSwgcGNpX3AycGRtYV9tYXBfc2coKSB3aWxsIGFsc28gcmV0dXJuIDAgaWYgdGhl
IGRldmljZSAKcGFzc2VkIHRvIGl0IHVzZXMgZG1hX3ZpcnRfb3BzIGFzIHdlbGwuIFNvIGlmIHNv
bWVvbmUgYnlwYXNzZXMgCnBjaV9wMnBtZW1fZmluZCgpIHRoZXkgd2lsbCBnZXQgYSBmYWlsdXJl
IGR1cmluZyBtYXAuCgpMb2dhbgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4w
MS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
