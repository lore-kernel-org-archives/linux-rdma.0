From: "Ismail, Mustafa" <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/uverbs: Check port number supplied by user verbs
 cmds
Date: Tue, 11 Jul 2017 23:21:07 +0000
Message-ID: <5C5647B5F4794941BAAC07CF28785CBC33E4CB61@fmsmsx101.amr.corp.intel.com>
References: <23a56bbd03a2b5b585e2de35b1fc6f8bac53aa9a.1499441641.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <23a56bbd03a2b5b585e2de35b1fc6f8bac53aa9a.1499441641.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Polak <alexpo-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Boris Pismenny <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH] RDMA/uverbs: Check port number supplied by user verbs
> cmds
> 
> Upstream commit id in the rdma.git tree: 5ecce4c9b17b
> 
> The ib_uverbs_create_ah() ind ib_uverbs_modify_qp() calls receive the port
> number from user input as part of its attributes and assumes it is valid.
> Down on the stack, that parameter is used to access kernel data structures.
> If the value is invalid, the kernel accesses memory it should not.  To prevent
> this, verify the port number before using it.
> 
> BUG: KASAN: use-after-free in ib_uverbs_create_ah+0x6d5/0x7b0 Read of
> size 4 at addr ffff880018d67ab8 by task syz-executor/313
> 
> BUG: KASAN: slab-out-of-bounds in modify_qp.isra.4+0x19d0/0x1ef0 Read
> of size 4 at addr ffff88006c40ec58 by task syz-executor/819
> 
> Fixes: 67cdb40ca444 ("[IB] uverbs: Implement more commands")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.2-v4.9
> Cc: <security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Alex Polak <alexpo-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Boris Pismenny <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> 
> Modified from upstream commit: helper function rdma_is_port_valid does
> not exist in these kernel versions, so use manual comparisons instead.
> 
>  drivers/infiniband/core/uverbs_cmd.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/infiniband/core/uverbs_cmd.c
> b/drivers/infiniband/core/uverbs_cmd.c
> index cb3f515a2285..01e3a37b0aef 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -2342,6 +2342,10 @@ ssize_t ib_uverbs_modify_qp(struct
> ib_uverbs_file *file,
>  	if (copy_from_user(&cmd, buf, sizeof cmd))
>  		return -EFAULT;
> 
> +	if (cmd.port_num < rdma_start_port(ib_dev) ||
> +	    cmd.port_num > rdma_end_port(ib_dev))
> +		return -EINVAL;
> +
With this check for valid port number, ucma_modify_qp_sqd() and ucma_modify_qp_err () in rdma-core may fail since qp_attr.port_num is not initialized.

Regards,

Mustafa
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
