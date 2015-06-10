From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V5 00/12] Move RoCE GID management to IB/Core
Date: Wed, 10 Jun 2015 16:01:54 -0600
Message-ID: <20150610220154.GA4391@obsidianresearch.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE5D17@ORSMSX109.amr.corp.intel.com>
 <55769561.8000300@mellanox.com>
 <5577FAFB.8020205@mellanox.com>
 <20150610150010.GA11243@obsidianresearch.com>
 <557852EE.5030107@mellanox.com>
 <20150610184954.GA26404@obsidianresearch.com>
 <CAAKD3BB90iZ98B2ADG+=ZYuEVtLq26a99BEjQCR8U1vzvcG+Gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BB90iZ98B2ADG+=ZYuEVtLq26a99BEjQCR8U1vzvcG+Gw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-iNbyuHi0droAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 10, 2015 at 11:19:03PM +0300, Matan Barak wrote:

> > Sure gid_type is gone, but I didn't say roceve2 specific, I said
> > latent elements. ie I'm assuming reasons for the scary locking are
> > because the ripped out rocev2 code needed it?  And some of the
> > complexity that looks pointless now was supporting ripped out rocev2
> > elements? That is not necessarily bad, but the code had better be good
> > quailty and working..
> 
> Why do you think the locks have anything to do with roce v2?

What else could they be for? The current mlx4 driver doesn't use use
agressive performance locking.

After writing this email, I am of the opinion that the locking should
be simplified to rwsem and mutex, and every use of rcu, READ_ONCE and
seqlock should be ditched.

> > But then I look at the patches, and the very first locking I test out
> > looks wrong. I see call_rcu/synchronize_rcu being used without a
> > single call to rcu_read_lock. So this fails #2 of the RCU review
> > checklist (Seriously? Why am I catching this?)
> >
> > I stopped reading at that point.
> >
> 
> Well, that's easy to explain - write_gid could be called with one of
> roce_gid_table's find API.

That doesn't explain anything.

You can't use call_rcu without also using rcu_dereference and
rcu_read_lock. It doesn't make any sense otherwise.

Your explanation seems confused too, did you reasearch this? Did you
read the RCU checklist? Is this a knee-jerk reply? Please be thoughtfull.

>  find is called and returns a ndev
>  write_gid is called and calls dev_put(ndev)
>  ndev is freed
>  find uses the ndev

Are you trying to say that this rcu is protecting this:

+static int find_gid(struct ib_roce_gid_table *table, const union ib_gid *gid,
+		    const struct ib_gid_attr *val, unsigned long mask)
+{
[..]
+		if (mask & GID_ATTR_FIND_MASK_NETDEV &&
+		    attr->ndev != val->ndev)
+			continue;

That is an unlocked access to a RCU protected value, without
rcu_dereference. Fails two points on the RCU checklist.

Where does it return ndev?

Honestly, since RCU is done wrong, and I'm very suspicious seqlock is
done wrong too, I would *strongly* encourage v6 to have simple
read/write sem and mutex locking and nothing fancy for performance. I
don't want to go round and round on subtle performance locking for a
*cleanup patch*.

There is also this RCU confusion:

+				rcu_read_lock();
+				if (ib_dev->get_netdev)
+					idev = ib_dev->get_netdev(ib_dev, port);

When holding the rcu_read_lock it should be obvious what the RCU
protected data is. There is no way holding it around a driver call
back makes any sense.

The driver should return a held netdev or null.

.. and maybe more, I stopped looking

> By calling the find API in RCU, your ndev is protected.

When implementing locking, identify the data being locked, and
confirm that every possible access to that data follows the required
locking rules. In this case the data being locked is the
table->data_vec[ix].attr.ndev pointer.

It was the very first thing I checked, in the very first patch.

> > I think you've got the right basic idea for a cleanup series here. It
> > is time to buckle down and execute it well. Do an internal mellanox
> > kernel team review of this series. Audit and fix all the locking,
> > evaluate the code growth and design. Audit to confirm there is no
> > functional change that is not documented in a commit message. Tell me
> > v6 is the best effort *team Mellanox* can put forward.
> 
> Jason, I really appreciate your review. If you have any comments, I
> would like to either fix or write you back. This series wasn't sent
> without being looked at by the internal team here.

Well, I am looking at this thinking I don't want to invest time in
searching for things I think your team can find on it's own.

Take a breather, produce v6 very carefully.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
