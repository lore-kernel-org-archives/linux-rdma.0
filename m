From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 36/41] IB/hfi1: add low level page locking
Date: Wed, 8 Jul 2015 22:08:02 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2575DAA8@fmsmsx120.amr.corp.intel.com>
References: <20150611230710.16479.62955.stgit@phlsvslse11.ph.intel.com>
	<20150611231142.16479.41039.stgit@phlsvslse11.ph.intel.com>
 <CAJ3xEMjM9kRrnCdJmKR2i9VySOLfsZMkU=ZnJE0rXs0tTPSbVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjM9kRrnCdJmKR2i9VySOLfsZMkU=ZnJE0rXs0tTPSbVw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBhbnl0aGluZyB3cm9uZyB3aXRoIHRoZSB1bWVtIHNlcnZpY2VzIHByb3ZpZGVkIGJ5IHRoZSBJ
QiBjb3JlIHRoYXQNCj4gcmVxdWlyZXMgdGhpcyBpbXBsZW1lbnRhdGlvbj8gd2hhdD8NCj4gDQoN
ClRoZSBjdXJyZW50IGxldmVsIG9mIHRoZSBBUEkgaXMgbWlzbWF0Y2hlZCB3aXRoIHRoZSBQU00g
U0RNQS4NCg0KVGhlIGliX3VtZW0gYXBpOg0KLSBtYXBzIGFuIFNHIGxpc3Qgd2hpY2ggaXNuJ3Qg
cmVxdWlyZWQgYnkgUFNNIHNpbmNlIERNQSBtYXBwaW5nIGlzIGRvbmUgYnkgdGhlIGxvdyBsZXZl
bCBTRE1BDQotIHRoZSBtYXBwaW5nIGlzIGJpLWRpcmVjdGlvbmFsIHZzLiBmcm9tIGRldmljZQ0K
LSBUaGUgcGQncyBjb250ZXh0IGlzIG5vdCB0aGVyZQ0KDQpDZXJ0YWlubHkgd2Ugd291bGQgY29u
c2lkZXIgYSBjb3JlIGNoYW5nZSB0aGF0IHByb3ZpZGVzIGp1c3QgdGhlIHBhZ2UgbG9ja2luZyBh
bmQgd2UgY291bGQgZmFrZSBhIGNvbnRleHQuDQoNCk1pa2UNCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
