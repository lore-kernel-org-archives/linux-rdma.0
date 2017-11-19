From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-next 28/31] IB/cm: Fix avoid sleep while spin lock is
 held
Date: Sun, 19 Nov 2017 11:48:44 +0000
Message-ID: <BN3PR07MB257842EBF13CCC3458B7AD97F82D0@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-29-leon@kernel.org>
 <BN3PR07MB2578DF2F9081ED97D5A4351EF82D0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171119105211.GW18825@mtr-leonro.local>
 <CAJ3xEMgjE-MyeBSem=35Bn+JM401z3q7HOTb_eiXyAJuS=X=NA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgjE-MyeBSem=35Bn+JM401z3q7HOTb_eiXyAJuS=X=NA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBObyEgVGhpcyBpcyBDTSBMQVAgKHNlZSBJQlRBIHNwZWMgY2guIDEyKQ0KDQpHb3QgaXQuIFRo
YW5rcy4NCg0KUmFtDQoNCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
