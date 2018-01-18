From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH 1/4] IB/core: add support for draining Shared receive
 queues
Date: Thu, 18 Jan 2018 18:06:09 +0000
Message-ID: <1516298766.2676.29.camel@wdc.com>
References: <1516197178-26493-1-git-send-email-maxg@mellanox.com>
         <1516197178-26493-2-git-send-email-maxg@mellanox.com>
         <02bd01d38fa8$c09a9430$41cfbc90$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <02bd01d38fa8$c09a9430$41cfbc90$@opengridcomputing.com>
Content-Language: en-US
Content-ID: <229E6D439366DB4B966B925E3A4DFF4D-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "danielm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <danielm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCAyMDE4LTAxLTE3IGF0IDA5OjM1IC0wNjAwLCBTdGV2ZSBXaXNlIHdyb3RlOg0KPiA+
ICsJaWYgKHdhaXRfZm9yX2NvbXBsZXRpb25fdGltZW91dCgmcXAtPnNycV9jb21wbGV0aW9uLCAx
MCAqIEhaKSA+IDApDQo+ID4gKwkJaWJfcHJvY2Vzc19jcV9kaXJlY3QoY3EsIC0xKTsNCj4gPiAr
fQ0KPiANCj4gUGVyaGFwcyBhIFdBUk5fT05DRSBpcyB3YXJyYW50ZWQ/IA0KDQpBZ3JlZWQuIEkg
d291bGQgYWxzbyBsaWtlIHRvIHNlZSBhIFdBUk5fT05DRSgpIGlmIHRoZSB0aW1lb3V0IGV4cGly
ZXMgYmVmb3JlDQp0aGUgY29tcGxldGlvbiBoYXMgYmVlbiBzaWduYWxlZC4NCg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
