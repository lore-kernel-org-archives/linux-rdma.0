From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network and
 RDMA subsystem
Date: Mon, 23 Oct 2017 09:42:30 -0600
Message-ID: <20171023154230.GE11952@obsidianresearch.com>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-4-bmt@zurich.ibm.com>
 <027c01d348fa$d3b450f0$7b1cf2d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <027c01d348fa$d3b450f0$7b1cf2d0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Bernard Metzler' <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 19, 2017 at 11:53:45AM -0500, Steve Wise wrote:

> > +#define SIW_MAX_IF 12
> > +static int if_cnt;
> > +static char *iface_list[SIW_MAX_IF] = {[0 ... (SIW_MAX_IF-1)] = '\0'};
> > +module_param_array(iface_list, charp, &if_cnt, 0444);
> > +MODULE_PARM_DESC(iface_list, "Interface list siw attaches to if
> > present");

Also, NAK on this.

I know this is what rxe does, but we shouldn't have allowed that
either.

Add a RDMA-netlink thing to manage siw attach/detatch.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
