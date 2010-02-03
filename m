From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: mlx4 kernel parameters
Date: Wed, 3 Feb 2010 14:42:00 +0200
Message-ID: <20100203124200.GA30979@mtls03>
References: <6978b4af1002030202h431384c4ub6de0313e51c4500@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6978b4af1002030202h431384c4ub6de0313e51c4500-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rui Machado <ruimario-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 03, 2010 at 11:02:07AM +0100, Rui Machado wrote:
> 
> on trying to change the mlx4_core parameters log_num_mtt and
> log_num_mpt to 21 and 18 respectively, I see the following message:

The MPTs and MTTs are managed by bitmap allocators within the mlx4
core drivers. These allocators requires physically contigous memory
whose size is proportional to the number of controlled resources.
Since Linux does has a limitation on the order of allocated contigous
memory, the allocator might fail to initialize.
> 
> mlx4_core 0000:07:00.0: Failed to initialize memory region table, aborting.
> 
> The objective is to be able to memory-pin large portion of a machine
> with lots of RAM, otherwise we are limited to about 16GB.
> Does anyone has an hint or thoughts on what might be the problem?

For this you can use the parameter log_mtts_per_seg which allows to
define the granulairty of MTTs allocated. So for a given number of MTT
segements (which is what the allocator really allocates), you control
more registered memeory.
As for the number of MPTs, please don't use too large numbers - you
usually don't have to increase this number. 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
