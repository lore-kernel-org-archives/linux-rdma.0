From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH ib-next 0/3] IB core uverbs support for leagacy commands
Date: Thu, 19 Nov 2015 23:56:36 +0200
Message-ID: <20151119215636.GA92526@x-vnc01.mtx.labs.mlnx>
References: <1446745208-17733-1-git-send-email-eli@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1446745208-17733-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 05, 2015 at 07:40:05PM +0200, Eli Cohen wrote:
> Hi Doug,
> 
> this patcheset is addresses comments from both Jason and Yann.
> 
> Eli
> 
> Eli Cohen (3):
>   IB/core: Avoid duplicate code
>   IB/core: IB/core: Allow legacy verbs through extended interfaces
>   IB/core: Modify conditional on ucontext existence
> 
>  drivers/infiniband/core/uverbs_main.c | 70 +++++++++++++++++------------------
>  1 file changed, 34 insertions(+), 36 deletions(-)
>

Hi Doug,
 
this patch set has been reviewe the community and we came to an
agreement. When are you planning to apply them. We have pending
fucntionality that we want to push which relies on them.
 
Moreover, there have been patches for libibverbs sent by Eran
Ben-Elisha a while ago which were also sent a while ago. We need those
so I can update libmlx5 as well and have new functionality available.
 
Thanks,
Eli
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
