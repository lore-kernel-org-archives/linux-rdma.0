From: "Sanchez, Sebastian" <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 02/20] IB/hfi1: Remove hyper-thread siblings by walking
 CPU mask
Date: Thu, 20 Apr 2017 17:20:18 +0000
Message-ID: <5CDA63463B33C94CA80846587415F07704076B86@ORSMSX111.amr.corp.intel.com>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
 <20170409171537.10579.68545.stgit@scvm10.sc.intel.com>
 <20170410074904.GA26626@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170410074904.GA26626-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Struk, Tadeusz" <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

VGhlIGlycSBsYXllciBQQ0lfSVJRX0FGRklOSVRZIGZsYWcgbWFrZXMgcGNpX2FsbG9jX2lycV92
ZWN0b3JzKCkgc3ByZWFkIGFsbCB0aGUgaW50ZXJydXB0cyBhcm91bmQgdGhlIGF2YWlsYWJsZSBD
UFVzLCBob3dldmVyLCB0aGUgQVBJIGRvZXNuJ3QgYWxsb3cgdG8gZXhjbHVkZSB0aGUgaHlwZXIg
dGhyZWFkaW5nIENQVSBjb3JlcyBvciBsaW1pdCB0aGUgQ1BVcyB0byB1c2UgZm9yIHRoZSBhZmZp
bml0eSBtYXNrLiBJZiB0aGUgQVBJIGhhZCBhIHdheSB0byBwcm92aWRlIGFuIGFmZmluaXR5IGhp
bnQgaW50byB0aGlzIGZ1bmN0aW9uIGluc3RlYWQgb2YgaGF2aW5nIHRoZW0gYXV0b21hdGljYWxs
eSBnZW5lcmF0ZWQgaXQgcHJvdmlkZSBtb3JlIGZsZXhpYmlsaXR5IHRvIHRoZSBoZmkxIGRyaXZl
ci4NCg0KU2ViYXN0aWFuDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
