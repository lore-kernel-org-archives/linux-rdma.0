From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH RFC v2 0/2] libibverbs memory barrier fixes
Date: Sun, 22 May 2016 11:16:39 +0000
Message-ID: <AM4PR05MB1699629C06857BF8DBF1B525D94D0@AM4PR05MB1699.eurprd05.prod.outlook.com>
References: <20160520200053.6983AE0B9D@smtp.ogc.us>
 <3ffd3089-ede9-aebf-4781-2e012bc65252@redhat.com>
 <016901d1b2d6$113b4ee0$33b1eca0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <016901d1b2d6$113b4ee0$33b1eca0$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

We'll be testing those patches as well.

-
Thanks,
Noa Osherovich  |  SW Engineer  |  Tel: 074-7236018


-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
Sent: Friday, May 20, 2016 11:28 PM
To: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: [PATCH RFC v2 0/2] libibverbs memory barrier fixes

> > This is v2 of the ARM64 mb* support, plus an additional patch to 
> > fail compiles if there is no platform implementation of the memory barriers.
> > I've included the 2nd patch because I think it is important to not 
> > assume any default barrier implementation.  Getting it wrong can 
> > result in data corruption.
> >
> > Changes since V1:
> >
> > Put the RFC tag back on because I want to retest this series.
> >
> > Implemented the ARM64 memory barrier macros from scratch using the 
> > AMD reference docs.
> >
> > Added 2nd patch to fail compiles if no mb* macros exist for the platform.
> >
> > Steve Wise (2):
> >   libibverbs: add ARM64 memory barrier macros
> >   Fail compiles if no platform specific memory barriers exist
> >
> >  include/infiniband/arch.h |   15 +++++++++------
> >  1 files changed, 9 insertions(+), 6 deletions(-)
> >
> 
> Please remember to use --thread=shallow when sending patch emails 
> using git send-email (which is what I assume you did).
>

Will do.  I use git format-patch.  I added -t, but that apparently does nothing.
:)  I'll use --thread=shallow next time.

 
> Let me know how the testing comes out.  The patches look fine to me 
> (thanks for adding the second one, it's the right thing to do).
>

It will be next week, and I'll send out a final version of the series then.  

Thanks!

Steve



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
