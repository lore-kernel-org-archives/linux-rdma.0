From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH v1 ib-next 0/3] IB core uverbs support for leagacy
 commands
Date: Wed, 30 Dec 2015 10:25:31 +0200
Message-ID: <20151230082531.GG17694@leon.nu>
References: <1447178410-15360-1-git-send-email-eli@mellanox.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447178410-15360-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 08:00:07PM +0200, Eli Cohen wrote:
> Hi Doug,
> 
> this patcheset is addresses comments from the community. Specifically if the verbs is not supported by a hardware driver, we return -EOPNOTSUPP.
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

Doug,
I remember that you experienced the issues with your email setup and I
wonder if this patchset was left behind.
https://patchwork.kernel.org/patch/7591731/
https://patchwork.kernel.org/patch/7591741/
https://patchwork.kernel.org/patch/7591751/

It is important patchset which enables create_qp_ex() interface
for already merged patches.

Thanks.

> 
> -- 
> 2.6.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
