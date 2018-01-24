From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v2] RDMA: Use standard way to check return value
Date: Wed, 24 Jan 2018 15:06:02 +0000
Message-ID: <1516806357.3324.1.camel@wdc.com>
References: <20180124124301.10884-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180124124301.10884-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <A85650BEB741514DAF109AF80BD86CE9-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "hare-IBi9RG/b67k@public.gmane.org" <hare-IBi9RG/b67k@public.gmane.org>, "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gV2VkLCAyMDE4LTAxLTI0IGF0IDE0OjQzICswMjAwLCBZdXZhbCBTaGFpYSB3cm90ZToNCj4g
VG8gYmUgY29tcGF0aWJsZSB3aXRoIG90aGVyIG1vZHVsZXMvZHJpdmVycywgY2hhbmdlIHJldHVy
biBjb2RlIGNoZWNrcw0KPiBmcm9tICJpZiAocmMgIT0gMCkiIHRvICJpZiAocmMpIi4NCg0KU29y
cnkgYnV0IEkgdGhpbmsgdGhpcyBpcyBhIGNvbXBsZXRlbHkgcG9pbnRsZXNzIGNoYW5nZS4gQWxs
IHRoZSBjb2RlIHRoYXQgaXMNCnRvdWNoZWQgYnkgdGhpcyBwYXRjaCB3b3JrcyBmaW5lLCBjb25m
b3JtcyB0byBhbGwgYXBwcm9wcmlhdGUgY29kaW5nIHN0eWxlDQpndWlkZXMgYW5kIGlzIGVhc3kg
dG8gcmVhZC4gU28gd2h5IGNoYW5nZSBpdD8NCg0KQmFydC4=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
