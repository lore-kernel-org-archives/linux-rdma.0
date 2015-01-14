From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 05/20] IB/mad: Change cast in rcv_has_same_class
Date: Wed, 14 Jan 2015 08:11:58 +0200
Message-ID: <54B608AE.5040900@mellanox.com>
References: <1421082672-22588-1-git-send-email-ira.weiny@intel.com>
 <1421082672-22588-6-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421082672-22588-6-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/12/2015 7:10 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Save dereference and clarifies that rcv_has_same_class can process both IB and
> OPA MADs.

I don't see any clarification below... something missing here?

>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>   drivers/infiniband/core/mad.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index 66b3940..819b794 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -1750,7 +1750,7 @@ static int is_rmpp_data_mad(struct ib_mad_agent_private *mad_agent_priv,
>   static inline int rcv_has_same_class(struct ib_mad_send_wr_private *wr,
>   				     struct ib_mad_recv_wc *rwc)
>   {
> -	return ((struct ib_mad *)(wr->send_buf.mad))->mad_hdr.mgmt_class ==
> +	return ((struct ib_mad_hdr *)(wr->send_buf.mad))->mgmt_class ==
>   		rwc->recv_buf.mad->mad_hdr.mgmt_class;
>   }
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
