From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/sa: Restrict SA Netlink to admin users
Date: Tue, 11 Aug 2015 12:26:37 -0400
Message-ID: <20150811162636.GA31742@phlsvsds.ph.intel.com>
References: <1438895310-6087-1-git-send-email-ira.weiny@intel.com> <55C8407C.6060103@mellanox.com> <20150810215829.GA12260@phlsvsds.ph.intel.com> <20150811053810.GA13314@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150811053810.GA13314-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 10, 2015 at 11:38:10PM -0600, Jason Gunthorpe wrote:
> On Mon, Aug 10, 2015 at 05:58:30PM -0400, ira.weiny wrote:
> 
> > Furthermore, the check in netlink_bind also uses the socket namespace to
> > restrict the use of multicast.  This plus my checks should allow an admin to
> > place the SA proxy (ibacm in our test cases) in an alternate network namespace
> > if they so desire.  But this is independent to the namespace which may be used
> > for data applications.
> 
> I think Haggai is on to something, there is certainly a problem here,
> that netlink_bind will let a namespace subscribe is a certainly a
> problem for what Haggai is working on.

Ok, After thinking about this more I agree.  Haggai has a point about the arp
tables.  Like I said I'm not a namespace expert.

> 
> For now, I think, only root (or CAP_ whatever) in the init namespace
> should have access to this feature. Not sure how to check that.

For these 2 checks it is easy to change to netlink_capable instead of
netlink_net_capable.

> 
> Even allowing a namespace to subscribe is problematic because it will
> cause timeouts to hit.. Not sure what to do about that..


Ok, I look into how to deal with the netlink_bind.  I _think_ this may require
the RDMA netlink to provide a custom bind call.  :-(

> 
> Also, why the incremental patch? The original isn't ready for mainline
> without the message validation stuff..

Mainly because Kaike was on vacation and I was not sure what Doug would prefer.
Kaike and I have discussed a couple of changes he had queued up so we will need
a v9 so we will merge this into his next v9 submission.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
