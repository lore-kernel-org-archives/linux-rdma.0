From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v3 00/13] Request for Comments on SoftiWarp
Date: Tue, 23 Jan 2018 09:44:45 -0700
Message-ID: <20180123164445.GD30670@ziepe.ca>
References: <20180114223603.19961-1-bmt@zurich.ibm.com>
 <00fd01d39467$9bdde7f0$d399b7d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <00fd01d39467$9bdde7f0$d399b7d0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Bernard Metzler' <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 23, 2018 at 10:31:24AM -0600, Steve Wise wrote:
> > 
> > This patch set contributes a new version of the SoftiWarp
> > driver, as originally introduced Oct 6th, 2017.
> > 
> > Thank you all for the commments on my last submissiom. It
> > was vey helpful and encouraging. I hereby re-send a SoftiWarp
> > patch after taking all comments into account, I hope. Without
> > introducing SoftiWarp (siw) again, let me fast forward
> > to the changes made to the last submission:
> > 
> > 
> > 1. Removed all kernel module parameters, as requested.
> >    I am not completely happy yet with what came out of
> >    that, since parameters like the name of interfaces
> >    siw shall attach to,
> 
> Can configfs be used for this? I don't remember if that was discussed during
> v2 review?  OR, the new rdma command that is part of iproute2 can be
> extended.  It would use netlink messages to do the configuration.  Perhaps
> Leon can comment on that when he gets time.  It could be extended to support
> both rxe and siw.

rdmatool command over rnetlink, supporting both rxe and siw.

The child interface provided by iproute is not really suitable..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
