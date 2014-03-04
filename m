From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCHv3 net-next 09/31] iw_cxgb4: Treat CPL_ERR_KEEPALV_NEG_ADVICE
 as negative advice.
Date: Tue, 04 Mar 2014 20:48:44 +0300
Message-ID: <531611FC.4000202@cogentembedded.com>
References: <1393936917-25847-1-git-send-email-hariprasad@chelsio.com> <1393936917-25847-10-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1393936917-25847-10-git-send-email-hariprasad@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: Hariprasad Shenai <hariprasad@chelsio.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: davem@davemloft.net, roland@purestorage.com, kumaras@chelsio.com, dm@chelsio.com, swise@opengridcomputing.com, leedom@chelsio.com, santosh@chelsio.com, nirranjan@chelsio.com
List-Id: linux-rdma@vger.kernel.org

On 03/04/2014 03:41 PM, Hariprasad Shenai wrote:

> From: Steve Wise <swise@opengridcomputing.com>

> Based on original work by Anand Priyadarshee <anandp@chelsio.com>.

> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
[...]

> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index 74a2250..c63dfe5 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -1648,6 +1648,15 @@ static inline int act_open_has_tid(int status)
>   	       status != CPL_ERR_ARP_MISS;
>   }
>
> +/* Returns whether a CPL status conveys negative advice.
> + */

    Hm, why not just make this one-line comment? Sorry that I haven't said 
that before.

> +static int is_neg_adv(unsigned int status)
> +{
> +	return status == CPL_ERR_RTX_NEG_ADVICE ||
> +	       status == CPL_ERR_PERSIST_NEG_ADVICE ||
> +	       status == CPL_ERR_KEEPALV_NEG_ADVICE;
> +}
> +
>   #define ACT_OPEN_RETRY_COUNT 2
>
>   static int import_ep(struct c4iw_ep *ep, int iptype, __u8 *peer_ip,

WBR, Sergei
