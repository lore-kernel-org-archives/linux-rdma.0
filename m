From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 28/31] IB/cm: Fix avoid sleep while spin lock is held
Date: Sun, 19 Nov 2017 13:06:00 +0200
Message-ID: <CAJ3xEMgjE-MyeBSem=35Bn+JM401z3q7HOTb_eiXyAJuS=X=NA@mail.gmail.com>
References: <20171114125218.20477-1-leon@kernel.org> <20171114125218.20477-29-leon@kernel.org>
 <BN3PR07MB2578DF2F9081ED97D5A4351EF82D0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171119105211.GW18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171119105211.GW18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 19, 2017 at 12:52 PM, Leon Romanovsky wrote:
> On Sun, Nov 19, 2017 at 08:42:17AM +0000, Amrani, Ram wrote:

>> Pardon my ignorance, but what is LAP?

> It should be LAG.

No! This is CM LAP (see IBTA spec ch. 12)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
