From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 4/6] nvme-rdma: use rdma connection reject helper
 functions
Date: Tue, 25 Oct 2016 18:25:56 +0000
Message-ID: <1477419953.2385.3.camel@sandisk.com>
References: <cover.1477336045.git.swise@opengridcomputing.com>
         <55638a1d2a9f79af8b9a19eb444c5d0a41691352.1477336045.git.swise@opengridcomputing.com>
         <b5d32deb-af6a-3f98-98da-c5f61d400876@sandisk.com>
         <014d01d22eec$832e60e0$898b22a0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <014d01d22eec$832e60e0$898b22a0$@opengridcomputing.com>
Content-Language: en-US
Content-ID: <60E276C3B16B8B4D83DDB934A45F7838-GsdMcTDXqN6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE2LTEwLTI1IGF0IDEzOjIwIC0wNTAwLCBTdGV2ZSBXaXNlIHdyb3RlOg0KPiA+
IA0KPiA+IE9uIDEwLzI0LzIwMTYgMTI6MDkgUE0sIFN0ZXZlIFdpc2Ugd3JvdGU6DQo+ID4gPiAN
Cj4gPiA+ICsJcmVqX21zZyA9IHJkbWFfcmVqZWN0X21zZyhjbV9pZCwgc3RhdHVzKTsNCj4gPiA+
ICsJcmVqX2RhdGEgPSAoc3RydWN0IG52bWVfcmRtYV9jbV9yZWogKikNCj4gPiA+ICsJCcKgwqDC
oHJkbWFfY29uc3VtZXJfcmVqZWN0X2RhdGEoY21faWQsIGV2LA0KPiA+ID4gJnJlal9kYXRhX2xl
bik7DQo+ID4gDQo+ID4gUGxlYXNlIHJlb3JkZXIgdGhlIHBhdGNoZXMgaW4gdGhpcyBwYXRjaCBz
ZXJpZXMgc3VjaCB0aGF0IGl0DQo+ID4gZG9lc24ndA0KPiA+IGJyZWFrIGEgYmlzZWN0LiByZG1h
X2NvbnN1bWVyX3JlamVjdF9kYXRhKCkgc2hvdWxkIGJlIGludHJvZHVjZWQNCj4gPiBiZWZvcmUN
Cj4gPiBpdCBpcyB1c2VkLg0KPiANCj4gcmRtYV9jb25zdW1lcl9yZWplY3RfZGF0YSgpIGlzIGlu
dHJvZHVjZWQgaW4gcGF0Y2ggMy4NCg0KSGVsbG8gU3RldmUsDQoNClRoYW5rcyBmb3IgdGhlIGZl
ZWRiYWNrLiBBcHBhcmVudGx5IG15IGUtbWFpbCBjbGllbnQgZGlzcGxheWVkIHRoZQ0KcGF0Y2hl
cyBpbiB0aGUgd3Jvbmcgb3JkZXIgLi4uDQoNCkJhcnQu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
