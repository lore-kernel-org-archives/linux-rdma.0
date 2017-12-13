From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-rc 4/6] RDMA/vmw_pvrdma: Use refcount_dec_and_test to
 avoid warning
Date: Tue, 12 Dec 2017 19:20:31 -0700
Message-ID: <20171213022031.GE16603@ziepe.ca>
References: <20171208185818.GA28514@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171208190218.GA744@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171208233049.GB23239@ziepe.ca>
 <20171211183314.GA20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171211201421.GD27709@ziepe.ca>
 <20171211215936.GC20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171211221425.GA7551@ziepe.ca>
 <20171212171300.GD20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171212185530.GB16603@ziepe.ca>
 <20171213000815.GE20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171213000815.GE20684-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 12, 2017 at 04:08:16PM -0800, Bryan Tan wrote:
> On Tue, Dec 12, 2017 at 11:55:30AM -0700, Jason Gunthorpe wrote:

> Hm, it's still not clear to me what expectations are not followed here,
> and how you're differentiating 'refcount' from 'usecnt'.

A refcount is something that has exactly one 'refcount_dec_and_test'
that then goes on to 'free' the thing being refcountedt. It never has
a wait queue.

A usecnt is something that has an async path that waits for all users
to stop using it then 'frees' it. It always includes a wait
queue.

> And not that it makes it right, but I did notice that mlx4 uses the
> same pattern as what I've done here [1].

Ah, this is good, I was trying to find something like it. Kees
approves so I have no problem taking your patch.

Though you might want to reflect on if using a completion is better
than a wait_event.. Not immediately clear to me.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
