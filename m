From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 for-next 2/7] IB/core: Add support for idr types
Date: Thu, 30 Mar 2017 09:53:16 -0600
Message-ID: <20170330155316.GA19074@obsidianresearch.com>
References: <1489939145-125246-1-git-send-email-matanb@mellanox.com>
 <1489939145-125246-3-git-send-email-matanb@mellanox.com>
 <20170329151028.GD2586@obsidianresearch.com>
 <CAAKD3BD328+Ykq_LcMojTObew6A1UQ0qs_g5m_qaLYUww=NuDw@mail.gmail.com>
 <20170329222744.GA30605@obsidianresearch.com>
 <CAAKD3BCjwGpaNmnK2rff5F2MZdiNV3f8kbi0xy5_MSP9OiKpcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BCjwGpaNmnK2rff5F2MZdiNV3f8kbi0xy5_MSP9OiKpcA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 30, 2017 at 06:42:12PM +0300, Matan Barak wrote:
> Yeah, I guess both are ok. I tend to like symmetrical approaches, but
> I don't have a strong objection
> to go with needs_kfree_rcu if you really prefer that.

I think it reads a bit better and there are two fewer branches on
lookup

> > Since it is lookup_get the caller always has to call uobj_put on any
> > failure, and that does fput for fds. No problem?
> >
> 
> Not necessarily. For example, lookup_get could fail because it can't
> find a valid object.  In that case, you have no object to
> put. However, I'll just put a type->lookup_put in the release path,
> so we could move that into the shared code.

Sure, something like that

> We don't have a release memory functions - we got rid of them awhile ago.
> However, when you detach a driver based fd object, and the release
> file_operations of that
> fd points to driver code. You could get a nasty exception if you try
> to close that file
> after unbinding the context because the module was unloaded.

Remember that fops holds a module lock on the functions inside struct
file_operations.

We must ensure that our functions in struct file_operations never call
through to a driver after detach is called.

So, no messing with modules should be needed..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
