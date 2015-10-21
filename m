From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 for-next 1/7] IB/core: Extend ib_uverbs_create_qp
Date: Wed, 21 Oct 2015 17:52:07 +0300
Message-ID: <5627A697.5020908@mellanox.com>
References: <1445436042-27616-1-git-send-email-eranbe@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445436042-27616-1-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 21/10/2015 17:00, Eran Ben Elisha wrote:
> ib_uverbs_ex_create_qp follows the extension verbs
> mechanism. New features (for example, QP creation flags
> field which is added in a downstream patch) could used
> via user-space libraries without breaking the ABI.
> 
> Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Hi Doug,
> This is a fix for the first patch of "Add support for multicast loopback
> prevention to mlx4"
> Changes from v2:
> 	remove comp_mask check in create_qp based on Haggai's comment
> 
>  drivers/infiniband/core/uverbs.h      |   1 +
>  drivers/infiniband/core/uverbs_cmd.c  | 254 +++++++++++++++++++++++++---------
>  drivers/infiniband/core/uverbs_main.c |   1 +
>  include/uapi/rdma/ib_user_verbs.h     |  26 ++++
>  4 files changed, 217 insertions(+), 65 deletions(-)
> 

Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
