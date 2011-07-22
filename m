From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/3] infiniband-diags: libibnetdisc Allow a DR Path
 partial fabric query starting at a CA
Date: Fri, 22 Jul 2011 16:13:49 -0600
Message-ID: <20110722221349.GT18090@obsidianresearch.com>
References: <20110720161655.1ed38052.weiny2@llnl.gov>
 <20110720233451.GL18090@obsidianresearch.com>
 <4E297949.2000607@dev.mellanox.co.il>
 <20110722172945.GP18090@obsidianresearch.com>
 <20110722150049.ba8e592f.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110722150049.ba8e592f.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 22, 2011 at 03:00:49PM -0700, Ira Weiny wrote:

> I agree it would be nice if one could issue a combined path and "scan through"
> any xCA on the fabric.  However, I don't think it is allowed, nor correct to
> do so.

Well, it is explicitly not allowed:

2) If Hop Count is non zero and Hop Pointer is in the range 1  Hop        
   Pointer < Hop Count, this SMI is an intermediate hop in the directed   
   route portion of the path. If the node is not a switch, the SMI shall  
   discard the SMP, otherwise the SMI shall alter the contents of the
   directed route SMP as follows:

> Even if this is considered vague there would be a problem a xCA was allowed.

That sort of behavior is explicitly disallowed in other cases, like
reading port info.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
