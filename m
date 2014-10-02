From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: ib_ipoib: CSUM support in connected mode
Date: Thu, 2 Oct 2014 16:00:46 +0300
Message-ID: <20141002130045.GA3592@yuval-lab>
References: <20140914184621.GA4283@yuval-lab>
 <CAJ3xEMhEzdyzcAufQU--VbM7aoAzsw7wV2i_i=kjcS9PbdC0Tw@mail.gmail.com>
 <20140915185557.GA17422@yuval-lab>
 <5417DD0F.9090201@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5417DD0F.9090201-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 16, 2014 at 09:47:43AM +0300, Or Gerlitz wrote:
> 
> On the post you wrote "[...] resolve the issue by removing the physically contiguous memory requirement using Scatter/Gather feature that exists in Linux".
> 
> I assume you refer to NETIF_F_SG, right? so your claim is that Linux will not effectively use the driver ability to serve SG skbs unless the driver also advertizes (say) NETIF_F_IP_CSUM?!
Or,
Correct me if i'm wrong here but i didn't saw any handling of fragmented skb in driver.
The current implementation dma map only skb->data where in fragmented skb there is a need to dma map all frags, right?
> 
> I thought it's the other way around -- that is supporting checksum offloading is useless unless SG is supported. Can you provide pointer into the network stack code/documentation that supports your claim?
> Or.
> 
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
