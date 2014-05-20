From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] RDMA/core: iWARP Port Mapper Overview
Date: Mon, 19 May 2014 18:10:24 -0700
Message-ID: <CAL1RGDWNr53rXY_o2X7R76aVHtAH_EnK6DZk19N5fGoW1pOAdQ@mail.gmail.com>
References: <20140326220718.GA8784@TENIKOLO-MOBL1>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140326220718.GA8784@TENIKOLO-MOBL1>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Lacombe, John S" <john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 26, 2014 at 3:07 PM, Tatyana Nikolova
<Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 1) The IWPM functionality, common for both iWarp drivers (nes and cxgb4)
>    is refactored from the drivers source files and is moved to new shared
>    files in infiniband/core which are compiled as part of the iw_cm module.


So I'm looking to include this for 3.16.  One question: I assume
unpatched iwarp drivers (eg cxgb3) continue to work as before?  In
other words they don't get the new port mapper support but at least
they don't regress?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
