From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: linux rdma 3.14 merge plans
Date: Fri, 7 Mar 2014 05:07:34 +0000
Message-ID: <EE7902D3F51F404C82415C4803930ACD3FDDD50E@CMEXMB1.ad.emulex.com>
References: <CAJZOPZ+4yQ-sT=ks7+eiJjkxOjy5w=BmG16JVcUPiuVsof7qEA@mail.gmail.com>
	 <CAG4TOxOMmvFWnkU3DBn33rscEKh2_YfbUCKY=iY8PCVN3+nEsA@mail.gmail.com>
	 <52CD1C68.4050406@mellanox.com>
	 <1389645171.5567.459.camel@haakon3.risingtidesystems.com>
	 <1389820541.5567.543.camel@haakon3.risingtidesystems.com>
	 <CAG4TOxNa32sLxifPx_f8sW04B_qSh01WWfWjRvam6fjvFLDXSQ@mail.gmail.com>
	 <1389906852.5567.668.camel@haakon3.risingtidesystems.com>
	 <CAG4TOxPeYQ=e5LdJft1Hkx8donUQjJaKDEAv3iRLGxPYJQ_b9w@mail.gmail.com>
	 <1390102949.5567.749.camel@haakon3.risingtidesystems.com>
	 <52DBB4F1.4020400@mellanox.com>
	 <CAJZOPZJFbcTh2zO8mos0M+gv0LW-Gmh877Vxe4tLvfPX19oqTw@mail.gmail.com>
	 <CAJZOPZLuz-Z59agBd0Q9J2=sSG-F+Y8MrJkoGbtiF5M+CnKU1g@mail.gmail.com>
	 <CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg@mail.gmail.com>
	 <1390375658.5567.917.camel@haakon3.risingtidesystems.com>
	 <1391731323.14985.56.camel@haakon3.risingtidesystems.com>
	 <CAG4TOxNpnMMR-vfAVa+m6f-z82msxygADUkJ7mmrKtzHCOqdhA@mail.gmail.com>
	 <1394013249.19539.17.camel@haakon3.risingtidesystems.com>
	 <CAG4TOxNRkAUH5Jsd67--ydWtUJqE1=pnVSuorgn4vNQiuYx1wg@mail.gmail.com>
 <1394046218.20601.12.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1394046218.20601.12.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

SGkgUm9sYW5kLA0KDQpJcyBpdCBva2F5IHRvIHNlbmQgbmV4dCBzZXJpZXMgb2YgcGF0Y2hlcyBl
dmVuIGlmIHByZXZpb3VzIHNlcmllcyBpcyBub3QgYWNjZXB0ZWQgeWV0IGluIHlvdXIgdHJlZT8g
T2ZmLWNvdXJzZSBJIHdpbGwgY3V0IHBhdGNoZXMgb24gdG9wIG9mIHByZXZpb3VzIHNlcmllcyBv
ZiBwYXRjaGVzLg0KDQotUmVnYXJkcw0KIERldmVzaA0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KRnJvbTogbGludXgtcmRtYS1vd25lckB2Z2VyLmtlcm5lbC5vcmcgW21haWx0bzpsaW51
eC1yZG1hLW93bmVyQHZnZXIua2VybmVsLm9yZ10gT24gQmVoYWxmIE9mIE5pY2hvbGFzIEEuIEJl
bGxpbmdlcg0KU2VudDogVGh1cnNkYXksIE1hcmNoIDA2LCAyMDE0IDEyOjM0IEFNDQpUbzogUm9s
YW5kIERyZWllcg0KQ2M6IE9yIEdlcmxpdHo7IEhlZnR5IFNlYW47IGxpbnV4LXJkbWE7IE1hcnRp
biBLLiBQZXRlcnNlbjsgdGFyZ2V0LWRldmVsOyBTYWdpIEdyaW1iZXJnOyBsaW51eC1rZXJuZWwN
ClN1YmplY3Q6IFJlOiBsaW51eCByZG1hIDMuMTQgbWVyZ2UgcGxhbnMNCg0KT24gV2VkLCAyMDE0
LTAzLTA1IGF0IDA3OjE4IC0wODAwLCBSb2xhbmQgRHJlaWVyIHdyb3RlOg0KPiBPbiBXZWQsIE1h
ciA1LCAyMDE0IGF0IDE6NTQgQU0sIE5pY2hvbGFzIEEuIEJlbGxpbmdlciANCj4gPG5hYkBsaW51
eC1pc2NzaS5vcmc+IHdyb3RlOg0KPiA+IFRoYXQgYWxsIHNhaWQsIGRvIHlvdSBoYXZlIGFuIG9i
amVjdGlvbiB3cnQgdGFraW5nIHRoaXMgYml0cyB0aHJvdWdoIA0KPiA+IHRhcmdldC1wZW5kaW5n
Li4/ICBHaXZlbiB0aGUgZGVwZW5kZW5jaWVzIGludm9sdmVkLCB0aGF0IHdvdWxkIHNlZW0gDQo+
ID4gdGhlIG1vc3QgbG9naWNhbCBwYXRoIHRvIHRha2UuDQo+IA0KPiBQZXJoYXBzIG5vdCBzdXJw
cmlzaW5nbHksIEkgd291bGQgcHJlZmVyIHRvIGdldCBhIGNoYW5jZSB0byByZXZpZXcgYSANCj4g
bWFqb3IgY2hhbmdlIHRvIHRoZSBjb3JlIFJETUEgbWlkbGF5ZXIgcmF0aGVyIHRoYW4gaGF2aW5n
IHlvdSBtZXJnZSBpdCANCj4gdGhyb3VnaCB5b3VyIHRyZWUuICBTbyB5ZXMgSSBkbyBvYmplY3Qu
ICBQbGVhc2UgZ2l2ZSBtZSBhIGNoYW5jZSB0byANCj4gcmV2aWV3IGFuZCBtZXJnZSBpdC4gIEkg
YW0gd29ya2luZyBvbiB0aGF0IHRoaXMgd2Vlay4NCj4gDQoNCkdyZWF0LiAgV2UnbGwgYmUgbG9v
a2luZyBmb3IgYSByZXNwb25zZSBieSB0aGUgZW5kIG9mIHRoZSB3ZWVrLg0KDQpPdGhlcndpc2Ug
aWYgeW91IGVuZCB1cCBub3QgaGF2aW5nIHRpbWUsIHdlJ2Qgc3RpbGwgbGlrZSB0byBtb3ZlIGZv
cndhcmQgZm9yIHYzLjE1IGdpdmVuIHRoZSBhbW91bnQgb2YgcmV2aWV3IHRoZSBzZXJpZXMgaGFz
IGFscmVhZHkgZ290dGVuIG9uIHRoZSBsaXN0Lg0KDQpUaGFuayB5b3UsDQoNCi0tbmFiDQoNCg0K
DQotLQ0KVG8gdW5zdWJzY3JpYmUgZnJvbSB0aGlzIGxpc3Q6IHNlbmQgdGhlIGxpbmUgInVuc3Vi
c2NyaWJlIGxpbnV4LXJkbWEiIGluIHRoZSBib2R5IG9mIGEgbWVzc2FnZSB0byBtYWpvcmRvbW9A
dmdlci5rZXJuZWwub3JnIE1vcmUgbWFqb3Jkb21vIGluZm8gYXQgIGh0dHA6Ly92Z2VyLmtlcm5l
bC5vcmcvbWFqb3Jkb21vLWluZm8uaHRtbA0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
