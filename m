From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/9] Remove HAVE_VALGRIND_MEMCHECK_H/INCLUDE_VALGRIND
Date: Fri, 30 Sep 2016 09:49:15 -0700
Message-ID: <718270d3-8b35-e283-5a50-966877f09b50@sandisk.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1475182076-5411-3-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475182076-5411-3-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/29/2016 01:47 PM, Jason Gunthorpe wrote:
> The cmake build system guarantees that valgrind/memcheck.h is present.
> If the system does not have it, or valgrind is disabled, then it is
> replaced with a dummy header full of empty stubs.
>
> Thus all the copy&paste boiler plate is consolidated into buildlib.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  buildlib/config.h.in               |  4 ----
>  libibcm/src/cm.c                   | 11 +----------
>  libibumad/src/umad.c               | 14 +-------------
>  libibverbs/src/ibverbs.h           | 14 +-------------
>  libmlx4/src/mlx4.h                 | 18 +-----------------
>  libmlx5/src/mlx5.h                 | 18 +-----------------
>  libmthca/src/mthca.h               | 18 +-----------------
>  librdmacm/src/cma.h                | 11 +----------
>  srp_daemon/srp_daemon/srp_daemon.h |  5 -----
>  9 files changed, 7 insertions(+), 106 deletions(-)

For the srp_daemon changes:

Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
