From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v4 00/14] Copy Offload in NVMe Fabrics with P2P PCI Memory
Date: Wed, 2 May 2018 09:56:09 -0600
Message-ID: <805645c1-ea40-2e57-88eb-5dd34e579b2e@deltatee.com>
References: <20180423233046.21476-1-logang@deltatee.com>
 <b8acf835-df94-9967-2327-8f0e39d88511@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <b8acf835-df94-9967-2327-8f0e39d88511-5C7GfCeVMHo@public.gmane.org>
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

SGkgQ2hyaXN0aWFuLAoKT24gNS8yLzIwMTggNTo1MSBBTSwgQ2hyaXN0aWFuIEvDtm5pZyB3cm90
ZToKPiBpdCB3b3VsZCBiZSByYXRoZXIgbmljZSB0byBoYXZlIGlmIHlvdSBjb3VsZCBzZXBhcmF0
ZSBvdXQgdGhlIGZ1bmN0aW9ucyAKPiB0byBkZXRlY3QgaWYgcGVlcjJwZWVyIGlzIHBvc3NpYmxl
IGJldHdlZW4gdHdvIGRldmljZXMuCgpUaGlzIHdvdWxkIGVzc2VudGlhbGx5IGJlIHBjaV9wMnBk
bWFfZGlzdGFuY2UoKSBpbiB0aGUgZXhpc3RpbmcgCnBhdGNoc2V0LiBJdCByZXR1cm5zIHRoZSBz
dW0gb2YgdGhlIGRpc3RhbmNlIGJldHdlZW4gYSBsaXN0IG9mIGNsaWVudHMgCmFuZCBhIFAyUERN
QSBwcm92aWRlci4gSXQgcmV0dXJucyAtMSBpZiBwZWVyMnBlZXIgaXMgbm90IHBvc3NpYmxlIApi
ZXR3ZWVuIHRoZSBkZXZpY2VzIChwcmVzZW50bHkgdGhpcyBtZWFucyB0aGV5IGFyZSBub3QgYmVo
aW5kIHRoZSBzYW1lIApyb290IHBvcnQpLgoKTG9nYW4KX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1u
dmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8v
bGludXgtbnZkaW1tCg==
