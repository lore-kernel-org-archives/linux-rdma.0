From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v5 3/8] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Tue, 23 Jan 2018 10:58:48 -0700
Message-ID: <20180123175848.GK30670@ziepe.ca>
References: <20180122125119.26419-1-leon@kernel.org>
 <20180122125119.26419-4-leon@kernel.org>
 <20180123175433.GI30670@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180123175433.GI30670-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 23, 2018 at 10:54:33AM -0700, Jason Gunthorpe wrote:
> On Mon, Jan 22, 2018 at 02:51:14PM +0200, Leon Romanovsky wrote:
> > +	mutex_lock(&dev->res.mutex);
> > +	hash_del_rcu(&res->node);
> > +	mutex_unlock(&dev->res.mutex);
> > +
> > +	res->valid = false;
> > +
> > +	if (res->task)
> > +		put_task_struct(res->task);
> > +	synchronize_srcu(&dev->res.srcu);
> > +}
> 
> This locking is wrong..

Actually, just don't use RCU.

We can't afford to call synchronize_srcu in the destroy() path of
every object and the netlink user is not critical enough to bother
optimizing the read side.

Replace the rcu and the mutex with a simple rwlock.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
