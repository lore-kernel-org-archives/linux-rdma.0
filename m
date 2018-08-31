From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v5 06/13] PCI/P2PDMA: Add P2P DMA driver writer's
 documentation
Date: Fri, 31 Aug 2018 13:11:48 -0600
Message-ID: <9452ee6c-e989-d178-cd51-f29782ad9b31@deltatee.com>
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-7-logang@deltatee.com>
 <98bff500-4e4c-3a34-6762-16ef4b076d90@amd.com>
 <6820d451-9591-1979-00bf-60c65fc4f136@deltatee.com>
 <30411655-9b90-749e-857f-318dac7cccbf@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <30411655-9b90-749e-857f-318dac7cccbf-5C7GfCeVMHo@public.gmane.org>
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

CgpPbiAzMS8wOC8xOCAxMTozOCBBTSwgQ2hyaXN0aWFuIEvDtm5pZyB3cm90ZToKPiBJZiB5b3Ug
Y2FuIHNlcGFyYXRlIG91dCBhZGRpbmcgdGhlIGRldGVjdGlvbiBJIGNhbiB0YWtlIGEgbG9vayBh
ZGRpbmcgCj4gdGhpcyB3aXRoIG15IERNQS1idWYgUDJQIGVmZm9ydHMuCgpPaCwgbWF5YmUgbXkg
cHJldmlvdXMgZW1haWwgd2Fzbid0IGNsZWFyLCBidXQgSSdkIHNheSB0aGF0IGRldGVjdGlvbiBp
cwphbHJlYWR5IHNlcGFyYXRlIGZyb20gWk9ORV9ERVZJQ0UuIE5vdGhpbmcgcmVhbGx5IG5lZWRz
IHRvIGJlIGNoYW5nZWQuCkkganVzdCB0aGluayB5b3UnbGwgcHJvYmFibHkgd2FudCB0byB3cml0
ZSB5b3UncmUgb3duIGZ1bmN0aW9uIHNpbWlsYXIKdG8gcGNpX3AycGRtYV9kaXN0YW5jZSB0aGF0
IHBlcmhhcHMganVzdCB0YWtlcyB0d28gcGNpX2RldnMgaW5zdGVhZCBvZgp0aGUgbGlzdCBvZiBj
bGllbnRzIGFzIGlzIG5lZWRlZCBieSBudm1lLW9mLWxpa2UgdXNlcnMuCgpUbyBlbmFibGUgYSB3
aGl0ZWxpc3Qgd2UganVzdCBoYXZlIHRvIGhhbmRsZSB0aGUgY2FzZSB3aGVyZQp1cHN0cmVhbV9i
cmlkZ2VfZGlzdGFuY2UoKSByZXR1cm5zIC0xIGFuZCBjaGVjayBpZiB0aGUgZGV2aWNlcyBhcmUg
aW4KdGhlIHNhbWUgcm9vdCBjb21wbGV4IHdpdGggc3VwcG9ydGVkIHJvb3QgcG9ydHMgYmVmb3Jl
IGRlY2lkaW5nIHRoZQp0cmFuc2FjdGlvbiBpcyBub3Qgc3VwcG9ydGVkLgoKTG9nYW4KX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1h
aWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3Jn
L21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
