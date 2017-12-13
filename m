From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-rc 4/6] RDMA/vmw_pvrdma: Use refcount_dec_and_test to
 avoid warning
Date: Wed, 13 Dec 2017 09:12:49 -0700
Message-ID: <20171213161249.GA16920@ziepe.ca>
References: <20171208233049.GB23239@ziepe.ca>
 <20171211183314.GA20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171211201421.GD27709@ziepe.ca>
 <20171211215936.GC20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171211221425.GA7551@ziepe.ca>
 <20171212171300.GD20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171212185530.GB16603@ziepe.ca>
 <20171213000815.GE20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171213022031.GE16603@ziepe.ca>
 <20171213090702.GF20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171213090702.GF20684-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 13, 2017 at 01:07:02AM -0800, Bryan Tan wrote:

> > > And not that it makes it right, but I did notice that mlx4 uses the
> > > same pattern as what I've done here [1].
> > 
> > Ah, this is good, I was trying to find something like it. Kees
> > approves so I have no problem taking your patch.
> > 
> > Though you might want to reflect on if using a completion is better
> > than a wait_event.. Not immediately clear to me.
> 
> Oof, thanks for pointing that out. There's a problem here it seems:
> 0. refcount for a resource is 2 after entering an event handler
> 1. refcount_dec_and_test gets called by the resource destroy
> 2. refcount_dec_and_test gets called by the resource event handler
> 3. resource destroy call checks the condition in wait_event and
>    proceeds to free the resource
> 4. resource event handler calls wake_up() on free'd resource

Yes I agree. I knew it looked funny :)

Please resend

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
