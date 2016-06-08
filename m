From: Trond Myklebust <trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: Re: [PATCH v1 09/20] xprtrdma: Limit the number of rpcrdma_mws
Date: Wed, 8 Jun 2016 17:50:42 +0000
Message-ID: <B93A49E2-AD7A-4D45-9D7C-DA9AD743DA81@primarydata.com>
References: <20160607194001.18401.88592.stgit@manet.1015granger.net>
 <20160607194732.18401.71941.stgit@manet.1015granger.net>
 <20160607204941.GA7991@obsidianresearch.com>
 <F1820E16-A2BF-4529-A5C9-59C9AD57369A@oracle.com>
 <20160607212831.GA9192@obsidianresearch.com>
 <D90190F5-ACCB-45D8-B08D-B75023ED6240@oracle.com>
 <20160607220107.GA9982@obsidianresearch.com>
 <c43e37cd-71ea-8629-20f2-bcd674d50b83@talpey.com>
 <8FF9BF11-C5BF-4418-9A84-AAD7A6D6321D@primarydata.com>
 <20160608174014.GB30822@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160608174014.GB30822-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <9E5A64B0577B0A42AD24CE6E916BE480-Hry67jCOGbCcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

DQoNCk9uIDYvOC8xNiwgMTM6NDAsICJKYXNvbiBHdW50aG9ycGUiIDxqZ3VudGhvcnBlQG9ic2lk
aWFucmVzZWFyY2guY29tPiB3cm90ZToNCg0KPk9uIFdlZCwgSnVuIDA4LCAyMDE2IGF0IDAzOjA2
OjU2UE0gKzAwMDAsIFRyb25kIE15a2xlYnVzdCB3cm90ZToNCj4NCj4+ICAgIFRoYXQgd291bGQg
YmUgYSBtb3VudCBwYXJhbWV0ZXIgd2hpY2ggd291bGQgb25seSBhcHBseSB0byBSRE1BIHNpbmNl
DQo+PiAgICBldmVyeXRoaW5nIGVsc2UgdXNlcyBkeW5hbWljIHNsb3QgYWxsb2NhdGlvbiB0aGVz
ZSBkYXlzLiBJw6JkIHByZWZlciB0bw0KPj4gICAgYXZvaWQgdGhhdC4NCj4NCj5UaGUgb25seSBy
ZWFzb24gUkRNQSBjYW5ub3QgYWxsb2NhdGUgTVJzIG9uIHRoZSBmbHkgaXMNCj5wZXJmb3JtYW5j
ZS4uIE1heWJlIGEgZHluYW1pYyBzY2hlbWUgaXMgdGhlIHJpZ2h0IGFuc3dlci4uDQo+DQoNCkl0
IHNob3VsZCBiZSBlYXN5IHRvIGRvIGZvciBORlN2NC54ICh4PjApLCB3aGVyZSB0aGUgTkZTIHBy
b3RvY29sIGFscmVhZHkgbWFuYWdlcyB0aGUgbnVtYmVyIG9mIHNsb3RzLiBUaGUgUlBDIGxheWVy
IGNvdWxkIGJlIG5vdGlmaWVkIHdoZW4gaXQgaXMgT0sgdG8gcmV0aXJlIHNsb3RzIHRoYXQgYXJl
IG5vIGxvbmdlciBpbiB1c2UuDQoNCg0KDQo=

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
