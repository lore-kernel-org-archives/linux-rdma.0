From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/6] More sparse cleanup
Date: Fri, 07 Apr 2017 12:40:53 -0400
Message-ID: <1491583253.2923.15.camel@redhat.com>
References: <1491518545-14746-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491518545-14746-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-04-06 at 16:42 -0600, Jason Gunthorpe wrote:
> Have rxe, ipath, hfi1 and ocrdma enable sparse in travis.
> 
> The bug sparse noticed in mlx4 sure looks legit and odd it has
> remained
> undetected for so long.
> 
> Jason Gunthorpe (6):
>   rxe: Use libc's IN6_IS_ADDR_V4MAPPED
>   ipath/hfi: Enable sparse from travis
>   ocrdma: Fix missing endian swap in debug print
>   ocrdma: Add sparse annotations
>   mlx4: Fix incorrect masking of g_mlpath_rqpn
>   mlx4: Fix typo in byte swap direction
> 
>  CMakeLists.txt                  | 10 +++++-----
>  providers/mlx4/cq.c             |  4 ++--
>  providers/ocrdma/ocrdma_abi.h   | 39 ++++++++++++++++++++++++++-----
> --------
>  providers/ocrdma/ocrdma_verbs.c | 22 +++++++++++-----------
>  providers/rxe/rxe.c             |  3 +--
>  5 files changed, 45 insertions(+), 33 deletions(-)

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
