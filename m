From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 6/7] NVMe: Use genalloc to allocate CMB regions
Date: Tue, 2 Aug 2016 06:48:36 +0000
Message-ID: <1470120518.20129.2.camel@mellanox.com>
References: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
	 <1470034653-9097-7-git-send-email-haggaie@mellanox.com>
	 <20160801155348.GB23224@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160801155348.GB23224-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Content-ID: <0822BD5BB9A70B47BA917A7C656E0F75-wNKe6lTLrGecE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kovalyov Artemy <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "stephen.bates-dzo6w/eZyo2tG0bUXCXiUA@public.gmane.org" <stephen.bates-dzo6w/eZyo2tG0bUXCXiUA@public.gmane.org>, "j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "jonathan.derrick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <jonathan.derrick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24g15EnLCAyMDE2LTA4LTAxIGF0IDA4OjUzIC0wNzAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gT24gTW9uLCBBdWcgMDEsIDIwMTYgYXQgMDk6NTc6MzJBTSArMDMwMCwgSGFnZ2FpIEVy
YW4gd3JvdGU6DQo+ID4gDQo+ID4gUmVnaXN0ZXIgdGhlIENNQiBpbiBhIGdlbl9wb29sIGRlZGlj
YXRlZCB0byBtYW5hZ2UgQ01CIHJlZ2lvbnMuIFVzZQ0KPiA+IHRoZQ0KPiA+IHBvb2wgdG8gYWxs
b2NhdGUgdGhlIFNRcyB0byBtYWtlIHN1cmUgdGhleSBhcmUgcmVnaXN0ZXJlZC4NCj4gQW5kIHdo
eSB3b3VsZCB0aGUgTlZNZSBkcml2ZXIgY2FyZSBpZiAidGhleSBhcmUgcmVnaXN0ZXJlZCI/DQpJ
IGp1c3QgbWVhbnQgdGhhdCB0aGV5IGFyZSBhbGxvY2F0ZWQgdGhyb3VnaCBnZW5hbGxvYyBzbyB0
aGF0IGl0DQpkb2Vzbid0IGFsbG9jYXRlIHRoZSBzYW1lIGJ1ZmZlciBhZ2Fpbi4NCg0KPiANCj4g
T25jZSB3ZSBzdGFydCBhbGxvd2luZyBkaXZlcnNlIENNQiB1c2VzICh3aGF0IGhhcHBlbmVkIHRv
IEpvbidzDQo+IHBhdGNoZXMNCj4gYnR3PykgZ2VuYWxsb2MgbWlnaHQgYmUgYSBnb29kIGJhY2tl
bmQgYWxsb2NhdG9yLCBidXQgd2l0aG91dCB0aGF0DQo+IGl0J3MgZW50aXJlbHkgcG9pbnRsZXNz
LsKgwqANCkkgbWlzc2VkIEpvbidzIHBhdGNoZXMuIEknbGwgaGF2ZSBhIGxvb2suIFRoZSBwb2lu
dCBpbiB0aGlzIHBhdGNoIHdhcw0KdG8gYWxsb3cgdGhpcyBkaXZlcnNlIHVzZSBpbiB0aGUgbmV4
dCBwYXRjaC4NCg0KPiBBbHNvIHBsZWFzZSBkb24ndCBpbnRyb2R1Y2UgdXNlbGVzcyBoZWFkZXIN
Cj4gZmlsZXMuDQpGYWlyIGVub3VnaC4NCg0KVGhhbmtzLA0KSGFnZ2Fp
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
