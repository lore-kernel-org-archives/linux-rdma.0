From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Fwd: Re: [PATCH] libibmad: To reserve upper 8 bits of tid used
 by solaris SRIOV driver
Date: Thu, 21 Mar 2013 12:45:07 -0600
Message-ID: <20130321184507.GB8044@obsidianresearch.com>
References: <20130320223322.GB30100@obsidianresearch.com>
 <514A3996.601@oracle.com>
 <514A525F.7030706@oracle.com>
 <20130321050709.GA20882@obsidianresearch.com>
 <514B4E17.5020703@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <514B4E17.5020703-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: brendan doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pramod Gunjikar <Pramod.Gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 21, 2013 at 06:14:47PM +0000, brendan doyle wrote:
> Ok so I think we are essentially on the same page...
> 
> >This is already the case, only the lower 32 bits are available for
> >application use, the upper 32 bits are all reserved for the kernel,

> This is not an IB spec defined delineation, but an OF one. Perhaps
> there was some community discussion to architect it this way but it
> is not documented. At the very least this patch should document
> this.

Well, it is how /dev/umad works - IBA does not define the umad api,
Solaris is copying the Linux umad API, so it should work the same..

There is no need to specify the format of the upper 32 bits, it is
kernel specific and has no impact on the application. The kernel
should use those bits as necessary to demux flows between users of
umad, be they processes or VMs.

> So how about modifying the patch such that mad_trid() is something like:

Looks like a reasonable clarification of existing usage to me.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
