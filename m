From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V5 00/12] Move RoCE GID management to IB/Core
Date: Wed, 10 Jun 2015 21:57:27 -0600
Message-ID: <20150611035727.GA16599@obsidianresearch.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE5D17@ORSMSX109.amr.corp.intel.com>
 <55769561.8000300@mellanox.com>
 <5577FAFB.8020205@mellanox.com>
 <20150610150010.GA11243@obsidianresearch.com>
 <557852EE.5030107@mellanox.com>
 <20150610184954.GA26404@obsidianresearch.com>
 <1433984788.71666.78.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433984788.71666.78.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 10, 2015 at 09:06:28PM -0400, Doug Ledford wrote:

> People tend to push the "patches should be small, self contained,
> incremental" ideal.  In some cases, that gets carried to an extreme.  In
> this case, patch 1 introduces one side of the locking and patch 3 and 5
> introduce the other halves.

I already did spot check patches 3 and 5 for exactly that. They add
other uses of RCU, but they appear to be totally different -
objectional for style reasons, but probably not incorrect.

For instance the rcu lock grabs in patch 3 and 5 are protecting the
call to netdev_master_upper_dev_get_rcu in patch 10. 'get_netdev' is
more correctly called 'get_netdev_rcu' in this design. (as I said, this
placement of rcu_read_lock is ugly).

.. and just searching through the patches for 'rcu' to write this, I
noticed this:

+void ib_enum_roce_ports_of_netdev(roce_netdev_filter filter,
[..]
+	down_read(&lists_rwsem);
+	list_for_each_entry_rcu(dev, &device_list, core_list)
+	     ib_dev_roce_ports_of_netdev(dev, filter, filter_cookie, cb,
+					    cookie);
+	up_read(&lists_rwsem);

Should't call list_for_each_entry_rcu under a rwsem, this is just left over
from the old locking regime...

> > I think you've got the right basic idea for a cleanup series here. It
> > is time to buckle down and execute it well.
> 
> Except that this isn't really a cleanup, and calling it that clouds the
> issue.

Well, I've been asking for a cleanup .. The entire goal is to make
things more reviewable and a no-functional-change cleanup would sure
help that..

> it. But that's not the case.  The new core code implements everything
> that the two drivers do, and then some more.

I'd be interested to see a list of the 'some more' included in the
patch comments, I didn't look with a fine toothed comb, but not much
functional stood out to me...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
