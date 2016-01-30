From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 10/22] IB/srpt: Do not complain about initiator names
 without leading "0x"
Date: Fri, 29 Jan 2016 17:57:16 -0800
Message-ID: <56AC187C.8090907@sandisk.com>
References: <56ABF16E.7070006@sandisk.com> <56ABF26F.4010509@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56ABF26F.4010509-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

(added Nic to CC-list)

On 01/29/16 15:14, Bart Van Assche wrote:
> Only log an error message if neither the lookup with leading "0x"
> nor the lookup without leading "0x" succeeds.
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Fixes: f246c941549c ("ib_srpt: Convert acl lookup to modern get_initiator_node_acl usage")
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srpt/ib_srpt.c | 17 ++++++-----------
>   1 file changed, 6 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index b46e8d7..d892736 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -2042,7 +2042,6 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
>   	struct se_node_acl *se_acl;
>   	u32 it_iu_len;
>   	int i, ret = 0;
> -	unsigned char *p;
>
>   	WARN_ON_ONCE(irqs_disabled());
>
> @@ -2200,7 +2199,6 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
>   			be64_to_cpu(*(__be64 *)(ch->i_port_id + 8)));
>
>   	pr_debug("registering session %s\n", ch->sess_name);
> -	p = &ch->sess_name[0];
>
>   	ch->sess = transport_init_session(TARGET_PROT_NORMAL);
>   	if (IS_ERR(ch->sess)) {
> @@ -2210,18 +2208,15 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
>   		goto destroy_ib;
>   	}
>
> -try_again:
> -	se_acl = core_tpg_get_initiator_node_acl(&sport->port_tpg_1, p);
> +	se_acl = core_tpg_get_initiator_node_acl(&sport->port_tpg_1,
> +						 &ch->sess_name[0]);
> +	/* If no match, retry without leading '0x'. */
> +	if (!se_acl)
> +		se_acl = core_tpg_get_initiator_node_acl(&sport->port_tpg_1,
> +							 &ch->sess_name[2]);
>   	if (!se_acl) {
>   		pr_info("Rejected login because no ACL has been"
>   			" configured yet for initiator %s.\n", ch->sess_name);
> -		/*
> -		 * XXX: Hack to retry of ch->i_port_id without leading '0x'
> -		 */
> -		if (p == &ch->sess_name[0]) {
> -			p += 2;
> -			goto try_again;
> -		}
>   		rej->reason = cpu_to_be32(
>   				SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
>   		transport_free_session(ch->sess);
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
