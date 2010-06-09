From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sa.c: In osm_sa_respond, only fill in attr
 offset if RMPP method
Date: Wed, 9 Jun 2010 15:10:36 +0300
Message-ID: <20100609121036.GC20172@me>
References: <20100603134209.GA12225@comcast.net>
 <20100609054341.GK28549@me>
 <AANLkTilkr6KYG_TVJYwvNl7sZ8XBKmFljktxg8qCA9t9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTilkr6KYG_TVJYwvNl7sZ8XBKmFljktxg8qCA9t9-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Smith-11/JKNsLAEcNCZHLCRkIHg@public.gmane.org, Stan <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06:23 Wed 09 Jun     , Hal Rosenstock wrote:
> >>
> >> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >>  opensm/opensm/osm_sa.c |   12 ++++++++++--
> >>  1 files changed, 10 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
> >> index 0aca81f..8325632 100644
> >> --- a/opensm/opensm/osm_sa.c
> >> +++ b/opensm/opensm/osm_sa.c
> >> @@ -3,6 +3,7 @@
> >>   * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
> >>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
> >>   * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
> >> + * Copyright (c) 2010 HNR Consulting. All rights reserved.
> >>   *
> >>   * This software is available to you under a choice of one of two
> >>   * licenses.  You may choose to be licensed under the terms of the GNU
> >> @@ -454,8 +455,15 @@ void osm_sa_respond(osm_sa_t *sa, osm_madw_t *madw, size_t attr_size,
> >>       /* C15-0.1.5 - always return SM_Key = 0 (table 185 p 884) */
> >>       resp_sa_mad->sm_key = 0;
> >>
> >> -     /* Fill in the offset (paylen will be done by the rmpp SAR) */
> >> -     resp_sa_mad->attr_offset = num_rec ? ib_get_attr_offset(attr_size) : 0;
> >> +#ifdef DUAL_SIDED_RMPP
> >> +     if (resp_sa_mad->method == IB_MAD_METHOD_GETTABLE_RESP ||
> >> +         resp_sa_mad->method == IB_MAD_METHOD_GETMULTI_RESP) {
> >> +#else
> >> +     if (resp_sa_mad->method == IB_MAD_METHOD_GETTABLE_RESP) {
> >> +#endif
> >> +             /* Fill in the offset (paylen will be done by the rmpp SAR) */
> >> +             resp_sa_mad->attr_offset = num_rec ? ib_get_attr_offset(attr_size) : 0;
> >> +     }
> >
> > What is wrong with current implementation?
> 
> It's now needed for the debug version of OpenSM not to assert due to:
> 
> 7fc6cd3037f07190e483a047f17d37b6bebbb2b3
> Author: Smith, Stan <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Date:   Fri May 21 10:49:27 2010 -0700
> 
>     ib_types.h add debug assert
> 
>     Add a debug assert to catch incorrect MAD attr offset size.
>     This proved to be useful in catching incorrect struct sizes as MAD attrs nee
> d to be a multiple of 8 bytes.
> 
>     Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>     Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> 
> as not all SA attributes are multiple of 8 bytes.

Then it seems that such assertion is incorrect and the patch should be
reverted. Right?

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
