From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] libibverbs init.c: conditionally emit warning if no
 userspace driver found
Date: Mon, 6 Jul 2015 13:35:50 +0000
Message-ID: <F9B48EF8-8760-45A0-8322-CE4FC859D5B6@cisco.com>
References: <1431440068-19037-1-git-send-email-jsquyres@cisco.com>
 <BED0001D-0051-4ACD-8506-8FA07E625694@cisco.com>
 <1432044878.5304.1.camel@opteya.com> <1432049804.3114.41.camel@redhat.com>
 <1432133301.5304.10.camel@opteya.com> <1432139226.3114.83.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FDD9BC@ORSMSX109.amr.corp.intel.com>
 <1432141870.3114.89.camel@redhat.com>
 <B397943B-9919-47CC-94E9-98A2A0BEFE8F@cisco.com>
 <1432305861.28905.83.camel@redhat.com>
 <22F52D8B-92CB-47B2-8A9A-DD20B36C3305@cisco.com>
 <1433350209.40123.55.camel@redhat.com>
 <0FB46382-3793-4056-BB40-8FFBA67ACF85@cisco.com>
 <CA0ED4EA-C64E-47F2-9B6B-5B995BECA77D@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA0ED4EA-C64E-47F2-9B6B-5B995BECA77D-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <ABB2A94D55B77D479F1772F02F1C5EAE-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gSnVuIDE3LCAyMDE1LCBhdCAxMDoyNSBBTSwgRG91ZyBMZWRmb3JkIDxkbGVkZm9yZEByZWRo
YXQuY29tPiB3cm90ZToNCj4gDQo+IFRoZSBwYXRjaCBpcyBhY2NlcHRlZCwgSSBqdXN0IGhhdmVu
4oCZdCBwdXNoZWQgaXQgb3V0IHlldC4NCg0KSXMgdGhlcmUgYSB0aW1lbGluZSBmb3Igd2hlbiB0
aGlzIHBhdGNoIHdpbGwgYmUgYXZhaWxhYmxlIGluIHRoZSB1cHN0cmVhbSBnaXQgcmVwbyBhbmQg
cmVsZWFzZWQgaW4gYSBuZXcgdmVyc2lvbiBvZiBsaWJpYnZlcmJzPw0KDQpJIGFzayBiZWNhdXNl
IHdlJ2QgbGlrZSB0byBzZWUgdGhpcyBwYXRjaCBnZXQgaW50byB1cHN0cmVhbSBkaXN0cm8gbGli
aWJ2ZXJicyByZWxlYXNlcy4gIE9uY2UgdGhhdCBoYXBwZW5zLCB3ZSBjYW4gc3RhcnQgcGxhbm5p
bmcgdGhlIGVuZCBvZiB0aGUgaG9ycmlibGUgaGFja2Fyb3VuZHMgd2UgaGFkIHRvIHB1dCBpbnRv
IHBsYWNlIChlLmcuLCBpbiBPcGVuIE1QSSkgdG8gc3VwcHJlc3MgdGhlIG1pc2xlYWRpbmcgbGli
aWJ2ZXJicyBvdXRwdXQuDQoNClRoYW5rcyENCg0KLS0gDQpKZWZmIFNxdXlyZXMNCmpzcXV5cmVz
QGNpc2NvLmNvbQ0KRm9yIGNvcnBvcmF0ZSBsZWdhbCBpbmZvcm1hdGlvbiBnbyB0bzogaHR0cDov
L3d3dy5jaXNjby5jb20vd2ViL2Fib3V0L2RvaW5nX2J1c2luZXNzL2xlZ2FsL2NyaS8NCg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
