From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB: fix task hanging on error recovery
Date: Thu, 1 Nov 2012 17:12:32 +0200
Message-ID: <50929160.1000109@mellanox.com>
References: <1350683896-3928-1-git-send-email-klebers@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350683896-3928-1-git-send-email-klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 19/10/2012 23:58, Kleber Sacilotto de Souza wrote:
> During PCI error recovery, the calls to wait_for_completion() in the
> infiniband core path can hang waiting for some tasks that will never
> complete, since the hardware is nonfunctional.
>
> INFO: task eehd:16029 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message.
> eehd            D 0000000000000000  9664 16029   3093 0x00000080
> Call Trace:
> [c0000000af8430e0] [c0000000be05e200] 0xc0000000be05e200 (unreliable)
> [c0000000af8432b0] [c000000000014070] .__switch_to+0x130/0x250
> [c0000000af843360] [c000000000777c5c] .__schedule+0x40c/0x920
> [c0000000af843600] [c000000000775a10] .schedule_timeout+0x210/0x260
> [c0000000af8436e0] [c000000000777658] .wait_for_common+0xf8/0x210
> [c0000000af8437c0] [d000000004113538] .ib_unregister_mad_agent+0x498/0x690 [ib_mad]
> [c0000000af8438c0] [d0000000042c01f4] .ib_sa_remove_one+0xe4/0x180 [ib_sa]
> [c0000000af843970] [d0000000040952e8] .ib_unregister_device+0x78/0x170 [ib_core]
> [c0000000af843a10] [d000000004183290] .mlx4_ib_remove+0x40/0x1f0 [mlx4_ib]
> [c0000000af843ab0] [d000000003f6ab54] .mlx4_remove_device+0xd4/0x110 [mlx4_core]
> [c0000000af843b40] [d000000003f6abfc] .mlx4_unregister_device+0x6c/0xf0 [mlx4_core]
> [c0000000af843be0] [d000000003f6f19c] .mlx4_remove_one+0x10c/0x3a0 [mlx4_core]
> [c0000000af843c80] [d000000003f6f448] .mlx4_pci_err_detected+0x18/0x40 [mlx4_core]
> [c0000000af843d00] [c000000000058a50] .eeh_report_error+0x70/0xe0
> [c0000000af843d90] [c0000000003e4d94] .pci_walk_bus+0xa4/0x140
> [c0000000af843e50] [c000000000058628] .handle_eeh_events+0x1f8/0x480
> [c0000000af843f00] [c000000000058dfc] .eeh_event_handler+0x13c/0x1e0
> [c0000000af843f90] [c00000000002031c] .kernel_thread+0x54/0x70
>
> This patch fixes the issue by replacing the calls to
> wait_for_completion() by wait_for_completion_timeout(), providing a
> timeout of 5 seconds to wait for the normal completion of the task.
>
> Signed-off-by: Kleber Sacilotto de Souza<klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>   drivers/infiniband/core/addr.c        |    2 +-
>   drivers/infiniband/core/cm.c          |    2 +-
>   drivers/infiniband/core/cma.c         |    4 ++--
>   drivers/infiniband/core/iwcm.c        |    2 +-
>   drivers/infiniband/core/mad.c         |    4 ++--
>   drivers/infiniband/core/mad_rmpp.c    |    2 +-
>   drivers/infiniband/core/multicast.c   |    4 ++--
>   drivers/infiniband/core/sa_query.c    |    2 +-

for all the above files, your patch makes sense, since the 
completion/refcount logic
relate to waiting for event that needs to come from the device.

>   drivers/infiniband/core/ucm.c         |    2 +-
>   drivers/infiniband/core/ucma.c        |    2 +-

On these files, as far as I understand this code from quick looking, I'm 
not sure on what
exactly the completion objects protects, Sean?

Or.

>   drivers/infiniband/core/uverbs_main.c |    4 ++--


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
