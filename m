From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 7/9] IB/core: generic RDMA READ/WRITE API
Date: Tue, 1 Mar 2016 08:21:04 +0100
Message-ID: <20160301072104.GA32603@lst.de>
References: <1456784410-20166-1-git-send-email-hch@lst.de> <1456784410-20166-8-git-send-email-hch@lst.de> <56D4C615.5010202@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56D4C615.5010202-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 29, 2016 at 04:28:37PM -0600, Steve Wise wrote:
>> +		ret = rdma_rw_init_mr_wrs(ctx, qp, port_num, sg, sg_offset,
>> +				remote_addr, rkey, dir);
>
> At some point I would like the iWARP IO to do no-mr for WRITE/dma_nents == 
> 1, and WRITE/dma_nents <= max_send_sge for the device. I think this will 
> help smaller iSER/NVMEF READ IOPs.  I'm testing this out now on the NVMEF 
> code, which is slightly different.  If it proves out to better the 
> performance, I'll post a follow-on patch...

Yes, this should work fine.  My plan was to have the bare API in place
for now and then allow HCA drivers to fine tune the idea eventually.
My idea was to have a threshold set by the driver from where to start
registering the memory for case where it not required (WRITE on all HCAs,
READ for !iWarp).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
