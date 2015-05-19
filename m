From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/3] IB/sa: route SA pathrecord query through netlink
Date: Tue, 19 May 2015 19:58:32 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FDD2A9@ORSMSX109.amr.corp.intel.com>
References: <1431975616-23529-1-git-send-email-kaike.wan@intel.com>
 <1431975616-23529-4-git-send-email-kaike.wan@intel.com>
 <555AC36D.5050904@mellanox.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CAB243E@CRSMSX101.amr.corp.intel.com>
 <CAJ3xEMhkpYYtzrsOw=8JQOekpVT6xQC9P2itH3H3oAjjPfWrng@mail.gmail.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CAB2677@CRSMSX101.amr.corp.intel.com>
 <CAJ3xEMj8zmqj_3=ms9CXxrFVmmk7ZHHtcPXGJcAO24n1U_MSiQ@mail.gmail.com>
 <2807E5FD2F6FDA4886F6618EAC48510E11082B44@CRSMSX101.amr.corp.intel.com>
 <20150519192141.GS18675@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150519192141.GS18675-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiA+IE4/Pz8/P3I/P3k/Pz8/Yj9YPz/Hp3Y/Xj8p3rp7Lm4/Kz8/Pz97Pz/Zmj97YXk/HcqH2pk/
LGoNPz9mPz8/aD8/P3o/Hj93Pz8/DQo+IA0KPiA/Pz9qOit2Pz8/dz9qP20/Pz8/DT8/Pz96Wis/
Pz8/P92iaiI/PyENCj4gDQo+IERvZXMgYW55b25lIGVsc2UgZXZlciB3b25kZXIgd2hhdCB0aGlz
IGdhcmJhZ2UgaXMgb24gc29tZSBvZiB0aGUNCj4gbWVzc2FnZXMgZnJvbSBAaW50ZWwgZm9sa3M/
DQoNCkkgYmVsaWV2ZSBpdCdzIHNvbWUgd2VpcmQgZm9ybWF0dGluZyBvZjoNCg0KPiBUbyB1bnN1
YnNjcmliZSBmcm9tIHRoaXMgbGlzdDogc2VuZCB0aGUgbGluZSAidW5zdWJzY3JpYmUgbGludXgt
cmRtYSIgaW4NCj4gdGhlIGJvZHkgb2YgYSBtZXNzYWdlIHRvIG1ham9yZG9tb0B2Z2VyLmtlcm5l
bC5vcmcNCj4gTW9yZSBtYWpvcmRvbW8gaW5mbyBhdCAgaHR0cDovL3ZnZXIua2VybmVsLm9yZy9t
YWpvcmRvbW8taW5mby5odG1sDQoNCkkgaGF2ZSBubyBpZGVhIHdoeSB3ZSBnZXQgaXQuICBJIHNl
bmQvcmVjZWl2ZSBpbiBwbGFpbiB0ZXh0LiANCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
