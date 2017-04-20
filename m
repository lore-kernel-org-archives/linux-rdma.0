From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/29] IB/mlx: Fine-tuning for several function
 implementations
Date: Thu, 20 Apr 2017 16:37:34 -0400
Message-ID: <1492720654.3041.16.camel@redhat.com>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1935365a-bd7c-461e-6a84-0c5d3a501fff-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, 2017-02-18 at 21:45 +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> Date: Sat, 18 Feb 2017 21:34:32 +0100
> 
> Several update suggestions were taken into account
> from static source code analysis.

I've dropped this entire series.  If you want me to consider it, you
need to respin it with the following changes:

1) Put all similar corrections in a single patch.  If you are replacing
a sizeof() usage with a safer sizeof() usage, then I don't want one
patch per replacement, I want one patch for all replacements.

2) Use reasonable git commit messages.  "Improve another" is never a
reasonable commit message because it implicitly refereces another git
commit message.  Unless this is a fix for a previous commit, all commit
messages should be standalone.

3) Keep your git commit message subject lines within the recommended
size.  You have many that are too long.  As trivial as all of these
changes are, I'm not going to go fixup 29 commit messages to take them.

4) Make sure to preserve the reviewed-by tags on the resubmission.

> Markus Elfring (29):
>   Use kcalloc() in mlx4_ib_alloc_pv_bufs()
>   Improve another size determination in mlx4_ib_alloc_pv_bufs()
>   Improve another size determination in mlx4_ib_alloc_demux_ctx()
>   Improve another size determination in alloc_pv_object()
>   Fix a typo in a comment line
>   Delete three unnecessary return statements
>   Split a condition check in handle_slaves_guid_change()
>   Delete an unnecessary check before the function call "kfree" in
> free_pv_object()
>   Move an assignment out of a check in forward_trap()
>   Enclose 15 expressions for the sizeof operator by parentheses
>   Use kmalloc_array() in three functions
>   Enclose 17 expressions for the sizeof operator by parentheses
>   Split a condition check in five functions
>   Delete an unnecessary variable in __mlx4_ib_query_gid()
>   Delete an unnecessary return statement in do_slave_init()
>   Improve another size determination in do_slave_init()
>   Improve another size determination in mlx4_ib_add()
>   Delete an unnecessary variable initialisation in mlx4_ib_add()
>   Delete an unnecessary variable assignment in mlx4_ib_add()
>   Delete an error message for a failed memory allocation in
> mlx4_ib_add()
>   Delete unnecessary braces in mlx4_ib_add()
>   Use kmalloc_array() in alloc_proxy_bufs()
>   Improve size determinations in create_qp_common()
>   Delete unwanted spaces behind usages of the sizeof operator
>   Add spaces for better code readability
>   Enclose 14 expressions for the sizeof operator by parentheses
>   Use kmalloc_array() in create_kernel_qp()
>   Less function calls in create_kernel_qp() after error detection
>   Use kmalloc_array() in create_srq_kernel()
> 
>  drivers/infiniband/hw/mlx4/mad.c  |  72 ++++++++--------
>  drivers/infiniband/hw/mlx4/main.c | 164 ++++++++++++++++++++------
> ----------
>  drivers/infiniband/hw/mlx4/qp.c   | 173 +++++++++++++++++++---------
> ----------
>  drivers/infiniband/hw/mlx5/qp.c   |  66 ++++++++++-----
>  drivers/infiniband/hw/mlx5/srq.c  |   5 +-
>  5 files changed, 261 insertions(+), 219 deletions(-)
> 
-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
