From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next v2 15/16] IB/core: Map iWarp AH type to
 undefined in rdma_ah_find_type
Date: Sat, 27 Jan 2018 01:24:30 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E67D9033F@CRSMSX101.amr.corp.intel.com>
References: <20180126211126.12097.47410.stgit@scvm10.sc.intel.com>
 <20180126213043.12097.88707.stgit@scvm10.sc.intel.com>
 <VI1PR0502MB300863FABEA9D4B962E4D826D1E00@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB300863FABEA9D4B962E4D826D1E00-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hiatt, Don" <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

W3NuaXBdDQoNCj4gPg0KPiA+IC0vKkdldCBBSCB0eXBlICovDQo+ID4gKy8qKg0KPiA+ICsgKiBy
ZG1hX2FoX2ZpbmRfdHlwZSAtIFJldHVybiBhZGRyZXNzIGhhbmRsZSB0eXBlLg0KPiA+ICsgKg0K
PiA+ICsgKiBAZGV2OiBEZXZpY2UgdG8gYmUgY2hlY2tlZA0KPiA+ICsgKiBAcG9ydF9udW06IFBv
cnQgbnVtYmVyDQo+ID4gKyAqLw0KPiA+ICBzdGF0aWMgaW5saW5lIGVudW0gcmRtYV9haF9hdHRy
X3R5cGUgcmRtYV9haF9maW5kX3R5cGUoc3RydWN0DQo+ID4gaWJfZGV2aWNlICpkZXYsDQo+ID4g
LQkJCQkJCSAgICAgICB1MzIgcG9ydF9udW0pDQo+ID4gKwkJCQkJCSAgICAgICB1OCBwb3J0X251
bSkNCj4gPiAgew0KPiA+ICAJaWYgKHJkbWFfcHJvdG9jb2xfcm9jZShkZXYsIHBvcnRfbnVtKSkN
Cj4gPiAgCQlyZXR1cm4gUkRNQV9BSF9BVFRSX1RZUEVfUk9DRTsNCj4gPiArCWVsc2UgaWYgKHJk
bWFfcHJvdG9jb2xfaXdhcnAoZGV2LCBwb3J0X251bSkpDQo+ID4gKwkJcmV0dXJuIFJETUFfQUhf
QVRUUl9UWVBFX1VOREVGSU5FRDsNCj4gPiAgCWVsc2UgaWYgKChyZG1hX3Byb3RvY29sX2liKGRl
diwgcG9ydF9udW0pKSAmJg0KPiA+ICAJCSAocmRtYV9jYXBfb3BhX2FoKGRldiwgcG9ydF9udW0p
KSkNCj4gPiAgCQlyZXR1cm4gUkRNQV9BSF9BVFRSX1RZUEVfT1BBOw0KPiBZb3UgbmVlZCBhIGNh
c2UgdG8gcmV0dXJuIEFIX1RZUEVfSUIuDQo+IA0KDQpUaGF0IGlzIGNvdmVyZWQgaW4gdGhlIGVs
c2UgYmVsb3cgdGhpcyBwYXJ0IG9mIHRoZSBwYXRjaC4NCg0KSXJhDQoNCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
