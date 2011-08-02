From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb
 routines
Date: Tue, 2 Aug 2011 10:56:52 -0600
Message-ID: <20110802165652.GN18090@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237302123C@ORSMSX101.amr.corp.intel.com>
 <201108011508.06521.jackm@dev.mellanox.co.il>
 <20110802053824.GA23512@obsidianresearch.com>
 <201108021053.05311.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201108021053.05311.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 02, 2011 at 10:53:05AM +0300, Jack Morgenstein wrote:

> These additions would include the new ibv_cmd_xxx functions
> (the core functions reside in src/cmd.c), and new, additional, enum values of
> the form IBV_USER_VERBS_CMD_XXXX, of which the core enum is in file
> include/infiniband/kern_abi.h.

I believe the only case where using an extension would make sense if
it if can be implemented entirely within the low level driver. So you
can't add new ibv_cmd calls to ibverbs, must duplicate them in your
driver, etc.

I'm a little unclear on how the application is going to get the access
enums and other structure definitions, though.. I suppose the low
level driver can install a .h file as well.
 
> Each new third-party package would need such a library.  While this
> will lead to a multiplicity of new libraries (one per addition), the
> core libibverbs package would remain as is.

I definitely don't want to see this..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
