From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v5 06/13] PCI/P2PDMA: Add P2P DMA driver writer's
 documentation
Date: Fri, 31 Aug 2018 09:51:06 -0600
Message-ID: <6820d451-9591-1979-00bf-60c65fc4f136@deltatee.com>
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-7-logang@deltatee.com>
 <98bff500-4e4c-3a34-6762-16ef4b076d90@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <98bff500-4e4c-3a34-6762-16ef4b076d90-5C7GfCeVMHo@public.gmane.org>
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
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

CgpPbiAzMS8wOC8xOCAwMjowOCBBTSwgQ2hyaXN0aWFuIEvDtm5pZyB3cm90ZToKPj4gK09uZSBv
ZiB0aGUgYmlnZ2VzdCBpc3N1ZXMgaXMgdGhhdCBQQ0kgZG9lc24ndCByZXF1aXJlIGZvcndhcmRp
bmcKPj4gK3RyYW5zYWN0aW9ucyBiZXR3ZWVuIGhpZXJhcmNoeSBkb21haW5zLCBhbmQgaW4gUENJ
ZSwgZWFjaCBSb290IFBvcnQKPj4gK2RlZmluZXMgYSBzZXBhcmF0ZSBoaWVyYXJjaHkgZG9tYWlu
LiBUbyBtYWtlIHRoaW5ncyB3b3JzZSwgdGhlcmUgaXMgbm8KPj4gK3NpbXBsZSB3YXkgdG8gZGV0
ZXJtaW5lIGlmIGEgZ2l2ZW4gUm9vdCBDb21wbGV4IHN1cHBvcnRzIHRoaXMgb3Igbm90Lgo+PiAr
KFNlZSBQQ0llIHI0LjAsIHNlYyAxLjMuMSkuIFRoZXJlZm9yZSwgYXMgb2YgdGhpcyB3cml0aW5n
LCB0aGUga2VybmVsCj4+ICtvbmx5IHN1cHBvcnRzIGRvaW5nIFAyUCB3aGVuIHRoZSBlbmRwb2lu
dHMgaW52b2x2ZWQgYXJlIGFsbCBiZWhpbmQgdGhlCj4+ICtzYW1lIFBDSSBicmlkZ2UsIGFzIHN1
Y2ggZGV2aWNlcyBhcmUgYWxsIGluIHRoZSBzYW1lIFBDSSBoaWVyYXJjaHkKPj4gK2RvbWFpbiwg
YW5kIHRoZSBzcGVjIGd1YXJhbnRlZXMgdGhhdCBhbGwgdHJhbnNhY2F0aW9ucyB3aXRoaW4gdGhl
Cj4+ICtoaWVyYXJjaHkgd2lsbCBiZSByb3V0YWJsZSwgYnV0IGl0IGRvZXMgbm90IHJlcXVpcmUg
cm91dGluZwo+PiArYmV0d2VlbiBoaWVyYXJjaGllcy4KPiAKPiBDYW4gd2UgYWRkIGEga2VybmVs
IGNvbW1hbmQgbGluZSBzd2l0Y2ggYW5kIGEgd2hpdGVsaXN0IHRvIGVuYWJsZSBQMlAgCj4gYmV0
d2VlbiBzZXBhcmF0ZSBoaWVyYXJjaGllcz8KCkluIGZ1dHVyZSB3b3JrLCB5ZXMuIEJ1dCBub3Qg
Zm9yIHRoaXMgcGF0Y2hzZXQuIFRoaXMgaXMgZGVmaW5pdGVseSB0aGUKd2F5IEkgc2VlIHRoaW5n
cyBnb2luZywgYnV0IHdlJ3ZlIGNob3NlbiB0byBzdGFydCB3aXRoIHdoYXQgd2UndmUgcHJlc2Vu
dGVkLgoKTG9nYW4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0
dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
