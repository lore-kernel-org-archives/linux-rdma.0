From: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 1/1] IB/ipoib: fix for rare multicast join race
 condition
Date: Wed, 10 Feb 2016 16:47:32 +0000
Message-ID: <F3529576D8E232409F431C309E29399328F6CD0C@CRSMSX102.amr.corp.intel.com>
References: <20160209193525.20351.78895.stgit@phlsvlogin03.ph.intel.com>
 <CAAk-MO9RdXNqhM1QKtqK+1DVc-kQzkm=C6tmLYzkd2vd+j_QbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAk-MO9RdXNqhM1QKtqK+1DVc-kQzkm=C6tmLYzkd2vd+j_QbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

SGkgRXJleiwNCg0KPiANCj4gVGhlIGNoZWNrIG92ZXIgdGhlIHByaXYtPmZsYWdzIGlzIG5vdCBz
YXRpc2ZpZWQsIGJlY2F1c2Ugb25lIGxpbmUNCj4gYWZ0ZXIgdGhlIGNoZWNrIHRoZSBvdGhlciB3
b3JrIGRldl9mbHVzaF94eHggKGZyb20gb3RoZXIgd29yayBxdWV1ZSwNCj4gc28gdGhleSBhcmUg
bm90IHN5bmMpICB3aGljaCBjYWxscyB0byBpcG9pYl9pYl9kZXZfZG93bg0KQWdyZWUuIExvY2sg
aXMgbmVjZXNzYXJ5LiB2NCB3aWxsIGZvbGxvdy4NCg0KVGhhbmtzLA0KQWxleC4NCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
