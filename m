From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/3 fixed] infiniband-diags: Allow specification of an
 mkey on the command line
Date: Fri, 9 Mar 2012 14:02:59 -0700
Message-ID: <20120309210259.GB32353@obsidianresearch.com>
References: <1331065551.10889.14.camel@auk75.llnl.gov>
 <1331072283.17729.16.camel@auk75.llnl.gov>
 <4F59FEDB.7050605@dev.mellanox.co.il>
 <20120309120931.609233da.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120309120931.609233da.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 09, 2012 at 12:09:31PM -0800, Ira Weiny wrote:

> > Why do all these tools need mkey ? Isn't it only tools that require SMPs
> > needing this support ?
> 
> Unfortunately many of the diags issue SMP's when they should not.
> To keep them working in the short term with mkey's this patch will
> have to be applied until an audit can be performed of every tool.
> You may have noted I already fixed saquery with previous patches.

This is one of the things I fixed in python-rdma ;)

-- 
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>        (780)4406067x832
Chief Technology Officer, Obsidian Research Corp         Edmonton, Canada
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
