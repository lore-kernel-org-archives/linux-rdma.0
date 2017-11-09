From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v3 0/9] Introduce per-device completion queue pools
Date: Thu, 9 Nov 2017 16:42:52 +0000
Message-ID: <1510245771.2608.6.camel@wdc.com>
References: <20171108095742.25365-1-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171108095742.25365-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Content-ID: <41C5D5FDB312AD4F836206B76EFA8352-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCAyMDE3LTExLTA4IGF0IDExOjU3ICswMjAwLCBTYWdpIEdyaW1iZXJnIHdyb3RlOg0K
PiBUaGlzIGlzIHRoZSB0aGlyZCByZS1pbmNhcm5hdGlvbiBvZiB0aGUgQ1EgcG9vbCBwYXRjaGVz
IHByb3Bvc2VkDQo+IGJ5IENocmlzdG9waCBhbmQgSS4NCg0KSGVsbG8gU2FnaSwNCg0KVGhpcyB3
b3JrIGxvb2tzIGludGVyZXN0aW5nIHRvIG1lIGFuZCBJIHRoaW5rIGl0IGlzIGEgZ29vZCBpZGVh
IHRvIGludHJvZHVjZQ0KYSBDUSBwb29sIGltcGxlbWVudGF0aW9uIGluIHRoZSBSRE1BIGNvcmUu
IEhvd2V2ZXIsIEkgaGF2ZSBhIGNvbmNlcm4gYWJvdXQNCnRoZSBhcHByb2FjaC4gVGhpcyBwYXRj
aCBzZXJpZXMgYXNzb2NpYXRlcyBhIHNpbmdsZSBDUSBwb29sIHdpdGggZWFjaCBSRE1BDQpkZXZp
Y2UuIFdvdWxkbid0IGl0IGJlIGJldHRlciB0byBsZXQgQ1EgcG9vbCB1c2VycyBjaG9zZSB0aGUg
Q1EgcG9vbCBzaXplIGFuZA0KdG8gbGV0IHRoZXNlIHVzZXJzIG1hbmFnZSB0aGUgQ1EgcG9vbCBs
aWZldGltZSBpbnN0ZWFkIG9mIGJpbmRpbmcgdGhlDQpsaWZldGltZSBvZiBhIENRIHBvb2wgdG8g
dGhhdCBvZiBhbiBSRE1BIGRldmljZT8gUkRNQSBkcml2ZXJzIGFyZSBsb2FkZWQNCmR1cmluZyBz
eXN0ZW0gc3RhcnR1cC4gSSB0aGluayBhbGxvY2F0aW9uIG9mIG1lbW9yeSBmb3IgQ1EgcG9vbHMg
c2hvdWxkIGJlDQpkZWZlcnJlZCB1bnRpbCB0aGUgVUxQIHByb3RvY29sIGRyaXZlcihzKSBhcmUg
bG9hZGVkIHRvIGF2b2lkIGFsbG9jYXRpbmcNCm1lbW9yeSBmb3IgQ1FzIHdoaWxlIHRoZXNlIGFy
ZSBub3QgaW4gdXNlLiBBZGRpdGlvbmFsbHksIG9uIG1hbnkgc2V0dXBzIGVhY2gNClJETUEgcG9y
dCBvbmx5IHJ1bnMgYSBzaW5nbGUgVUxQLiBJIHRoaW5rIHRoYXQncyBhbm90aGVyIGFyZ3VtZW50
IHRvIGxldCB0aGUNClVMUCBhbGxvY2F0ZSBDUSBwb29sKHMpIGluc3RlYWQgb2YgaGF2aW5nIG9u
ZSBzdWNoIHBvb2wgcGVyIEhDQS4NCg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
