From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: ib_ipoib: CSUM support in connected mode
Date: Tue, 16 Sep 2014 09:47:43 +0300
Message-ID: <5417DD0F.9090201@mellanox.com>
References: <20140914184621.GA4283@yuval-lab> <CAJ3xEMhEzdyzcAufQU--VbM7aoAzsw7wV2i_i=kjcS9PbdC0Tw@mail.gmail.com> <20140915185557.GA17422@yuval-lab>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140915185557.GA17422@yuval-lab>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 9/15/2014 9:55 PM, Yuval Shaia wrote:
> On Mon, Sep 15, 2014 at 05:47:19PM +0300, Or Gerlitz wrote:
>> >On Sun, Sep 14, 2014 at 9:46 PM, Yuval Shaia<yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>  wrote:
>>> >>By default, IPoIB-CM driver uses 64k MTU. Larger MTU gives better performance.
>>> >>This MTU plus overhead puts the memory allocation for IP based packets at 32 4k pages (order 5),
>>
>> >So if we make sure that the advertized netdevice MTU is 64K minus that
>> >over head we're back to order four
>> >allocation and problem is solved?   note that RFC 4755 makes sure that
>> >the MTU is negotiated in both directions,
>> >so it can have any value, specifically 64K - that epsilon which will
>> >hopefully make you happy
> Interesting point. But please note that in any case, when not using scatter/gather we force the allocation of large contiguous physical memory.

On the post you wrote "[...] resolve the issue by removing the physically contiguous memory requirement using Scatter/Gather feature that exists in Linux".

I assume you refer to NETIF_F_SG, right? so your claim is that Linux will not effectively use the driver ability to serve SG skbs unless the driver also advertizes (say) NETIF_F_IP_CSUM?!

I thought it's the other way around -- that is supporting checksum offloading is useless unless SG is supported. Can you provide pointer into the network stack code/documentation that supports your claim?
  
Or.

  


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
