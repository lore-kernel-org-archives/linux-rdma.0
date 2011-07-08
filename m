From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/4] infiniband-diags: properly resolve node guids
Date: Fri, 8 Jul 2011 15:50:46 -0600
Message-ID: <20110708215046.GB10216@obsidianresearch.com>
References: <20110705120815.3cc7d59b.weiny2@llnl.gov>
 <4E1779CE.9030502@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4E1779CE.9030502-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 08, 2011 at 05:42:38PM -0400, Hal Rosenstock wrote:

> Should the request just be a GET rather than GET_TABLE and avoid this
> check ? I don't think multiple nodes can register with same Node GUID,
> can they ? Also, I think it makes eliminates this check and the missing
> 0 check.

Multiport HCAs should (and do..) show up with multiple node
records. There is one node record per end port, not per node. This is
why using node GUID as an end port identifier is a bad choice.

However, you could use GET and look at the return code to disambiguate
no records/one record/many records.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
