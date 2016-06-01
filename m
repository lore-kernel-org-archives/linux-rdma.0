From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Avoid large frame size warning
Date: Wed, 1 Jun 2016 10:36:14 -0400
Message-ID: <20160601143613.GD20762@phlsvsds.ph.intel.com>
References: <1464681276-6494-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464681276-6494-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 31, 2016 at 10:54:36AM +0300, Leon Romanovsky wrote:
>From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
>When CONFIG_FRAME_WARN is set to 1024 bytes, which is useful to find
>stack consumers, we get a warning in hfi1 driver.
>
>drivers/infiniband/hw/hfi1/affinity.c: In function
>???hfi1_get_proc_affinity???:
>drivers/infiniband/hw/hfi1/affinity.c:415:1: warning: the frame size of
>1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>
>This change removes unneeded buf[1024] declaration and usage.
>
>Fixes: f48ad614c100 ("IB/hfi1: Move driver out of staging")
>Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>---

Acked-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
