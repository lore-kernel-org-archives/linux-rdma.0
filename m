From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] IB/ipath: Convert ipath_user_sdma_pin_pages() to
 use get_user_pages_fast()
Date: Fri, 4 Oct 2013 13:45:50 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211B0148@FMSMSX107.amr.corp.intel.com>
References: <20131004132821.29162.46169.stgit@phlsvslse11.ph.intel.com>
 <20131004132906.29162.1038.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131004132906.29162.1038.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBFdmVuIG1vcmUgaW50ZXJlc3RpbmdseSB0aGUgZnVuY3Rpb24gaXBhdGhfdXNlcl9zZG1hX3F1
ZXVlX3BrdHMoKSAoYW5kDQo+IGFsc28NCj4gaXBhdGhfdXNlcl9zZG1hX2NvYWxlc2NlKCkgY2Fs
bGVkIHNvbWV3aGF0IGxhdGVyKSBjYWxsIGNvcHlfZnJvbV91c2VyKCkNCj4gd2hpY2ggY2FuIGhp
dCBhIHBhZ2UgZmF1bHQgYW5kIHdlIGRlYWRsb2NrIG9uIHRyeWluZyB0byBnZXQgbW1hcF9zZW0N
Cj4gd2hlbiBoYW5kbGluZyB0aGF0IGZhdWx0LiBTbyBqdXN0IG1ha2UgaXBhdGhfdXNlcl9zZG1h
X3Bpbl9wYWdlcygpIHVzZQ0KPiBnZXRfdXNlcl9wYWdlc19mYXN0KCkgYW5kIGxlYXZlIG1tYXBf
c2VtIGxvY2tpbmcgZm9yIG1tLg0KPiANCj4gVGhpcyBkZWFkbG9jayBoYXMgYWN0dWFsbHkgYmVl
biBvYnNlcnZlZCBpbiB0aGUgd2lsZCB3aGVuIHRoZSBub2RlIGlzIHVuZGVyDQo+IG1lbW9yeSBw
cmVzc3VyZS4NCg0KVGhpcyBwYXRjaCBoYXMgYmVlbiByZS1zdWJtaXRlZCBpbiBodHRwOi8vbWFy
Yy5pbmZvLz9sPWxpbnV4LXJkbWEmbT0xMzgwODkzMzUxMDYzNTMmdz0yLg0KDQpNaWtlDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
