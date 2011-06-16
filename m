From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: saquery; reuse
 dump_one_mcmember_record function
Date: Thu, 16 Jun 2011 15:59:46 -0600
Message-ID: <20110616215946.GA7112@obsidianresearch.com>
References: <20110616111024.fde795bc.weiny2@llnl.gov>
 <4DFA6D60.9070609@dev.mellanox.co.il>
 <20110616144636.4d2483fb.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110616144636.4d2483fb.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 16, 2011 at 02:46:36PM -0700, Ira Weiny wrote:

> "need"; I guess not.  But I thought it was odd that the information was different for the 2 query methods.  There is nothing in the documentation or help output which indicates the output would be different.
> 
> That said I do see what you mean regarding the amount of data
> returned.  I figured most users were probably grepping this output
> anyway, as on a large fabric both methods return a sizable amount of
> data.

One is supposed to return de-duplicated information about the groups
that exist, the other was supposed to show group member information.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
