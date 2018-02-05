From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/2] net/mlx5: increase async EQ to avoid EQ overrun
Date: Tue, 6 Feb 2018 01:11:41 +0200
Message-ID: <d572b570-0844-e441-19a0-e6804557fb58@mellanox.com>
References: <1517840992-29813-1-git-send-email-maxg@mellanox.com>
 <20180205180904.GB11446@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180205180904.GB11446-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: he
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2/5/2018 8:09 PM, Jason Gunthorpe wrote:
> On Mon, Feb 05, 2018 at 04:29:51PM +0200, Max Gurtovoy wrote:
>> Currently the async EQ has 256 entries only. It might not be big enough
>> for the SW to handle all the needed pending events. For example, in case
>> of many QPs (let's say 1024) connected to a SRQ created using NVMeOF target
>> and the target goes down, the FW will raise 1024 "last WQE reached" events
>> and may cause EQ overrun. Increase the EQ to more reasonable size, that beyond
>> it the FW should be able to delay the event and raise it later on using internal
>> backpressure mechanism.
> 
> If the firmware has an internal backpressure meachanism then why
> would we get a EQ overrun?

FW backpressure mechanism is WIP, that's why we get the overrun.
After consulting with FW team, we conclude that 256 EQ depth is small.
Do you think it's reasonable to allocate 4k entries (256KB of contig 
memory) for async EQ ?

> 
> Do we need to block adding too many QPs to a SRQ as well or something
> like that?

Hard to say. In the storage world, this may lead to a situation that 
initiator X has priority over initiator Y on without any good reason 
(only because X was served before Y)..

> 
> Jason
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
