From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 01/10] IB/core: Change provider's API of
 create_cq to be extendible
Date: Wed, 20 May 2015 13:01:33 -0600
Message-ID: <20150520190133.GL28496@obsidianresearch.com>
References: <1431869786-6308-1-git-send-email-ogerlitz@mellanox.com>
 <1431869786-6308-2-git-send-email-ogerlitz@mellanox.com>
 <20150519184535.GJ18675@obsidianresearch.com>
 <CAAKD3BAXBPgkFp=bmeDNoj6QbAXoHMGt_nv+LHCE09g5=nyPGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BAXBPgkFp=bmeDNoj6QbAXoHMGt_nv+LHCE09g5=nyPGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 20, 2015 at 07:41:17PM +0300, Matan Barak wrote:
> On Tue, May 19, 2015 at 9:45 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Sun, May 17, 2015 at 04:36:17PM +0300, Or Gerlitz wrote:
> >> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>
> >> Add a new ib_cq_init_attr structure which contains the
> >> previous cqe (minimum number of CQ entries) and comp_vector
> >> (completion vector) in addition to a new flags field.
> >> All vendors' create_cq callbacks are changed in order
> >> to work with the new API.
> >>
> >> This commit does not change any functionality.
> >
> > This seems reasonable to me.
> >
> >> @@ -1341,6 +1341,7 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
> >>       struct ib_uverbs_event_file    *ev_file = NULL;
> >>       struct ib_cq                   *cq;
> >>       int                             ret;
> >> +     struct ib_cq_init_attr attr = {.cqe = 0};
> >
> > This doesn't seem necessary, it is unconditionally set below:
> >
> 
> Almost :) It also zeros (default value) all other fields. I could
> replace it with a memset if it's clearer.

All fields are set unconditionally, so there is no need to init.

= {};

Is idomatic to zero a structure.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
