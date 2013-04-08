From: Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Fail post send command on error recovery
Date: Mon, 08 Apr 2013 10:51:13 -0300
Message-ID: <5162CB51.3080600@linux.vnet.ibm.com>
References: <1364496315-7588-1-git-send-email-klebers@linux.vnet.ibm.com> <CAL1RGDW7wMVmyFhCv-Ei8Mbca-Y9yv+nygzfREU2_TozNSZ60A@mail.gmail.com> <515D79B3.4090808@linux.vnet.ibm.com> <201304041700.40349.jackm@dev.mellanox.co.il> <CAJZOPZ+dgtQRX_sfcDc=aSOW553Twi0oqNjREeminQ2tnZeEmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+dgtQRX_sfcDc=aSOW553Twi0oqNjREeminQ2tnZeEmQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/04/2013 06:45 PM, Or Gerlitz wrote:
> 
> Kleber , as for the 1st problem, which kernel consumers are hanging
> for ever on their CQs? IPoIB is giving up after sometime e.g see in
> ipoib_ib.c "assume the HW is wedged and just free up all our pending
> work requests"
> 

Or, I don't have a very comprehensive testcase to stress most part of
the IB stack during error recovery, but during my tests the kernel
consumer that are still hanging is the ib_sa module, mcast_remove_one()
is waiting for the port completion queue:

INFO: task eehd:4689 blocked for more than 30 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
eehd            D 0000000000000000     0  4689      2 0x00010000
Call Trace:
[c0000000fba83190] [0000000000000001] 0x1 (unreliable)
[c0000000fba83360] [c000000000016188] .__switch_to+0x140/0x268
[c0000000fba83410] [c000000000674f28] .__schedule+0x570/0x8f0
[c0000000fba836b0] [c000000000675bc4] .schedule_timeout+0x334/0x3c8
[c0000000fba837c0] [c000000000674738] .wait_for_common+0x1c0/0x238
[c0000000fba838a0] [d000000002ca230c] .mcast_remove_one+0xfc/0x168 [ib_sa]
[c0000000fba83940] [d000000002bc4f60] .ib_unregister_device+0x78/0x170
[ib_core]
...

Or rdma_cm waiting for the cma_dev completion:

Call Trace:
[c0000000f8fc70f0] [0000000000000001] 0x1 (unreliable)
[c0000000f8fc72c0] [c000000000016188] .__switch_to+0x140/0x268
[c0000000f8fc7370] [c000000000674f28] .__schedule+0x570/0x8f0
[c0000000f8fc7610] [c000000000675bc4] .schedule_timeout+0x334/0x3c8
[c0000000f8fc7720] [c000000000674738] .wait_for_common+0x1c0/0x238
[c0000000f8fc7800] [d000000002f835b0] .cma_process_remove+0x170/0x1a8
[rdma_cm]
[c0000000f8fc78b0] [d000000002f8366c] .cma_remove_one+0x84/0xb0 [rdma_cm]
[c0000000f8fc7940] [d000000002c34f60] .ib_unregister_device+0x78/0x170
[ib_core]
...


Thanks,
kleber

-- 
Kleber Sacilotto de Souza
IBM Linux Technology Center

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
