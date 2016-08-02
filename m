From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 7/7] NVMe: CMB on DMA-BUF
Date: Tue, 2 Aug 2016 07:10:14 +0000
Message-ID: <1470121814.20129.8.camel@mellanox.com>
References: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
	 <1470034653-9097-8-git-send-email-haggaie@mellanox.com>
	 <20160801155206.GA23224@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160801155206.GA23224-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Content-ID: <EBADE578C319D54C9954ABD8EA0AFCE5-wNKe6lTLrGecE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kovalyov Artemy <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "stephen.bates-dzo6w/eZyo2tG0bUXCXiUA@public.gmane.org" <stephen.bates-dzo6w/eZyo2tG0bUXCXiUA@public.gmane.org>, "j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24g15EnLCAyMDE2LTA4LTAxIGF0IDA4OjUyIC0wNzAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gT24gTW9uLCBBdWcgMDEsIDIwMTYgYXQgMDk6NTc6MzNBTSArMDMwMCwgSGFnZ2FpIEVy
YW4gd3JvdGU6DQo+ID4gDQo+ID4gQWxsb2NhdGUgYSBDTUIgcmVnaW9uIHRvIHVzZXItc3BhY2Ug
YXMgYSBETUEtQlVGIG9iamVjdC4NCj4gTkFDSy7CoMKgQWJzb2x1dGVseSBubyB3YXkgd2UncmUg
Z29pbmcgdG8gZXhwb3J0IGEgbG93LWxldmVsIGRldmljZQ0KPiBzcGVjaWZpYyBmZWF0dXJlIHRv
IHVzZXJzcGFjZSBsaWtlIHRoYXQuwqDCoElmIHlvdSB3YW50IHRvIERNQSB0bw0KPiB0aGUgQ01C
IGRvIGl0IGZyb20gdGhlIGtlcm5lbCwgYW5kIGZvciB0aGF0IHdlJ2xsIG5lZWQgYSBwcm9wZXIN
Cj4gYmxvY2sgZGV2aWNlIGxldmVsIEFQSS4NCg0KVGhlIHJlYXNvbiBJIHRob3VnaHQgdGhpcyBp
ZGVhIG1pZ2h0IHdvcmsgaXMgYmVjYXVzZSBvZiB0aGUgcmVzcG9uc2VzDQpTdGVwaGVuIGdvdCBm
b3IgaGlzIGF0dGVtcHQgdG8gdXNlIFpPTkVfREVWSUNFIGZvciB0aGluZ3MgbGlrZSB0aGUgQ01C
Lg0KVGhlIHByb2JsZW0gd2l0aCB0aGF0IGlzIHRoYXQgdGhlIHdheSBSRE1BIHJlZ2lzdHJhdGlv
biB3b3JrcyB3aXRoDQpnZXRfdXNlcl9wYWdlcyBtZWFucyB0aGF0IHRoZSBDUFUgYWxzbyBnZXRz
IGFjY2VzcyB0byB0aGUgQ01CIGFuZA0Kc29tZXRpbWVzIHlvdSBkb24ndCB3YW50IHRoYXQuIERN
QS1CVUYgY2FuIHNvbHZlIHRoYXQgbmljZWx5IGluIHRoYXQgaXQNCmRvZXNuJ3QgcmVxdWlyZSBt
YXBwaW5nIGl0IHRvIHRoZSBDUFUgLSBhIGRyaXZlciBjYW4gYXR0YWNoIHRvIGl0DQpkaXJlY3Rs
eS4NCg0KQW55d2F5LCBJIHVuZGVyc3RhbmQgZXhwb3NpbmcgdGhlIENNQiBkaXJlY3RseSBtaWdo
dCBiZSBhIGxpdHRsZSB0b28NCmxvdyBsZXZlbC4gV2hhdCBkbyB5b3UgdGhpbmsgd291bGQgd29y
ayBiZXR0ZXI/IFNvbWV0aGluZyBsaWtlDQpkaXJlY3RfYWNjZXNzIHRoYXQgcmV0dXJucyBidXMg
YWRkcmVzc2VzIGluc3RlYWQgb2YgcGZucz8NCg0KVGhhbmtzLA0KSGFnZ2Fp
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
