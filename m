From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC PATCH 00/28] INFINIBAND NETWORK BLOCK DEVICE (IBNBD)
Date: Fri, 24 Mar 2017 13:15:26 +0100
Message-ID: <20170324121526.GF3571@linux-x5ow.site>
References: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1490352343-20075-1-git-send-email-jinpu.wangl-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, mail-99BIx50xQYGELgA04lAiVw@public.gmane.org, Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 24, 2017 at 11:45:15AM +0100, Jack Wang wrote:
> From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> 
> This series introduces IBNBD/IBTRS kernel modules.
> 
> IBNBD (InfiniBand network block device) allows for an RDMA transfer of block IO
> over InfiniBand network. The driver presents itself as a block device on client
> side and transmits the block requests in a zero-copy fashion to the server-side
> via InfiniBand. The server part of the driver converts the incoming buffers back
> into BIOs and hands them down to the underlying block device. As soon as IO
> responses come back from the drive, they are being transmitted back to the
> client.
> 
> We design and implement this solution based on our need for Cloud Computing,
> the key features are:
> - High throughput and low latency due to:
> 1) Only two rdma messages per IO
> 2) Simplified client side server memory management
> 3) Eliminated SCSI sublayer
> - Simple configuration and handling
> 1) Server side is completely passive: volumes do not need to be
> explicitly exported
> 2) Only IB port GID and device path needed on client side to map
> a block device
> 3) A device can be remapped automatically i.e. after storage
> reboot
> - Pinning of IO-related processing to the CPU of the producer
> 
> For usage please refer to Documentation/IBNBD.txt in later patch.
> My colleague Danil Kpnis presents IBNBD in Vault-2017 about our design/feature/
> tradeoff/performance:
> 
> http://events.linuxfoundation.org/sites/events/files/slides/IBNBD-Vault-2017.pdf
> 

Hi Jack,

Sorry to ask (I haven't attented the Vault presentation) but why can't you use
NVMe over Fabrics in your environment? From what I see in your presentation
and cover letter, it provides all you need and is in fact a standard Linux and
Windows already have implemented.

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
