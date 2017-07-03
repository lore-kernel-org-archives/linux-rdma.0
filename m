From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rfc 0/3] Expose cpu mapping hints to a nvme target port
Date: Mon, 3 Jul 2017 12:52:18 +0300
Message-ID: <8a5f82d8-e475-5f0e-9110-8b2c68580988@mellanox.com>
References: <1499007694-7231-1-git-send-email-sagi@grimberg.me>
 <b77be367-6cbc-c12c-8135-eddff0aec90e@mellanox.com>
 <e33f16a7-4e1d-7fd6-6d2c-5a5bac450c73@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e33f16a7-4e1d-7fd6-6d2c-5a5bac450c73-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 7/2/2017 8:41 PM, Sagi Grimberg wrote:
>
>> Hi Sagi,
>> Very interesting patchset. You give a lot of power to the user here,
>> we need to hope that he will use it right :).
>
> I don't think so, its equivalent to running an application with a given
> taskset, nothing fancy here...
>
> The straight forward configuration this is targeting is a dual-socket
> system
> where on each node you have one (or more) HCA and some NVMe devices
> (say 4). All this is doing is allowing the user to contain nvme target
> port cpu cores
> to its own numa socket so if on that port only expose the local NVMe
> devices
> DMA traffic won't cross QPI.

Maybe I'm missing something but how do you make sure that all your 
allocations buffers for DMA (of the NVMe + HCA) are done on the same 
socket ?
 From the code I understood that you make sure that the cq is assigned 
to appropriate completion vector according to the port CPUs (given by 
the user) and all the interrupts will be routed to the relevant socket 
(no QPI cross here since the MSI MMIO address is mapped to "local" 
node), but IMO more work is needed to make sure that _all_ the allocated 
buffers/pages are done from the memory assigned to that CPU node (or is 
it something that is done already ?)

>
> While a subsystem is the collection of devices, the port is where I/O
> threads
> really live as they feed of the device IRQ affinity. Especially with SRQ
> which I'll
> be touching soon. The user does indeed need to be aware of all this, but
> if he
> isn't, then he shouldn't touch this setting.
>
>> Do you have some fio numbers to compare w/w.o this series ? also cpu
>> utilization measures are interesting too..
>
> Not really, this is an RFC level code, lightly tested on my VM...
>
> If this is interesting to you I can use some testing if you volunteer ;)

Yes it is. I'll need to find some time slot for this though...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
