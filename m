From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rdma_cm NULL deref in 4.11.0+
Date: Wed, 24 May 2017 21:37:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB120B6F@ORSMSX109.amr.corp.intel.com>
References: <acc72471-eb22-4474-04f5-db23227faadd@grimberg.me>
 <VI1PR0502MB30083E6CB505CA90A9E047C0D1FB0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170521154443.GD17751@mtr-leonro.local>
 <20170524163832.GA23034@obsidianresearch.com>
 <20170524185256.GT17751@mtr-leonro.local>
 <20170524191900.GA25200@obsidianresearch.com>
 <F8149B59-E43D-4E54-A901-1351BED23946@mellanox.com>
 <20170524204000.GA30878@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB120B2E@ORSMSX109.amr.corp.intel.com>
 <CAANLjFqb7CGJOu_T4_PhuJLOsX0mxTo6SO_R67daRHKpnMFdvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFqb7CGJOu_T4_PhuJLOsX0mxTo6SO_R67daRHKpnMFdvQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBJZiB0aGlzIGlzIGluIHJlZ2FyZCB0byAicmRtYV9jbSBzZWdmYXVsdHMgb24gUm9DRSB3aXRo
IENvbm5lY3RYLTQNCj4gW1dBUzogUmU6IHJwaW5nIHNlZ2ZhdWx0IHdpdGggNC45LjI4IG9uIENl
bnRPUyA3LjNdIiwgSSB0aGluayB3ZSBoYXZlDQo+IG5hcnJvd2VkIGl0IGRvd24gdG8gdGhlIG5v
ZGUgR1VJRCBiZWluZyAnMCcgb3Igc29tZXRoaW5nIGFsb25nIHRob3NlDQo+IGxpbmVzLiBXZSBh
cmUgc3RpbGwgZGlnZ2luZyBpbnRvIGl0LiBXZSBhcmUgbm90IGdldHRpbmcgYSBrZXJuZWwNCj4g
YmFja3RyYWNlIHdoZW4gbGlicmRtYWNtIHNlZ2ZhdWx0cy4NCg0KVGhlIGxpYnJkbWFjbSBhc3Nv
Y2lhdGVzIHVzZXIgc3BhY2UgaWQncyB3aXRoIGRldmljZXMgYmFzZWQgb24gdGhlIG5vZGUgZ3Vp
ZC4gIEFuZCB0aGUgY2hlY2sgdG8gbWFrZSB0aGlzIGFzc29jaWF0aW9uIHNlZXMgaWYgdGhlIG5v
ZGUgZ3VpZCBmcm9tIHRoZSBrZXJuZWwgaXMgbm9uLXplcm8uICBUaGVyZSBtYXkgYmUgYW4gYXNz
dW1wdGlvbiBmdXJ0aGVyIG9uIGluIHRoZSBjb2RlIHRoYXQgYSBkZXZpY2UgaGFzIGJlZW4gYXNz
aWduZWQsIGJ1dCBvbmUgd2FzIG5vdCwgYW5kIG5vIGVycm9yIHdhcyByZXBvcnRlZC4NCg0KVGhp
cyBjb3VsZCB2ZXJ5IHdlbGwgYmUgY29taW5nIGZyb20gYW4gZXJyb3IgaW4gdGhlIGtlcm5lbCBu
b3QgcmVwb3J0aW5nIHRoZSBub2RlX2d1aWQgY29ycmVjdGx5LCB3aGljaCBwcmV2ZW50cyB0aGUg
bGlicmRtYWNtIGZyb20gbWFraW5nIHRoZSBleHBlY3RlZCBkZXZpY2UgYXNzb2NpYXRpb24uDQoN
Ci0gU2Vhbg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
