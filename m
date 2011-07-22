From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/3] infiniband-diags: libibnetdisc Allow a DR Path
 partial fabric query starting at a CA
Date: Fri, 22 Jul 2011 11:29:46 -0600
Message-ID: <20110722172945.GP18090@obsidianresearch.com>
References: <20110720161655.1ed38052.weiny2@llnl.gov>
 <20110720233451.GL18090@obsidianresearch.com>
 <4E297949.2000607@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4E297949.2000607-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 22, 2011 at 09:21:13AM -0400, Hal Rosenstock wrote:
> On 7/20/2011 7:34 PM, Jason Gunthorpe wrote:
> > Also, there is a bug, you can't DLID route to the local HCA and then
> > use that as a source of a DR path, even though intuitively that should
> > work.
> 
> Just the local xCA or any xCA ?

Well both, but I was under the impression that latter was specified
behavior, but I haven't looked it up.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
