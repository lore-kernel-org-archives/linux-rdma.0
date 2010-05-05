From: Tziporet Koren <tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ewg] [PATCH] mlx4_core: request MSIX vectors as much as there
 CPU	cores
Date: Wed, 05 May 2010 22:34:07 +0300
Message-ID: <4BE1C82F.4000009@mellanox.co.il>
References: <20100505113047.GA12242@mtldesk030.lab.mtl.com>	<adahbmmpfep.fsf@roland-alpha.cisco.com> <20100505163252.GG15969@obsidianresearch.com>
Reply-To: tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100505163252.GG15969-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/5/2010 7:32 PM, Jason Gunthorpe wrote:
> On Wed, May 05, 2010 at 07:54:54AM -0700, Roland Dreier wrote:
>    
>>   >  The current code requires num_possible_cpus() + 1 MSIX vectors. However,
>>   >  num_possible_cpus() stands for the max number of supported CPUs by the kernel.
>>
>> I believe this is wrong -- num_possible_cpus() is the maximum number of
>> CPUs for the running system, including hotplug.
>>      
> FWIW, I've seen some systems running RH kernels that blow up here
> because they run out of interrupt numbers if you have two IB cards in
> them.
>
> Mainline kernels have a reworked IRQ number allocator and don't have a
> problem, so maybe this is an ofed only patch?
>    
This is not related to OFED
We found it in performance work of our EN (10G) driver

Tziporet
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
