From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/srp: fix mr allocation when the device supports
 sg gaps
Date: Wed, 28 Dec 2016 10:13:03 +0000
Message-ID: <1482919967.10145.0.camel@sandisk.com>
References: <1482864552-27605-1-git-send-email-maxg@mellanox.com>
         <1482864552-27605-2-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482864552-27605-2-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Content-ID: <75DEEF46B3BA0544A019C13EB708CA98-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gMTIvMjcvMjAxNiAwNzo0OSBQTSwgTWF4IEd1cnRvdm95IHdyb3RlOg0KPiBGcm9tOiBJc3Jh
ZWwgUnVrc2hpbiA8aXNyYWVsckBtZWxsYW5veC5jb20+DQo+wqANCj4gSWYgdGhlIGRldmljZSBz
dXBwb3J0IGFyYml0cmFyeSBzZyBsaXN0IG1hcHBpbmcgKGRldmljZSBjYXANCj4NCklCX0RFVklD
RV9TR19HQVBTX1JFRyBzZXQpIHdlIGFsbG9jYXRlIHRoZSBtZW1vcnkgcmVnaW9ucyB3aXRoDQo+
IElCX01SX1RZUEVfU0dfR0FQUy4NCg0KSSB0aGluayB0aGUgIkZpeGVzOiIgYW5kICJDYzogc3Rh
YmxlIiB0YWdzIGFyZSBtaXNzaW5nIGZyb20gdGhpcw0KcGF0Y2guDQoNCkJhcnQu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
