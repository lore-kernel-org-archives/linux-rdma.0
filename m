From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 rdma-next 17/18] IB/core: Define 'ib' and 'roce'
 rdma_ah_attr types
Date: Thu, 5 Oct 2017 02:02:02 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB19B2A2@ORSMSX109.amr.corp.intel.com>
References: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1493491290-31621-18-git-send-email-dasaratharaman.chandramouli@intel.com>
 <VI1PR0502MB30083D21E466C23698A93228D1730@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <73561590-0d5e-54ba-a98a-d8c45f869955@intel.com>
 <VI1PR0502MB3008B828399AB0A08AA08AC6D1730@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008B828399AB0A08AA08AC6D1730-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hiatt, Don" <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiA+ID4+ICtzdGF0aWMgaW5saW5lIGVudW0gcmRtYV9haF9hdHRyX3R5cGUgcmRtYV9haF9maW5k
X3R5cGUoc3RydWN0DQo+ID4gPj4gK2liX2RldmljZQ0KPiA+ID4+ICpkZXYsDQo+ID4gPj4gKwkJ
CQkJCSAgICAgICB1MzIgcG9ydF9udW0pDQo+ID4gPj4gK3sNCj4gPiA+PiArCWlmICgocmRtYV9w
cm90b2NvbF9yb2NlKGRldiwgcG9ydF9udW0pKSB8fA0KPiA+ID4+ICsJICAgIChyZG1hX3Byb3Rv
Y29sX2l3YXJwKGRldiwgcG9ydF9udW0pKSkNCj4gPiA+PiArCQlyZXR1cm4gUkRNQV9BSF9BVFRS
X1RZUEVfUk9DRTsNCj4gPiA+IENoZWNrIGZvciBpV2FycCB0byBkZWZpbmUgQUggYXR0cmlidXRl
IHR5cGUgYXMgUm9DRSBhcHBlYXJzIGVycm9yDQo+IHRvIG1lLg0KPiA+ID4gVGFraW5nIHF1aWNr
IGxvb2sgYXQgaTQwaXcgYW5kIG5lcyBkcml2ZXJzIGFwcGVhcnMgdG8gcmV0dXJuIC0NCj4gRU5P
U1lTDQo+ID4gPiBmb3INCj4gPiBpNDBpd19jcmVhdGVfYWgoKSwgbmVzX2NyZWF0ZV9haC4NCj4g
PiA+IFdpbGwgeW91IHBsZWFzZSBzdWJtaXQgYSBmaXggdGhhdCBhdm9pZHMgYWJvdmUgaVdhcnAg
Y2hlY2s/DQo+ID4gPg0KPiA+ID4NCj4gPiBpNDBpd19wb3J0X2ltbXV0YWJsZSBzZXRzIHRoZSBS
RE1BX0NPUkVfUE9SVF9JV0FSUCBpbW11dGFibGUgZmxhZywNCj4gQnV0IHdoZW4gd291bGQgc29t
ZW9uZSBjcmVhdGUgb3IgaW5pdGlhbGl6ZSBhaCBmb3IgaVdhcnAgcG9ydCwgZ2l2ZW4NCj4gdGhh
biBjcmVhdGVfYWggaXMgdW5zdXBwb3J0ZWQuDQo+IEFIIHR5cGUgb2YgUm9DRSBmb3IgaVdhcnAs
IGRvZXNuJ3Qgc291bmQgY29ycmVjdC4NCg0KSSBhZ3JlZSB3aXRoIFBhcmF2LiAgTWFwcGluZyBp
V2FycCB0byBBSCB0eXBlIFJvQ0UgZG9lc24ndCBtYWtlIHNlbnNlLiAgSU1PLCBpV2FycCBzaG91
bGQgbWFwIHRvIEFIX0FUVFJfVFlQRV9VTkRFRklORUQgb3Igc29tZXRoaW5nIHNpbWlsYXIuDQoN
Ci0gU2Vhbg0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
