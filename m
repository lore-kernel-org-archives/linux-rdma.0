From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v5 3/8] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Tue, 23 Jan 2018 15:00:07 -0700
Message-ID: <20180123220007.GA16845@ziepe.ca>
References: <20180122125119.26419-1-leon@kernel.org>
 <20180122125119.26419-4-leon@kernel.org>
 <20180123175433.GI30670@ziepe.ca>
 <20180123175848.GK30670@ziepe.ca>
 <20180123183552.GW1393@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180123183552.GW1393-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 23, 2018 at 08:35:52PM +0200, Leon Romanovsky wrote:

> > Replace the rcu and the mutex with a simple rwlock.
> 
> My initial proposal was SRCU per-res to protect data with rwlock
> per-type to protect lists.

I don't think SRCU per-res helps here. (and the memory overhead would
be shocking, IMHO).

And if the goal is to avoid starvation of destroy from the reader side
I don't think it helps, as you can seriously delay synchronize_srcu()
by hitting the read side regions to force grace period waits.

I think you need a bit more adventure:

// Read side - could be a rwlock
mutex_lock(ibdev->resource_lock)
cur = list_head;
cur->readers++;
mutex_unlock();

[.. do slow stuff, push into the netlink skb ...]

mutex_lock();
cur->readers--;
if (cur->readers == 0)
   wakeup(ibdev->wq);
cur = cur->next
mutex_unlock();

// Destroy side
mutex_lock(ibdev->resource_lock)
wait_event_cmd(ibdev->wq, obj->readers == 0, mutex_unlock(), mutex_lock());
list_del(..);
mutex_unlock();

Which would lock each resource only while being used, and the destroy
will wait only if it conflicts with the ongoing read.

Getting the linked list processing to work properly with this kind of
locking is hard.. The manual wq linked to the lock seems like a
reasonable compromise.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
