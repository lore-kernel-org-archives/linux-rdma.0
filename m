From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH rfc 0/3] Expose cpu mapping hints to a nvme target port
Date: Mon, 3 Jul 2017 13:14:42 +0300
Message-ID: <68e79fb7-38f1-aa1b-c0bf-88631df46f61@grimberg.me>
References: <1499007694-7231-1-git-send-email-sagi@grimberg.me>
 <b77be367-6cbc-c12c-8135-eddff0aec90e@mellanox.com>
 <e33f16a7-4e1d-7fd6-6d2c-5a5bac450c73@grimberg.me>
 <8a5f82d8-e475-5f0e-9110-8b2c68580988@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8a5f82d8-e475-5f0e-9110-8b2c68580988-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> Maybe I'm missing something but how do you make sure that all your 
> allocations buffers for DMA (of the NVMe + HCA) are done on the same 
> socket ?
>  From the code I understood that you make sure that the cq is assigned 
> to appropriate completion vector according to the port CPUs (given by 
> the user) and all the interrupts will be routed to the relevant socket 
> (no QPI cross here since the MSI MMIO address is mapped to "local" 
> node), but IMO more work is needed to make sure that _all_ the allocated 
> buffers/pages are done from the memory assigned to that CPU node (or is 
> it something that is done already ?)

The allocator takes care of that for us (if it can...). By assigning
the completion vector we will run the IO thread from the corresponding
cpu, then in turn, page allocation will attempt to grab one which is
local to the running numa node and only if not available will fall back
to the far numa node...

However, in-capsule page allocation is not numa aware. We could also
modify to alloc_pages_node in case we have a clear numa node indication,
but we can defer that to a later stage...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
