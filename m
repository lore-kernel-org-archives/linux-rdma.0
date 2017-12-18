From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 for-rc 0/8] vmw_pvrdma fixes for 4.15
Date: Mon, 18 Dec 2017 15:04:02 -0800
Message-ID: <20171218230402.GA11564@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
References: <20171214001753.GA9780@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171218182511.GH19070@mellanox.com>
 <20171218214244.GA19558@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171218224519.GI19070@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171218224519.GI19070-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 18, 2017 at 03:45:19PM -0700, Jason Gunthorpe wrote:
> On Mon, Dec 18, 2017 at 01:42:44PM -0800, Bryan Tan wrote:
> > > If you want this in -rc for some reason then you need to send a series
> > > with just those commits, otherwise it will go to -next.
> > 
> > I will send out a series with the following commits:
> > 
> > >   RDMA/vmw_pvrdma: Call ib_umem_release on destroy QP path
> > >   RDMA/vmw_pvrdma: Use refcount_dec_and_test to avoid warning
> > >   RDMA/vmw_pvrdma: Use completion instead of wait queue
> > >   RDMA/vmw_pvrdma: Add UAR SRQ macros in ABI header file
> > 
> > And I will clarify the commit message in the last commit there.
> 
> Okay, you'll need to rebase the reminaing patches on to the for-rc
> patches and send them again.. I would have cherry-picked them
> but the refcounter change created conflicts I didn't want to deal
> with.

Ah okay. Should I send them together now? I was going to wait until
the for-rc bits make it to for-next before sending out the remaining
patches as they wouldn't apply cleanly to for-next right now.

Bryan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
