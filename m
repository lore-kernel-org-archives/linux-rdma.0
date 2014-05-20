From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 0/3] RDMA/core: iWARP Port Mapper Overview
Date: Tue, 20 May 2014 08:45:17 -0500
Message-ID: <001801cf7431$bc6ad050$354070f0$@opengridcomputing.com>
References: <20140326220718.GA8784@TENIKOLO-MOBL1> <CAL1RGDWNr53rXY_o2X7R76aVHtAH_EnK6DZk19N5fGoW1pOAdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWNr53rXY_o2X7R76aVHtAH_EnK6DZk19N5fGoW1pOAdQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "'Lacombe, John S'" <john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On
> Behalf Of Roland Dreier
> Sent: Monday, May 19, 2014 8:10 PM
> To: Tatyana Nikolova
> Cc: Lacombe, John S; Steve Wise; Sean Hefty; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 0/3] RDMA/core: iWARP Port Mapper Overview
> 
> On Wed, Mar 26, 2014 at 3:07 PM, Tatyana Nikolova
> <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > 1) The IWPM functionality, common for both iWarp drivers (nes and cxgb4)
> >    is refactored from the drivers source files and is moved to new shared
> >    files in infiniband/core which are compiled as part of the iw_cm module.
> 
> 
> So I'm looking to include this for 3.16.  One question: I assume
> unpatched iwarp drivers (eg cxgb3) continue to work as before?  In
> other words they don't get the new port mapper support but at least
> they don't regress?
> 

Hey Roland,

cxgb3<->cxgb3 would behave as before; no regression.  cxgb3<->cxgb4/nes would interoperate only if the port mapping service is disabled on the cxgb4/nes nodes.  

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
