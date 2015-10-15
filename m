From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-cm] IB/core: Fix use after free of ifa
Date: Thu, 15 Oct 2015 11:53:10 -0600
Message-ID: <20151015175310.GA17519@obsidianresearch.com>
References: <1444910463-5688-1-git-send-email-matanb@mellanox.com>
 <1444910463-5688-2-git-send-email-matanb@mellanox.com>
 <561FE452.3050304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <561FE452.3050304-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 15, 2015 at 01:37:22PM -0400, Doug Ledford wrote:

> Now, you've put an rcu_read_lock on ndev instead.  And you're no longer
> seeing the race.  However, does taking the rcu_read_lock on ndev
> actually protect the ifa list on ndev

It looks OK, the free side for using call_rcu - though I'm not quite
sure why for_ifa isn't using rcu_dereference...

> And even if the rcu_read_lock is for sure safe in terms of accessing the
> ifa list, these changes may have just introduced a totally new bug that
> your QE tests haven't exposed but might exist none the less.

This event driven design is super complex/frail, if it actually
doesn't work, it should probably be changed to a level based system.

- Record incoming events indicating a change in ip list has happened
  for an ib device, Schedule a task to refresh the list
- Refresh task holds rtnl locks and builds a list of IP addresses associated
  with the ib device. This is atomic with user changes to the IP list.
- Drops locks and then directly synchs the discovered list above with
  the device's record of associated IPs. (ie run set intersection)

It is much less subtle than hoping all the async event driven stuff
in here works out, probably a lot less code too.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
