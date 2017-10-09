From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/7] IB/srpt: Change default behavior from using SRQ to
 not using SRQ
Date: Mon, 09 Oct 2017 12:56:45 -0400
Message-ID: <1507568205.46071.46.camel@redhat.com>
References: <20171006214243.11296-1-bart.vanassche@wdc.com>
         <20171006214243.11296-4-bart.vanassche@wdc.com>
         <20171008100317.GR25829@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171008100317.GR25829-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-10-08 at 13:03 +0300, Leon Romanovsky wrote:
> On Fri, Oct 06, 2017 at 02:42:39PM -0700, Bart Van Assche wrote:
> > Although the non-SRQ mode needs more resources that mode has three
> > advantages over SRQ:
> > - It works with all RDMA adapters, even those that do not support
> >   SRQ.
> > - Posting WRs and polling WCs does not trigger lock contention
> >   because only one thread at a time accesses a WR or WC queue in
> >   non-SRQ mode.
> > - The end-to-end flow control mechanism is used.
> > 
> > From the IB spec:
> > 
> >     C9-150.2.1: For QPs that are not associated with an SRQ, each
> > HCA
> >     receive queue shall generate end-to-end flow control credits.
> > If
> >     a QP is associated with an SRQ, the HCA receive queue shall not
> >     generate end-to-end flow control credits.
> > 
> > Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> > ---
> >  drivers/infiniband/ulp/srpt/ib_srpt.c | 130
> > +++++++++++++++++++++++++---------
> >  drivers/infiniband/ulp/srpt/ib_srpt.h |   4 ++
> >  2 files changed, 99 insertions(+), 35 deletions(-)
> > 
> > diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c
> > b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > index 6cf95ad870cc..a21b7a96635c 100644
> > --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> > +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > @@ -75,11 +75,19 @@ module_param(srp_max_req_size, int, 0444);
> >  MODULE_PARM_DESC(srp_max_req_size,
> >  		 "Maximum size of SRP request messages in
> > bytes.");
> > 
> > +static bool use_srq;
> > +module_param(use_srq, bool, S_IRUGO | S_IWUSR);
> > +MODULE_PARM_DESC(use_srq, "Whether or not to use SRQ");
> > +
> 
> It is a little bit strange to ask from user to decide if his adapter
> supports SRQ or not.
> 
> It should be automatically.

I think Bart's intent is that the driver not use SRQ as the default
behavior even if the adapter supports it, so querying the adapter for
support and enabling it if it exists would not achieve his desired
result.  This would then be used to override that behavior.  Is that
correct Bart?

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
