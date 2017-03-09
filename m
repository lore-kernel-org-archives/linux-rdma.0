From: Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: ConnectX-3 on non-coherent AARCH64 system
Date: Thu, 9 Mar 2017 16:59:40 -0700
Message-ID: <b01684b6-ba4a-65cc-ea20-b578e1e2fa2e@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I have a pair of Mellanox ConnectX-3 cards. I can put these into a pair 
of x86 machines, run an application using libibverbs on each, and 
transfer data without issue.

However, when I run the same test on a (non-cache-coherent) AArch64 
(ARMv8) machine (Cortex-A57, NVIDIA Tegra), the application does not 
work. In particular, ivc_poll_cq() returns -2 when the application waits 
for an ibv_post_send/recv() to complete.

Looking into libmlx4, it seems that the CQ memory content is 
non-sensical; mainly all 0xcccccccc rather than the zero values that 
mlx4_alloc_cq_buf() set it to. I'm not familiar with this HW's CQE 
format, but those values don't seem to match what the code expects. I'm 
pretty sure the HW is writing this data, since the 0xcccccccc value only 
appears after ibv_cmd_create_cq()'s call into the kernel to configure 
the CQ in HW. Can anyone help me track down where that data is coming from?

Perhaps related, I see the CQ memory is allocated via anonymous mmap(), 
which will set up a cached mapping of the allocated pages. I'm not sure 
how this can work given that HW appears to write to these physical pages 
(rather than e.g. the kernel filling in the CQ), and there don't appear 
to be any cache invalidation operations anywhere in libmlx4 (I'm not 
even sure if cache manipulation is possible from user-space on ARM). I 
also couldn't find anything in the kernel mlx4 driver that remaps the CQ 
pages as non-cached in Linux kernel 4.4, but perhaps I just didn't find 
it. Is this library/HW not supported on non-cache-coherent systems, or 
am I missing something obvious?

Note: I'm using the libibverbs/libmlx4/... packaged in Ubuntu 16.04. I'm 
aware that /usr/include/infiniband/arch.h there is not new enough to 
contain the AArch64 barrier support. However, this issue appears deeper 
than just barriers. Equally, I don't see any relevant difference in how 
the latest libmlx4 source code allocates buffers, so I'm not convinced 
that upgrading all the Infiniband libraries to e.g. the latest git 
version would solve anything for me. However, if there's an expectation 
that an upgrade would help this specific issue, I'm willing to try.

Thanks for any help!

-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
