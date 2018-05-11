From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
Date: Fri, 11 May 2018 09:48:27 -0600
Message-ID: <53fa38ce-40dd-6bc1-9b83-c6ccf228b755@deltatee.com>
References: <20180423233046.21476-5-logang@deltatee.com>
 <20180507231306.GG161390@bhelgaas-glaptop.roam.corp.google.com>
 <e58e8d27-42a5-ca69-3b68-c409a2922cd1@amd.com>
 <0b4183ef-e720-204b-9e85-b9eaf7a4136a@deltatee.com>
 <a943a92d-15cd-fb2d-21c3-5e5cfccd9eff@amd.com>
 <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
 <20180508133407.57a46902@w520.home>
 <5fc9b1c1-9208-06cc-0ec5-1f54c2520494@deltatee.com>
 <20180508141331.7cd737cb@w520.home>
 <d70cf286-f7b7-99a5-1042-022506298fed@deltatee.com>
 <20180508205005.GC15608@redhat.com>
 <7FFB9603-DF9F-4441-82E9-46037CB6C0DE@raithlin.com>
 <a1a36f88-fbfb-b5ee-6dcb-5c5bb96132dd@amd.com>
 <4e0d0b96-ab02-2662-adf3-fa956efd294c@deltatee.com>
 <2fc61d29-9eb4-d168-a3e5-955c36e5d821@amd.com>
 <94C8FE12-7FC3-48BD-9DCA-E6A427E71810@raithlin.com>
 <f0101988-cf82-7ffb-2aca-d3b8d2f4b504@deltatee.com>
 <868B49CE-4F0E-4A48-BE78-12149F85F1A4@raithlin.com>
 <8113cba8-62b9-1801-7a77-f82be223b183@deltatee.com>
 <cf2b92c9-7c5b-f19c-b5b1-2f2d435296d1@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <cf2b92c9-7c5b-f19c-b5b1-2f2d435296d1-5C7GfCeVMHo@public.gmane.org>
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
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gNS8xMS8yMDE4IDI6NTIgQU0sIENocmlzdGlhbiBLw7ZuaWcgd3JvdGU6Cj4gVGhpcyBvbmx5
IHdvcmtzIHdoZW4gdGhlIElPVkEgYW5kIHRoZSBQQ0kgYnVzIGFkZHJlc3NlcyBuZXZlciBvdmVy
bGFwLiAKPiBJJ20gbm90IHN1cmUgaG93IHRoZSBJT1ZBIGFsbG9jYXRpb24gd29ya3MgYnV0IEkg
ZG9uJ3QgdGhpbmsgd2UgCj4gZ3VhcmFudGVlIHRoYXQgb24gTGludXguCgpJIGZpbmQgdGhpcyBo
YXJkIHRvIGJlbGlldmUuIFRoZXJlJ3MgYWx3YXlzIHRoZSBwb3NzaWJpbGl0eSB0aGF0IHNvbWUg
CnBhcnQgb2YgdGhlIHN5c3RlbSBkb2Vzbid0IHN1cHBvcnQgQUNTIHNvIGlmIHRoZSBQQ0kgYnVz
IGFkZHJlc3NlcyBhbmQgCklPVkEgb3ZlcmxhcCB0aGVyZSdzIGEgZ29vZCBjaGFuY2UgdGhhdCBQ
MlAgYW5kIEFUUyB3b24ndCB3b3JrIGF0IGFsbCBvbiAKc29tZSBoYXJkd2FyZS4KCgo+IElmIHdl
IHJlYWxseSB3YW50IHRvIGVuYWJsZSBQMlAgd2l0aG91dCBBVFMgYW5kIElPTU1VIGVuYWJsZWQg
SSB0aGluayB3ZSAKPiBzaG91bGQgcHJvYmFibHkgYXBwcm9hY2ggaXQgbGlrZSB0aGlzOgo+IAo+
IGEpIE1ha2UgZG91YmxlIHN1cmUgdGhhdCBJT1ZBIGluIGFuIElPTU1VIGdyb3VwIG5ldmVyIG92
ZXJsYXAgd2l0aCBQQ0kgCj4gQkFScyBpbiB0aGF0IGdyb3VwLgo+IAo+IGIpIEFkZCBjb25maWd1
cmF0aW9uIG9wdGlvbnMgdG8gcHV0IGEgd2hvbGUgUENJIGJyYW5jaCBvZiBkZXZpY2VzIChlLmcu
IAo+IGEgYnJpZGdlKSBpbnRvIGEgc2luZ2xlIElPTU1VIGdyb3VwLgo+IAo+IGMpIEFkZCBhIGNv
bmZpZ3VyYXRpb24gb3B0aW9uIHRvIGRpc2FibGUgdGhlIEFDUyBiaXQgb24gYnJpZGdlcyBpbiB0
aGUgCj4gc2FtZSBJT01NVSBncm91cC4KCkkgdGhpbmsgYSBjb25maWd1cmF0aW9uIG9wdGlvbiB0
byBtYW5hZ2UgSU9NTVUgZ3JvdXBzIGFzIHlvdSBzdWdnZXN0IAp3b3VsZCBiZSBhIHZlcnkgY29t
cGxleCBpbnRlcmZhY2UgYW5kIGRpZmZpY3VsdCB0byBpbXBsZW1lbnQuIEkgcHJlZmVyIAp0aGUg
b3B0aW9uIHRvIGRpc2FibGUgdGhlIEFDUyBiaXQgb24gYm9vdCBhbmQgbGV0IHRoZSBleGlzdGlu
ZyBjb2RlIHB1dCAKdGhlIGRldmljZXMgaW50byB0aGVpciBvd24gSU9NTVUgZ3JvdXAgKGFzIGl0
IHNob3VsZCBhbHJlYWR5IGRvIHRvIApzdXBwb3J0IGhhcmR3YXJlIHRoYXQgZG9lc24ndCBoYXZl
IEFDUyBzdXBwb3J0KS4KCkxvZ2FuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3Rz
LjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGlt
bQo=
