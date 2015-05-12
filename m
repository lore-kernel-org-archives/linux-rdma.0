From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/qib: fix test of unsigned variable
Date: Tue, 12 May 2015 16:29:57 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2570FE90@fmsmsx120.amr.corp.intel.com>
References: <20150511121315.21044.78464.stgit@phlsvslse11.ph.intel.com>
	 <1431348365.25060.31.camel@opteya.com>
 <1431447713.43876.44.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431447713.43876.44.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBTbywgdGhlIG1hdHJpeCBvZiB3aGF0IHRoZSBkcml2ZXIgZG9lcyBub3cgbG9va3MgbGlrZSB0
aGlzOg0KPiANCj4gZGQtPndjX2Nvb2tpZSA9PSAwOiBQQVQgd2FzIHVzZWQNCj4gZGQtPndjX2Nv
b2tpZSA+IDA6IHdjIHdhcyB1c2VkIHN1Y2Nlc3NmdWxseSB3Y19jb29raWUgPCAwOiBuZWl0aGVy
IFBBVA0KPiBkZC0+bm9yIHdjIHdhcyB1c2VkDQo+IA0KPiBJJ3ZlIGZpeGVkIHVwIHRoZSBjaGFu
Z2UgdG8gc2ltcGx5IHN3aXRjaCB3Y19jb29raWUgZnJvbSB1bnNpZ25lZCBsb25nIHRvIHBsYWlu
DQo+IGxvbmcgYW5kIGxlZnQgdGhlIG9yaWdpbmFsIGNvZGUgYXMgaXQgd2FzLCBhbmQgaXQgaXMg
bm93IHN0YWdlZCBmb3IgNC4xLXJjLg0KPiANCg0KSSBoYXZlIGEgdjIgb2YgdGhpcyBwYXRjaCB0
aGF0IGNoYW5nZXMgdGhlIHR5cGUgb2YgdGhlIHdjX2Nvb2tpZS4NCg0KSXQgYWxzbyB1c2VzIGFu
eSBuZWdhdGl2ZSBjb29raWUgYXMgdGhlIHJldC4gICBJdCBzZWVtcyBiZXR0ZXIgdG8gdXNlIGlu
IGFjdHVhbCBlcnJvciBhcmNoX3BoeXNfd2NfYWRkKCkgZnJvbSAgdnMuIGEgY2FubmVkIG9uZS4N
Cg0KTWlrZSANCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
