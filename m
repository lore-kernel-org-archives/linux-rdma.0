From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/4] libibmad: Distinguish timed out from other errors
Date: Sat, 9 Apr 2011 11:12:39 -0600
Message-ID: <20110409171239.GA4372@obsidianresearch.com>
References: <4DA07983.8060308@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4DA07983.8060308-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Apr 09, 2011 at 11:21:39AM -0400, Hal Rosenstock wrote:
> 
> Add error field like errno to ib_rpc_t structure
> In mad_rpc code, make sure error is cleared and
> in _do_madrpc, set ETIMEDOUT.
> 
> error field could also be used to distinguish other errors if needed.

This looks like it breaks the ABI since callers using functions that
accept ib_rpc_t are expected to allocate the ib_rpc_t struct
themselves.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
