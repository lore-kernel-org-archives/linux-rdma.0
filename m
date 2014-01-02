From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: failure to get gid with rdma_bind_addr with >= 3.10 kernels
Date: Thu, 2 Jan 2014 16:33:26 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388D0FBFA@ORSMSX109.amr.corp.intel.com>
References: <527F6896.1080802@mellanox.com> <527F69B1.9070701@mellanox.com>
	 <1828884A29C6694DAF28B7E6B8A8237388CF6F78@ORSMSX109.amr.corp.intel.com>
	 <00000142485f86e5-c3027528-9892-4d5c-8d72-0ed5f98666c4-000000@email.amazonses.com>
	 <1828884A29C6694DAF28B7E6B8A8237388CF6FD0@ORSMSX109.amr.corp.intel.com>
	 <52C533C0.3070103@mellanox.com>
 <1388675827.22995.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1388675827.22995.7.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBBZnRlciByZWFkaW5nIHF1aWNrbHkgdGhlIHRocmVhZCwgSSBzdGlsbCBiZWxpZXZlIHRoYXQn
cyBzb3VuZCBsaWtlIGENCj4ga2VybmVsIHJlZ3Jlc3Npb24gd2hpY2ggYnJva2UgZXhpc3Rpbmcg
dXNlcnNwYWNlIGFwcGxpY2F0aW9ucy4NCj4gDQo+IFNvIGEgcGF0Y2ggbXVzdCBiZSBhcHBsaWVk
IG9uIHRoZSBrZXJuZWwgdG8gZml4IHRoYXQgcmVncmVzc2lvbi4NCg0KV2hlbiBBRl9JQiB3YXMg
YWRkZWQgdG8gdGhlIGtlcm5lbCwgY29ycmVzcG9uZGluZyBjaGFuZ2VzIHdlcmUgYWRkZWQgdG8g
dGhlIGxpYnJkbWFjbS4gIFRob3NlIGNoYW5nZXMgdG8gdGhlIGxpYnJkbWFjbSBhcmUgdGhlIGNh
dXNlIG9mIHRoZSBpc3N1ZS4NCg0KVGhlIGtlcm5lbCByZG1hIGNtIHByZXZpb3VzbHkgc3VwcG9y
dGVkIGEgc2luZ2xlICdxdWVyeScgY2FsbC4gIFdpdGggQUZfSUIsIGl0IHN1cHBvcnRzIHRoZSBv
cmlnaW5hbCBjYWxsLCBwbHVzIDMgYWRkaXRpb25hbCBjYWxscy4gIFRoZSBwcm9ibGVtIGlzIHRo
ZSBsaWJyZG1hY20gdXNpbmcgdGhlIG5ld2VyIHF1ZXJ5IGNhbGxzLg0KIA0KPiBJbnRyb2R1Y2lu
ZyBBRl9JQiBtdXN0IG5vdCBoYXZlIGNoYW5nZWQgdGhlIGJlaGF2b3IgZm9yIGV4aXN0aW5nDQo+
IGFwcGxpY2F0aW9ucy4gRXhpc3RpbmcgYXBwbGljYXRpb25zIG11c3Qgbm90IG5lZWQgYSBuZXcg
bGlicmRtYWNtIHdoZW4NCj4gdGhleSBkb24ndCB1c2UgbmV3ZXIga2VybmVsIGV4dGVuc2lvbnMu
DQoNCkFuIG9sZGVyIHZlcnNpb24gb2YgdGhlIGxpYnJkbWFjbSB0aGF0IGRvZXMgTk9UIHN1cHBv
cnQgQUZfSUIgc2hvdWxkIHdvcmsgZmluZS4NCg0KLSBTZWFuDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
