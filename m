From: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v5 1/1] IB/ipoib: fix for rare multicast join race
 condition
Date: Fri, 12 Feb 2016 23:19:02 +0000
Message-ID: <F3529576D8E232409F431C309E29399328F6D244@CRSMSX102.amr.corp.intel.com>
References: <20160211213051.29589.31877.stgit@phlsvlogin03.ph.intel.com>
	<CAJ3xEMgRxXx8kijLZK072oiN=_gYUXjqdUS=KtTKjk_BfKuXOw@mail.gmail.com>
 <CAJ3xEMh-F7HNZ73G9HojJOHww5GPo3VMDa9ffiFq3NXKUi69sQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMh-F7HNZ73G9HojJOHww5GPo3VMDa9ffiFq3NXKUi69sQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

DQo+ID4NCj4gDQo+IEFsZXgsIGZvciBuZXh0IHRpbWVzLi4uIHBsZWFzZSBwdXQgdGhlIFZ4IC0t
PiBWeSBoaXN0b3J5IGVpdGhlciBpbiB0aGUgY292ZXINCj4gbGV0dGVyIG9yIGluIGEgY2FzZSB3
aGVyZSB0aGlzIGlzIHNpbmdsZSBwYXRjaCAoYXMgd2FzIGhlcmUpIGFmdGVyIHRoZSAtLS0NCj4g
bGluZSwgZWxzZSB3ZSdsbCBoYXZlIHRoaXMgbGlzdGluZyBwcmVzZW50IGluIHRoZSB1cHN0cmVh
bSBrZXJuZWwgZ2l0IGZvcg0KPiB0aGUgcmVzdCBvZiB0aGUgaHVtYW4vbGludXggaGlzdG9yeSwg
c2luY2Ugd2hlbiB0aGUgbWFpbnRhaW5lciB1c2VzIGdpdCBhbSwNCj4gaXQgZ29lcyBpbi4NCg0K
WWVzLCBpdCBpcyBteSBmYXVsdC4NCkkgYW0gYXdhcmUgYWJvdXQgJy0tLScsIGJ1dCBzb21laG93
IEkndmUgbWlzc2VkIGl0IGFueXdheS4NCg0KPiBEb3VnLCBJIHNlZSBub3cgaW4geW91ciBnaXRo
dWIgdGhhdCB0aGlzIGluZGVlZCB3ZW50IGluLCBjb3VsZCB5b3UgbWFkZSBhDQo+IHNtYWxsIGdp
dCByZWJhc2UgcmV3b3JkaW5nIGFuZCByZW1vdmUgdGhpcyByZXZpZXcgaGlzdG9yeT8NCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
