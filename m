From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Sat, 3 Jun 2017 13:02:50 +0000
Message-ID: <1496494969.3056.1.camel@sandisk.com>
References: <20170529082423.1180-1-leon@kernel.org>
         <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com>
         <20170531040437.GE5406@mtr-leonro.local>
         <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com>
         <1496261429.2608.15.camel@sandisk.com>
         <20170602162849.GA28660@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170602162849.GA28660-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Content-Language: en-US
Content-ID: <A2D71B33D1D7A746A72C1A64268FBD11-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org" <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>, "mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCAyMDE3LTA2LTAyIGF0IDExOjI4IC0wNTAwLCBTaGlyYXogU2FsZWVtIHdyb3RlOg0K
PiBPbiBXZWQsIE1heSAzMSwgMjAxNyBhdCAwMjoxMDozMVBNIC0wNjAwLCBCYXJ0IFZhbiBBc3Nj
aGUgd3JvdGU6DQo+ID4gT24gV2VkLCAyMDE3LTA1LTMxIGF0IDEyOjQyIC0wNTAwLCBTaGlyYXog
U2FsZWVtIHdyb3RlOg0KPiA+ID4gPiA1LiBJIHByb3Bvc2VkIGEgc29sdXRpb24gLT4gZ28gYW5k
IGZpeCB5b3VyIHVzZXIgc3BhY2UgcHJvZ3JhbS4NCj4gPiA+IA0KPiA+ID4gVGhpcyBpcyBhIGtl
cm5lbCBwYXRjaCB5b3UgYXJlIHRyeWluZyB0byByZXZlcnQsIHlvdSBhcmUgYnJlYWtpbmcgZXhp
c3RpbmcNCj4gPiA+IGtlcm5lbCBmdW5jdGlvbmFsaXR5LiAgTm90aGluZyB0byBkbyB3aXRoIHVz
ZXIgc3BhY2UuDQo+ID4gPiANCj4gPiA+IEJvdHRvbSBsaW5lLCBjb21lIHVwIHdpdGggYSBzb2x1
dGlvbiB0aGF0IHdpbGwgYWRkcmVzcyBib3RoIHBvcnQgbWFwcGVyDQo+ID4gPiBmdW5jdGlvbmFs
aXR5IGFuZCB5b3VyIGlzc3VlLg0KPiA+IA0KPiA+IEhlbGxvIFNoaXJheiwNCj4gPiANCj4gPiBT
b3JyeSB0aGF0IHRoaXMgbWVhbnMgYWRkaXRpb25hbCB3b3JrIGZvciB5b3UsIGJ1dCBJIGFncmVl
IHdpdGggTGVvbiB0aGF0DQo+ID4gdXNlciBzcGFjZSBzb2Z0d2FyZSBzaG91bGQgbm90IGFzc3Vt
ZSB0aGF0IG5ldGxpbmsgc29ja2V0cyBhcmUgYSByZWxpYWJsZQ0KPiA+IGNvbW11bmljYXRpb24g
bWVjaGFuaXNtLg0KPiANCj4gSGkgQmFydCAtIFRoYW5rIHlvdSBmb3IgeW91ciByZXNwb25zZS4N
Cj4gDQo+IFRoZSBvcmlnaW5hbCBwcm9ibGVtIHdhcyB0aGF0IGlibmxfdW5pY2FzdCwgd2hpY2gg
aXMgdXNlZCB0byBzZW5kIG5sIG1lc3NhZ2VzIGZyb20gDQo+IHBvcnRtYXBwZXIga2VybmVsIHNw
YWNlIHRvIHVzZXItc3BhY2UsIHdvdWxkIG9jY2FzaW9uYWxseSBhbmQgbW9tZW50YXJpbHkgZmFp
bCB1bmRlciBzdHJlc3MuIA0KPiBXZSBjb3VsZCBoYXZlIHJldHJpZWQgdGhlIGNhbGwgZm9yIGEg
Y2VydGFpbiBhbW91bnQgb2YgdGltZSwgYnV0IHNpbmNlIG5ldGxpbmtfdW5pY2FzdCBoYXMgYSAN
Cj4gbm9uYmxvY2svYmxvY2sgcGFyYW1ldGVyLCB3ZSBjaG9zZSB0byB1c2UgdGhlIGJsb2NraW5n
IG9wdGlvbiB3aXRoIGEgdGltZW91dC4gU28gd2UgdGhvdWdodCB3ZSANCj4gZGlkIGFjY291bnQg
Zm9yIGRlYWRsb2NrcyB3aXRoIHRoaXMgdGltZW91dC4NCg0KSGVsbG8gU2hpcmF6LA0KDQpBY2Nv
cmRpbmcgdG8gd2hhdCBJIHNlZSBpbiBpd3BtZC9pd3BtZC5jb25mIHRoZSBkZWZhdWx0IHZhbHVl
IGZvciB0aGUgaXdwbWQNCm5ldGxpbmsgc29ja2V0IHJlY2VpdmUgYnVmZmVyIHNpemUgaXMgNDE5
NDMwNDAwIGJ5dGVzLiBTbyBJJ20gc3VycHJpc2VkIHRoYXQNCnNlbmRpbmcgbmV0bGluayBtZXNz
YWdlcyBvY2Nhc2lvbmFsbHkgZmFpbHMgc2luY2UgdGhlIHJlY2VpdmUgYnVmZmVyIGlzIHNvDQps
YXJnZT8NCg0KQmFydC4NCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
