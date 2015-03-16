From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 14/19] IB/core: Add IB_DEVICE_OPA_MAD_SUPPORT device
 cap flag
Date: Mon, 16 Mar 2015 23:59:36 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399E8106A@ORSMSX109.amr.corp.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>
  <1423092585-26692-15-git-send-email-ira.weiny@intel.com>
  <54D52589.8020305@dev.mellanox.co.il>
  <2807E5FD2F6FDA4886F6618EAC48510E0CC244A8@CRSMSX101.amr.corp.intel.com>
  <54DCB1E9.7010309@dev.mellanox.co.il>
  <2807E5FD2F6FDA4886F6618EAC48510E0CC29020@CRSMSX101.amr.corp.intel.com>
  <54EB7756.7070407@dev.mellanox.co.il>
  <2807E5FD2F6FDA4886F6618EAC48510E0CC3D330@CRSMSX101.amr.corp.intel.com>
 <1424884438.4847.91.camel@redhat.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0CC4F18C@CRSMSX101.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A8237399E6F06F@ORSMSX110.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0CC4F50B@CRSMSX101.amr.corp.intel.com>
 <54FE0F16.5090905@dev.mellanox.co.il>
 <2807E5FD2F6FDA4886F6618EAC48510E0CC5C11A@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0CC5C11A-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiA+IG9yIG1hbmFnZW1lbnQgYXBwbGljYXRpb24uDQo+IA0KPiBBZ3JlZWQsIGJ1dCBfb25seV8g
d2hlbiB0YWxraW5nIHRvIHRoZSBoYXJkd2FyZS4gIE90aGVyIE1BRCBpbnRlcmZhY2VzIGFyZQ0K
PiBJQiBjb21wYXRpYmxlLg0KDQpNYXliZSB0aGlzIGlzIHdoYXQgSXJhIGlzIHRoaW5raW5nLCBh
bmQganVzdCBub3QgZXhwbGFpbmluZyB2ZXJ5IHdlbGwuICBCdXQgaXQgbWFrZXMgc2Vuc2UgdG8g
bWUgdG8gdXNlIG1hbmFnZW1lbnQgc3BlY2lmaWMgZmllbGRzL2F0dHJpYnV0ZXMvZmxhZ3MgZm9y
IHRoZSAqbWFuYWdlbWVudCogcGllY2VzLCByYXRoZXIgdGhhbiB1c2luZyB0aGUgbGluayBhbmQv
b3IgdHJhbnNwb3J0IGxheWVyIHByb3RvY29scyBhcyBhIHByb3h5LiAgTWFuYWdlbWVudCByZWxh
dGVkIGNvZGUgc2hvdWxkIHJlYWxseSBicmFuY2ggYmFzZWQgb24gdGhhdC4NCg0KVGhlIGludHJv
ZHVjdGlvbiBvZiBuZXcgT1BBIGxpbmsgYW5kIHRyYW5zcG9ydCBwcm90b2NvbHMsIGFuZCBmaXhp
bmcgd2hhdCdzIHRoZXJlIGZvciBpV2FycCwgY2FuIHRoZW4gYmUgYWRkcmVzc2VkIHNlcGFyYXRl
bHkuDQoNCkkgZG9uJ3QgaGF2ZSBhbnkgdGhvdWdodHMgZm9yIHdoYXQgdGhlIG1hbmFnZW1lbnQg
c3BlY2lmaWMgZmllbGRzL2F0dHJpYnV0ZS9mbGFncyBzaG91bGQgYmUgLS0gd2hldGhlciBuZXcg
ZmllbGRzIGFyZSBhZGRlZCB0byB0aGUgZGV2aWNlIGF0dHJpYnV0ZXMsIGEgbWFuYWdlbWVudCBm
bGFnIGlzIGRlZmluZWQsIGV0Yy4NCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
