From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ConnectX-3 on non-coherent AARCH64 system
Date: Fri, 10 Mar 2017 10:06:26 -0700
Message-ID: <20170310170626.GE22960@obsidianresearch.com>
References: <b01684b6-ba4a-65cc-ea20-b578e1e2fa2e@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b01684b6-ba4a-65cc-ea20-b578e1e2fa2e-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 09, 2017 at 04:59:40PM -0700, Stephen Warren wrote:

> However, when I run the same test on a (non-cache-coherent) AArch64 (ARMv8)
> machine (Cortex-A57, NVIDIA Tegra), the application does not work. In
> particular, ivc_poll_cq() returns -2 when the application waits for an
> ibv_post_send/recv() to complete.

User space verbs are not supported on non-cache-coherent architectures
for kernel bypass adapters and probably never will be.

Ideally the kernel would not create the uverbs device for DMA drivers
on such architectures.. Is there a kernel API to detect cache
incoherence?

> than e.g. the kernel filling in the CQ), and there don't appear to be any
> cache invalidation operations anywhere in libmlx4 (I'm not even sure if
> cache manipulation is possible from user-space on ARM). I also
> couldn't find

Precisely.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
