From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 07/10] nvme-pci: Use PCI p2pmem subsystem to manage the
 CMB
Date: Mon, 5 Mar 2018 13:13:20 -0700
Message-ID: <e3ca6482-d68c-0e10-dde9-7ccb702d3ac2@deltatee.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-8-logang@deltatee.com>
 <CAOSf1CEj1vmLLd27-642=XSnL9ODkpEC0qLHA2_W5_7rV5+4Pg@mail.gmail.com>
 <20180305160004.GA30975@localhost.localdomain>
 <36c78987-006a-a97f-1d18-b0a08cbea9d4@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <36c78987-006a-a97f-1d18-b0a08cbea9d4-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
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
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver <oohall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

CgpPbiAwNS8wMy8xOCAxMjo1NyBQTSwgU2FnaSBHcmltYmVyZyB3cm90ZToKPiBLZWl0aCwgd2hp
bGUgd2UncmUgb24gdGhpcywgcmVnYXJkbGVzcyBvZiBjbWIsIGlzIFNRRSBtZW1jb3B5IGFuZCBE
QiAKPiB1cGRhdGUgb3JkZXJpbmcgYWx3YXlzIGd1YXJhbnRlZWQ/Cj4gCj4gSWYgeW91IGxvb2sg
YXQgbWx4NCAocmRtYSBkZXZpY2UgZHJpdmVyKSB0aGF0IHdvcmtzIGV4YWN0bHkgdGhlIHNhbWUg
YXMKPiBudm1lIHlvdSB3aWxsIGZpbmQ6Cj4gLS0gCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBxcC0+c3EuaGVhZCArPSBucmVxOwo+IAo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgLyoKPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBNYWtlIHN1
cmUgdGhhdCBkZXNjcmlwdG9ycyBhcmUgd3JpdHRlbiBiZWZvcmUKPiAgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgKiBkb29yYmVsbCByZWNvcmQuCj4gIMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgICovCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB3bWIo
KTsKPiAKPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHdyaXRlbChxcC0+ZG9vcmJl
bGxfcXBuLAo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0
b19tZGV2KGlicXAtPmRldmljZSktPnVhcl9tYXAgKyAKPiBNTFg0X1NFTkRfRE9PUkJFTEwpOwo+
IAo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLyoKPiAgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgKiBNYWtlIHN1cmUgZG9vcmJlbGxzIGRvbid0IGxlYWsgb3V0IG9m
IFNRIHNwaW5sb2NrCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogYW5kIHJl
YWNoIHRoZSBIQ0Egb3V0IG9mIG9yZGVyLgo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAqLwo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbW1pb3diKCk7Cj4gLS0g
CgpUbyBtZSwgaXQgbG9va3MgbGlrZSB0aGUgd21iKCkgaXMgcmVkdW5kYW50IGFzIHdyaXRlbCBz
aG91bGQgZ3VhcmFudGVlIAp0aGUgb3JkZXIuIChJbmRlZWQsIHBlciBTaW5hbidzIGNvbW1lbnQs
IHdyaXRlbCBvbiBhcm02NCBzdGFydHMgd2l0aCBhIAp3bWIoKSB3aGljaCBtZWFucywgb24gdGhh
dCBwbGF0Zm9ybSwgdGhlcmUgYXJlIHR3byB3bWIoKSBjYWxscyBpbiBhIHJvdy4pCgpUaGUgbW1p
b3diKCkgY2FsbCwgb24gdGhlIG90aGVyIGhhbmQsIGxvb2tzIGNvcnJlY3QgcGVyIG15IHVuZGVy
c3RhbmRpbmcgCm9mIGl0J3MgcHVycG9zZSB3aXRoIHJlc3BlY3QgdG8gdGhlIHNwaW5sb2NrLgoK
TG9nYW4KCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpM
aW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6
Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
