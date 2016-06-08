From: Trond Myklebust <trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: Re: [PATCH v1 09/20] xprtrdma: Limit the number of rpcrdma_mws
Date: Wed, 8 Jun 2016 15:06:56 +0000
Message-ID: <8FF9BF11-C5BF-4418-9A84-AAD7A6D6321D@primarydata.com>
References: <20160607194001.18401.88592.stgit@manet.1015granger.net>
 <20160607194732.18401.71941.stgit@manet.1015granger.net>
 <20160607204941.GA7991@obsidianresearch.com>
 <F1820E16-A2BF-4529-A5C9-59C9AD57369A@oracle.com>
 <20160607212831.GA9192@obsidianresearch.com>
 <D90190F5-ACCB-45D8-B08D-B75023ED6240@oracle.com>
 <20160607220107.GA9982@obsidianresearch.com>
 <c43e37cd-71ea-8629-20f2-bcd674d50b83@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c43e37cd-71ea-8629-20f2-bcd674d50b83-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <E03A6D7E29AA134884D94819DE967BD6-Hry67jCOGbCcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

DQoNCk9uIDYvOC8xNiwgMTA6NTQsICJsaW51eC1uZnMtb3duZXJAdmdlci5rZXJuZWwub3JnIG9u
IGJlaGFsZiBvZiBUb20gVGFscGV5IiA8bGludXgtbmZzLW93bmVyQHZnZXIua2VybmVsLm9yZyBv
biBiZWhhbGYgb2YgdG9tQHRhbHBleS5jb20+IHdyb3RlOg0KDQo+T24gNi83LzIwMTYgNjowMSBQ
TSwgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPj4gT24gVHVlLCBKdW4gMDcsIDIwMTYgYXQgMDU6
NTE6MDRQTSAtMDQwMCwgQ2h1Y2sgTGV2ZXIgd3JvdGU6DQo+Pg0KPj4+IFRoZXJlIGlzIGEgcHJh
Y3RpY2FsIG51bWJlciBvZiBNUnMgdGhhdCBjYW4gYmUgYWxsb2NhdGVkDQo+Pj4gcGVyIGRldmlj
ZSwgSSB0aG91Z2h0LiBBbmQgZWFjaCBNUiBjb25zdW1lcyBzb21lIGFtb3VudA0KPj4+IG9mIGhv
c3QgbWVtb3J5Lg0KPj4NCj4+PiB4cHJ0cmRtYSBpcyBoYXBweSB0byBhbGxvY2F0ZSB0aG91c2Fu
ZHMgb2YgTVJzIHBlciBRUC9QRA0KPj4+IHBhaXIsIGJ1dCB0aGF0IGlzbid0IHByYWN0aWNhbCBh
cyB5b3Ugc3RhcnQgYWRkaW5nIG1vcmUNCj4+PiB0cmFuc3BvcnRzL2Nvbm5lY3Rpb25zLg0KPj4N
Cj4+IFllcywgdGhpcyBpcyBhbGwgc2FuZSBhbmQgdmFsaWQuDQo+Pg0KPj4gVHlwaWNhbGx5IHlv
dSdkIHRhcmdldCBhIGNvbmN1cnJlbmN5IGxpbWl0IHBlciBRUCBhbmQgYWxsb2NhdGUNCj4+IGV2
ZXJ5dGhpbmcgKCMgTVJzLCBzcSxycSxjcSBkZXB0aCwgZXRjKSBpbiBhY2NvcmRhbmNlIHdpdGgg
dGhhdCBnb2FsLA0KPj4gSSdkIGFsc28gc3VnZ2VzdCB0aGF0IHRhcmdldCBjb25jdXJyZW5jeSBp
cyBwcm9iYWJseSBhIHVzZXIgdHVuYWJsZS4uDQo+DQo+VGhpcyBpcyBhbHJlYWR5IHByZXNlbnQg
LSBpdCdzIHRoZSBSUEMgc2xvdCB0YWJsZSBkZXB0aC4gSXQgd291bGQgYmUNCj5ncmVhdCwgSU1P
LCB0byBtYWtlIHRoaXMgYSBtb3VudCBwYXJhbWV0ZXIgc2luY2UgaXQgaXMgdHJhbnNwb3J0LSBh
bmQNCj5hbHNvIHNlcnZlci1kZXBlbmRlbnQsIGJ1dCBjdXJyZW50bHkgSSBiZWxpZXZlIGl0IGlz
IGp1c3QgYSBrZXJuZWwNCj5SUEMgbW9kdWxlIHBhcmFtZXRlci4NCg0KVGhhdCB3b3VsZCBiZSBh
IG1vdW50IHBhcmFtZXRlciB3aGljaCB3b3VsZCBvbmx5IGFwcGx5IHRvIFJETUEgc2luY2UgZXZl
cnl0aGluZyBlbHNlIHVzZXMgZHluYW1pYyBzbG90IGFsbG9jYXRpb24gdGhlc2UgZGF5cy4gSeKA
mWQgcHJlZmVyIHRvIGF2b2lkIHRoYXQuDQoNClRyb25kDQoNCg==

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
