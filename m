From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Linux DMA address
Date: Mon, 2 Jul 2012 16:53:52 +0300
Message-ID: <4FF1A7F0.10208@mellanox.com>
References: <OF0BBAC7B2.370E3DEF-ONC1257A2F.003DED12-C1257A2F.00407B62@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF0BBAC7B2.370E3DEF-ONC1257A2F.003DED12-C1257A2F.00407B62-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/2/2012 2:44 PM, Klaus Wacker wrote:
> [...] So whats the nature of the returned DMA address of ib_dma_map_single and can we
> assume that it is the same value on different devices on one system?

Currently, over all IB drivers/devices except for ipath and qib, 
ib_dma_map_single is just plain dma_map_single, so your questions 
relates directly to the Linux DMA mapping API (and BTW - the answer is 
YES, in the general case you must use a DMA address you were provided 
when calling dma_map_single with device being X only for transactions 
carried over X). For those devices that hack ib_dma_map_single, it might 
be possible to use address provided from device X over device Y, but 
this is a hack, and I would strongly recommend not to have it in you code.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
