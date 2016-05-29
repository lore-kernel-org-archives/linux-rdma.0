From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH V4 for-next 08/10] IB/core: Extend create QP to get
 indirection table
Date: Sun, 29 May 2016 16:11:41 +0300
Message-ID: <574AEA8D.2010909@grimberg.me>
References: <1464006056-19653-1-git-send-email-yishaih@mellanox.com>
 <1464006056-19653-9-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464006056-19653-9-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 23/05/16 15:20, Yishai Hadas wrote:
> Extend create QP to get Receive Work Queue (WQ) indirection table.
>
> QP can be created with external Receive Work Queue indirection table,
> in that case it is ready to receive immediately.
>
>
> Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/core/verbs.c | 19 +++++++++++++++++--
>   include/rdma/ib_verbs.h         |  2 ++
>   2 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 6b548d7..6916d5c 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -754,6 +754,12 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
>   	struct ib_qp *qp;
>   	int ret;
>
> +	if (qp_init_attr->rwq_ind_tbl &&
> +	    (qp_init_attr->recv_cq ||
> +	    qp_init_attr->srq || qp_init_attr->cap.max_recv_wr ||
> +	    qp_init_attr->cap.max_recv_sge))
> +		return ERR_PTR(-EINVAL);
> +

Yishai,

I understand that a qp cannot have indirection table with a srq or a
recv_cq, but can you explain the max_recv_[wr|sge] condition?

Would it make better sense to condition on the QP type?

Other then that,

Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
