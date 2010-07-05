From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH V1 2/4]  New RAW_PACKET QP  type definition
Date: Mon, 05 Jul 2010 08:53:40 -0500
Message-ID: <4C31E3E4.8020508@opengridcomputing.com>
References: <4C308E07.7050903@senin.name> <4C3092ED.6000701@senin.name> <4C3095CB.2000205@senin.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C3095CB.2000205-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aleksey Senin <alex-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yiftah Shahar <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <Alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Aleksey Senin wrote:
> The following patches add a new QP type named RAW_PACKET.
>
> This type of QP is used in Ethernet environment and intended for
> creation of a whole packet, including L2 headers, from userspace.
>
> Reserve a place for future XRC patch in order to be sure that OFED
> kernel ABI will not broken when XRC and RAW patches will be accepted
> to upstream kernel.
>
> Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/verbs.c |    4 ++--
>  include/rdma/ib_verbs.h         |    3 ++-
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index af7a8b0..b04b419 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -326,8 +326,8 @@ EXPORT_SYMBOL(ib_create_qp);
>  
>  static const struct {
>  	int			valid;
> -	enum ib_qp_attr_mask	req_param[IB_QPT_RAW_ETHERTYPE + 1];
> -	enum ib_qp_attr_mask	opt_param[IB_QPT_RAW_ETHERTYPE + 1];
> +	enum ib_qp_attr_mask	req_param[IB_QPT_RAW_PACKET + 1];
> +	enum ib_qp_attr_mask	opt_param[IB_QPT_RAW_PACKET + 1];
>  } qp_state_table[IB_QPS_ERR + 1][IB_QPS_ERR + 1] = {
>  	[IB_QPS_RESET] = {
>  		[IB_QPS_RESET] = { .valid = 1 },
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index ecf098a..555165b 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -562,7 +562,8 @@ enum ib_qp_type {
>  	IB_QPT_UC,
>  	IB_QPT_UD,
>  	IB_QPT_RAW_IPV6,
> -	IB_QPT_RAW_ETHERTYPE
> +	IB_QPT_RAW_ETHERTYPE = 7,
> +	IB_QPT_RAW_PACKET = 8
>  };
>  
>  enum ib_qp_create_flags {
>   

Would it be better to just put the XRC QP type enum in with this patch? 

What is the reason for XRC not being upstream?

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
