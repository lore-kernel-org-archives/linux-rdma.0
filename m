From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [GIT PULL] please pull infiniband.git
Date: Tue, 19 Nov 2013 19:25:10 +0200
Message-ID: <528B9EF6.3090708@mellanox.com>
References: <1384800032-14755-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1384800032-14755-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 18/11/2013 20:40, Roland Dreier wrote:
> Hi Linus,
>
> Please pull from
>
>      git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus
>
> ----------------------------------------------------------------
>
> Main batch of InfiniBand/RDMA changes for 3.13:
>
>   - Re-enable flow steering verbs with new improved userspace ABI
>   - Fixes for slow connection due to GID lookup scalability
>   - IPoIB fixes
>   - Many fixes to HW drivers including mlx4, mlx5, ocrdma and qib
>   - Further improvements to SRP error handling
>   - Add new transport type for Cisco usNIC

Hi Roland, can you spare few words on how you see the RoCE IP based Addressing V5 series? we have addressed the concerns you raised re compatibility and also simplified the series to avoid using uverbs extensions @ this point, anything else left there?

This series is pre-step for submitting SRIOV support to RoCE (the code is ready!) and hence no Cloud RoCE upstream solution for VMs before we nail that, it deserves your response. I have posted reply on Sep 17th, to your concerns http://marc.info/?l=linux-rdma&m=137945099714426&w=2 and didn't really hear from you. So went ahead and addressed the feedback as we captured it.

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
