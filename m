From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] dapl: Fix segfault while freeing qp
Date: Tue, 29 Sep 2015 15:56:42 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F980A6C8CF@ORSMSX101.amr.corp.intel.com>
References: <1443529774-26431-1-git-send-email-bharat@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443529774-26431-1-git-send-email-bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org" <nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks, applied.

> -----Original Message-----
> From: Bharat Potnuri [mailto:bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org]
> Sent: Tuesday, September 29, 2015 5:30 AM
> To: Davis, Arlin R
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org;
> nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; Bharat Potnuri
> Subject: [PATCH] dapl: Fix segfault while freeing qp
> 
> In function dapls_ib_qp_free(), pointers qp and cm_ptr->cm_id->qp are
> pointing to the same qp structure, initialized in function dapls_ib_qp_alloc().
> The memory pointed by these pointers are freed twice in function
> dapls_ib_qp_free(), using rdma_destroy_qp() for the case _OPENIB_CMA
> defined and then further using ibv_destroy_qp(), causing a segmentation fault
> while freeing the qp. Therefore assigned NULL value to qp to avoid freeing
> illegal memory.
> 
> Fixes: 7ff4f840bf11 ("common: add CM-EP linking to support mutiple CM's and
> proper protection during destruction")
> 
> Signed-off-by: Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> ---
>  dapl/openib_common/qp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/dapl/openib_common/qp.c b/dapl/openib_common/qp.c index
> 527fc1d4c46b..01f91ca2bd83 100644
> --- a/dapl/openib_common/qp.c
> +++ b/dapl/openib_common/qp.c
> @@ -397,6 +397,7 @@ DAT_RETURN dapls_ib_qp_free(IN DAPL_IA * ia_ptr,
> IN DAPL_EP * ep_ptr)  #ifdef _OPENIB_CMA_
>  		rdma_destroy_qp(cm_ptr->cm_id);
>  		cm_ptr->cm_id->qp = NULL;
> +		qp = NULL;
>  #endif
> 
>  #ifdef _OPENIB_MCM_
> --
> 2.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
