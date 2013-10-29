From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: smatch  warnings on the IB core
Date: Tue, 29 Oct 2013 10:53:49 +0300
Message-ID: <20131029075349.GD20521@mwanda>
References: <526CB685.40607@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <526CB685.40607-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 27, 2013 at 08:45:25AM +0200, Or Gerlitz wrote:
> Hi Dan,
> 
> With the latest smatch I still see these hits on the IB core,
> basically, I would be happy to see the IB stack free from such
> warnings and then we can easily require each new patch not to
> introduce them... can you shed some light on the problem and
> possible solutions?
> 

The first one is because it thinks nonseekable_open() can fail.
If you build the cross function database first:

~/path/to/smatch/smatch_scripts/build_kernel_data.sh

Then the warning should go away.  But building the database takes three
hours on my system.  The database is around 4GB.

The other two are because smatch isn't doing cross function analysis of
locks.  It doesn't see that we take the lock in cma_disable_callback().
I want to add this at some point but I haven't got around to it.

In the end, what I do is I only look at new warnings.  With Smatch, I've
deliberately set it to have more false positives than GCC.  It's always
a tradeoff.

I wish there were a way to carry a list of false positives in the smatch
git tree and filter them out automatically...

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
