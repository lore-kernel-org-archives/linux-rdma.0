From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 7/9] IB/core: generic RDMA READ/WRITE API
Date: Mon, 29 Feb 2016 15:12:55 -0800
Message-ID: <56D4D077.9020706@sandisk.com>
References: <1456784410-20166-1-git-send-email-hch@lst.de>
 <1456784410-20166-8-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456784410-20166-8-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/29/2016 02:20 PM, Christoph Hellwig wrote:
> +static inline u32 rdma_rw_max_sge(struct ib_device *dev,
> +		enum dma_data_direction dir)
> +{
> +	return dir == DMA_TO_DEVICE ?
> +		dev->attrs.max_sge : dev->attrs.max_sge_rd;
> +}

Hi Christoph,

Are you aware that using max_sge is safe for some but not for all HCAs? 
See also http://thread.gmane.org/gmane.linux.drivers.rdma/22043.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
