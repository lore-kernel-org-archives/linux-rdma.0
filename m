From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH RFC] RDMA/core: add rdma_get_dma_mr()
Date: Thu, 25 Jun 2015 22:37:17 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FF9ECA@ORSMSX109.amr.corp.intel.com>
References: <20150625212917.14869.66238.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150625212917.14869.66238.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiArZW51bSByZG1hX21yX3JvbGVzIHsNCg0KSSB3b3VsZCBkcm9wIG5hbWluZyB0aGUgZW51bSAt
IGl0IHNob3VsZG4ndCBiZSB1c2VkLCBhcyB0aGUgdmFsdWVzIGFyZSBiaXQgZmxhZ3MuDQoNCj4g
KwlSRE1BX01SUl9SRUNWCQkJPSAxLA0KPiArCVJETUFfTVJSX1NFTkQJCQk9ICgxPDwxKSwNCj4g
KwlSRE1BX01SUl9SRUFEX1NPVVJDRQkJPSAoMTw8MiksDQo+ICsJUkRNQV9NUlJfUkVBRF9TSU5L
CQk9ICgxPDwzKSwNCj4gKwlSRE1BX01SUl9XUklURV9TT1VSQ0UJCT0gKDE8PDQpLA0KPiArCVJE
TUFfTVJSX1dSSVRFX1NJTksJCT0gKDE8PDUpLA0KPiArCVJETUFfTVJSX0FUT01JQwkJCT0gKDE8
PDYpLA0KPiArCVJETUFfTVJSX01XX0JJTkQJCT0gKDE8PDcpLA0KPiArCVJETUFfTVJSX1pFUk9f
QkFTRUQJCT0gKDE8PDgpLA0KDQpUaGVyZSdzICdzb21ldGhpbmcnIGRpZmZlcmVudCBhYm91dCB0
aGlzIHJvbGUgdGhhdCBjYXVzZSBtZSBoZXNpdGF0aW9uLiAgTWF5YmUgdGhhdCBpdCdzIGRlcGVu
ZGVudCBvbiBvdGhlciByb2xlcyBiZWluZyBzZXQgdG8gYmUgdXNlZnVsPyAgSSdtIG5vdCBzdXJl
Lg0KDQpNYXliZSB3ZSBuZWVkIGJvdGggcm9sZXMgYW5kIHJlZ2lzdHJhdGlvbiBmbGFncywgd2l0
aCB0aGlzIGRlY2xhcmVkIGFzIGEgZmxhZz8NCg0KPiArCVJETUFfTVJSX0FDQ0VTU19PTl9ERU1B
TkQJPSAoMTw8OSksDQoNClRoaXMgb25lIGlzIGV2ZW4gbW9yZSBkaWZmZXJlbnQsIGFzIGl0IGRv
ZXNuJ3QgaW1wYWN0IGhvdyB0aGUgTVIgaW50ZXJhY3RzIHdpdGggdGhlIGludGVyZmFjZXMsIG9y
IGNoYW5nZSBob3cgdGhlIGFwcGxpY2F0aW9uIHVzZXMgdGhlIE1SLiAgVGhpcyBpcyByZWFsbHkg
YSBoaW50IHRvIHRoZSBwcm92aWRlciByZWdhcmRpbmcgdGhlIHNlbGVjdGlvbiBvZiBkaWZmZXJl
bnQgaW1wbGVtZW50YXRpb24gZmxvd3MuDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
