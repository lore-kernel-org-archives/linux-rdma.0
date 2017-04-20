From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/26] InfiniBand-OCRDMA: Fine-tuning for several
 function implementations
Date: Thu, 20 Apr 2017 16:43:19 -0400
Message-ID: <1492720999.3041.18.camel@redhat.com>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fc421509-4069-da8a-b308-60b49ea91ada-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-03-08 at 13:30 +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> Date: Wed, 8 Mar 2017 13:14:56 +0100
> 
> Several update suggestions were taken into account
> from static source code analysis.

I've dropped this entire series.  If you want me to consider it, you
need to respin it with the following changes:

1) Put all similar corrections in a single patch.  If you are replacing
a sizeof() usage with a safer sizeof() usage, then I don't want one
patch per replacement, I want one patch for all replacements.

2) Use reasonable git commit messages.  "Improve another" is never a
reasonable commit message because it implicitly refereces another git
commit message.  Unless this is a fix for a previous commit, all commit
messages should be standalone.

3) Keep your git commit message subject lines within the recommended
size.  You have many that are too long.  As trivial as all of these
changes are, I'm not going to go fixup 29 commit messages to take them.

4) Make sure to preserve the reviewed-by tags on the resubmission.

> Markus Elfring (26):
>   Use kcalloc() in ocrdma_create_eqs()
>   Use kcalloc() in ocrdma_mbx_alloc_pd_range()
>   Improve size determinations in ocrdma_mbx_get_dcbx_config()
>   Delete unnecessary variable initialisations in
> ocrdma_mbx_get_dcbx_config()
>   Improve another size determination in ocrdma_mbx_query_qp()
>   Improve another size determination in ocrdma_alloc_pd_pool()
>   Improve another size determination in ocrdma_mbx_get_ctrl_attribs()
>   Improve size determinations in ocrdma_mbx_rdma_stats()
>   Improve another size determination in ocrdma_mq_cq_handler()
>   Improve another size determination in ocrdma_init_emb_mqe()
>   Delete unnecessary braces
>   Adjust ten checks for null pointers
>   Use kcalloc() in ocrdma_alloc_resources()
>   Improve another size determination in ocrdma_add()
>   Delete an error message for a failed memory allocation in
> ocrdma_add()
>   Adjust a null pointer check in ocrdma_alloc_resources()
>   Use kmalloc_array() in ocrdma_create_srq()
>   Use kcalloc() in three functions
>   Improve another size determination in ocrdma_alloc_mr()
>   Delete an unnecessary variable assignment in ocrdma_alloc_mr()
>   Improve another size determination in ocrdma_create_srq()
>   Returning only value constants in ocrdma_resize_cq()
>   Delete an unnecessary variable in ocrdma_dealloc_pd()
>   One jump label less in ocrdma_alloc_ucontext_pd()
>   Delete unnecessary braces
>   Adjust further ten checks for null pointers
> 
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |  88 ++++++++++------
> -----
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  19 +++--
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 118 ++++++++++++----
> ------------
>  3 files changed, 100 insertions(+), 125 deletions(-)

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
