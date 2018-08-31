From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v5 13/13] nvmet: Optionally use PCI P2P memory
Date: Thu, 30 Aug 2018 17:25:09 -0700
Message-ID: <ecbb669a-2e84-1333-7e0d-1560cf014750@grimberg.me>
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-14-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180830185352.3369-14-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
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
Cc: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Cj4gKy8qCj4gKyAqIElmIGFsbG93X3AycG1lbSBpcyBzZXQsIHdlIHdpbGwgdHJ5IHRvIHVzZSBQ
MlAgbWVtb3J5IGZvciB0aGUgU0dMIGxpc3RzIGZvcgo+ICsgKiDOmS9PIGNvbW1hbmRzLiBUaGlz
IHJlcXVpcmVzIHRoZSBQQ0kgcDJwIGRldmljZSB0byBiZSBjb21wYXRpYmxlIHdpdGggdGhlCj4g
KyAqIGJhY2tpbmcgZGV2aWNlIGZvciBldmVyeSBuYW1lc3BhY2Ugb24gdGhpcyBjb250cm9sbGVy
Lgo+ICsgKi8KPiArc3RhdGljIHZvaWQgbnZtZXRfc2V0dXBfcDJwbWVtKHN0cnVjdCBudm1ldF9j
dHJsICpjdHJsLCBzdHJ1Y3QgbnZtZXRfcmVxICpyZXEpCj4gK3sKPiArCXN0cnVjdCBudm1ldF9u
cyAqbnM7Cj4gKwlpbnQgcmV0Owo+ICsKPiArCWlmICghcmVxLT5wb3J0LT51c2VfcDJwbWVtIHx8
ICFyZXEtPnAycF9jbGllbnQpCj4gKwkJcmV0dXJuOwo+ICsKPiArCW11dGV4X2xvY2soJmN0cmwt
PnN1YnN5cy0+bG9jayk7Cj4gKwo+ICsJcmV0ID0gcGNpX3AycGRtYV9hZGRfY2xpZW50KCZjdHJs
LT5wMnBfY2xpZW50cywgcmVxLT5wMnBfY2xpZW50KTsKPiArCWlmIChyZXQpIHsKPiArCQlwcl9l
cnIoImZhaWxlZCBhZGRpbmcgcGVlci10by1wZWVyIERNQSBjbGllbnQgJXM6ICVkXG4iLAo+ICsJ
CSAgICAgICBkZXZfbmFtZShyZXEtPnAycF9jbGllbnQpLCByZXQpOwo+ICsJCWdvdG8gZnJlZV9k
ZXZpY2VzOwo+ICsJfQo+ICsKPiArCWxpc3RfZm9yX2VhY2hfZW50cnlfcmN1KG5zLCAmY3RybC0+
c3Vic3lzLT5uYW1lc3BhY2VzLCBkZXZfbGluaykgewo+ICsJCXJldCA9IG52bWV0X3AycGRtYV9h
ZGRfY2xpZW50KGN0cmwsIG5zKTsKPiArCQlpZiAocmV0KQo+ICsJCQlnb3RvIGZyZWVfZGV2aWNl
czsKPiArCX0KPiArCj4gKwlpZiAocmVxLT5wb3J0LT5wMnBfZGV2KSB7Cj4gKwkJaWYgKCFwY2lf
cDJwZG1hX2Fzc2lnbl9wcm92aWRlcihyZXEtPnBvcnQtPnAycF9kZXYsCj4gKwkJCQkJCSZjdHJs
LT5wMnBfY2xpZW50cykpIHsKPiArCQkJcHJfaW5mbygicGVlci10by1wZWVyIG1lbW9yeSBvbiAl
cyBpcyBub3Qgc3VwcG9ydGVkXG4iLAo+ICsJCQkJcGNpX25hbWUocmVxLT5wb3J0LT5wMnBfZGV2
KSk7Cj4gKwkJCWdvdG8gZnJlZV9kZXZpY2VzOwo+ICsJCX0KPiArCQljdHJsLT5wMnBfZGV2ID0g
cGNpX2Rldl9nZXQocmVxLT5wb3J0LT5wMnBfZGV2KTsKPiArCX0gZWxzZSB7CgpXaGVuIGlzIHBv
cnQtPnAycF9kZXYgPT0gTlVMTD8gYSBsaXR0bGUgbW9yZSBkb2N1bWVudGF0aW9uIHdvdWxkIGhl
bHAgCmhlcmUuLi4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0
dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
