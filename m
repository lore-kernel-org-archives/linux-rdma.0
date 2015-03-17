From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 14/19] IB/core: Add IB_DEVICE_OPA_MAD_SUPPORT device
 cap flag
Date: Tue, 17 Mar 2015 23:36:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399E818C6@ORSMSX109.amr.corp.intel.com>
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
 <1828884A29C6694DAF28B7E6B8A8237399E8106A@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399E8106A-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBCdXQgaXQgbWFrZXMgc2Vuc2UgdG8gbWUgdG8gdXNlIG1hbmFnZW1lbnQgc3BlY2lmaWMNCj4g
ZmllbGRzL2F0dHJpYnV0ZXMvZmxhZ3MgZm9yIHRoZSAqbWFuYWdlbWVudCogcGllY2VzLCByYXRo
ZXIgdGhhbiB1c2luZyB0aGUNCj4gbGluayBhbmQvb3IgdHJhbnNwb3J0IGxheWVyIHByb3RvY29s
cyBhcyBhIHByb3h5LiAgTWFuYWdlbWVudCByZWxhdGVkIGNvZGUNCj4gc2hvdWxkIHJlYWxseSBi
cmFuY2ggYmFzZWQgb24gdGhhdC4NCg0KQXMgYSBwcm9wb3NhbCwgd2UgY291bGQgYWRkIGEgbmV3
IGZpZWxkIHRvIHRoZSBrZXJuZWwgcG9ydCBhdHRyaWJ1dGUgc3RydWN0dXJlLiAgVGhlIGZpZWxk
IHdvdWxkIGJlIGEgYml0bWFzayBvZiBtYW5hZ2VtZW50IGNhcGFiaWxpdGllcy9wcm90b2NvbHM6
DQoNCklCX01HTVRfUFJPVE9fU00gLSBzdXBwb3J0cyBJQiBTTVBzDQpJQl9NR01UX1BST1RPX1NB
IC0gc3VwcG9ydHMgSUIgU0EgTUFEcw0KSUJfTUdNVF9QUk9UT19HUyAtIHN1cHBvcnRzIElCIEdT
SSBNQURzIChlLmcuIENNLCBQTSwgLi4uKQ0KSUJfTUdNVF9QUk9UT19PUEFfU00gLSBzdXBwb3J0
cyBPUEEgU01QcyAob3Igd2hhdGV2ZXIgdGhleSBhcmUgY2FsbGVkKQ0KSUJfTUdNVF9QUk9UT19P
UEFfR1MgLSBzdXBwb3J0cyBPUEEgR1MgTUFEcyAob3Igd2hhdGV2ZXIgaXMgc3VwcG9ydGVkKSAN
Cg0KSWYgdGhlICpHUyBmbGFncyBhcmUgbm90IHN1ZmZpY2llbnQgdG8gZGlzdGluZ3Vpc2ggYmV0
d2VlbiBNQURzIHN1cHBvcnRlZCBvdmVyIElCIGFuZCBSb0NFLCBpdCBjYW4gYmUgZnVydGhlciBk
aXZpZGVkIChpLmUuIENNLCBQTSwgQk0sIERNLCBldGMuKS4NCg0KVGhpcyB3b3VsZCBwcm92aWRl
IGEgZGlyZWN0IG1hcHBpbmcgb2Ygd2hpY2ggbWFuYWdlbWVudCBwcm90b2NvbHMgYXJlIHN1cHBv
cnRlZCBmb3IgYSBnaXZlbiBwb3J0LCByYXRoZXIgdGhhbiBpdCBiZWluZyBpbmZlcnJlZCBieSB0
aGUgbGluay90cmFuc3BvcnQgZmllbGRzLCB3aGljaCBzaG91bGQgcmVhbGx5IGJlIGluZGVwZW5k
ZW50LiAgSXQgd291bGQgYWxzbyBhbGxvdyBmb3Igc2ltcGxlIGNoZWNrcyBieSB0aGUgY29yZSBs
YXllci4NCg0KSWYgd2Ugd2FudCB0aGUgY29kZSB0byBiZSBtb3JlIGdlbmVyaWMsIGFkZGl0aW9u
YWwgZmllbGQocykgY291bGQgYmUgYWRkZWQsIHN1Y2ggYXMgbWFkX3NpemUsIHNvIHRoYXQgYW55
IHNpemUgb2YgbWFuYWdlbWVudCBkYXRhZ3JhbSBpcyBzdXBwb3J0ZWQuICBUaGlzIHdvdWxkIGJl
IHVzZWQgaW5zdGVhZCBvZiBpbmZlcnJpbmcgdGhlIHNpemUgYmFzZWQgb24gdGhlIHN1cHBvcnRl
ZCBwcm90b2NvbC4NCg0KLSBTZWFuIA0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
