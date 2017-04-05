From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 19/20] IB/rdmavt, IB/qib, IB/hfi1: Make percpu
 refcount optional for user MRs
Date: Wed, 5 Apr 2017 20:09:16 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC342EA858@fmsmsx120.amr.corp.intel.com>
References: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
 <20170321002631.28538.2121.stgit@scvm10.sc.intel.com>
 <1491417489.2923.6.camel@redhat.com>
 <f008c532-340e-01f2-80e6-4bea74175e3e@intel.com>
 <CALq1K=JsjSCiSBeZVe4kHQmjw7tznL36JcsamZTVGZ5RhBvZPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALq1K=JsjSCiSBeZVe4kHQmjw7tznL36JcsamZTVGZ5RhBvZPw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ID4gSXMgdGhlcmUgYSBhbm90aGVyIHdheSB3ZSBzaG91bGQgYmUgbG9va2luZyBhdCBmb3Igc2V0
dGluZyB0aGluZ3MgbGlrZSB0aGlzPw0KPiANCj4gVXNlIHZlbmRvciBjaGFubmVsIGludGVyZmFj
ZSB0byBjb25maWd1cmUgeW91ciBkcml2ZXIuDQo+IA0KDQpXaGF0IGlzIHRoYXQ/IGNvbmZpZ2Zz
IG9yIHNvbWV0aGluZyBlbHNlPw0KDQpNaWtlDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
