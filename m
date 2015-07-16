From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH] infiniband:cxgb4:Fix concurrent access issue in the function send_mpa_reply
Date: Thu, 16 Jul 2015 09:20:19 -0500
Message-ID: <000301d0bfd2$8b701440$a2503cc0$@opengridcomputing.com>
References: <1437014271-26020-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437014271-26020-1-git-send-email-xerofoify@gmail.com>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Nicholas Krause' <xerofoify@gmail.com>, swise@chelsio.com
Cc: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Nicholas Krause [mailto:xerofoify@gmail.com]
> Sent: Wednesday, July 15, 2015 9:38 PM
> To: swise@chelsio.com
> Cc: dledford@redhat.com; sean.hefty@intel.com; hal.rosenstock@gmail.com; linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] infiniband:cxgb4:Fix concurrent access issue in the function send_mpa_reply
> 
> This fixes a concurrent access issue in the function send_mpa_reply
> when calling the non wrapper function set_state on the structure
> pointer ep's member com due to us not locking the mutex lock for
> this structure pointer and thus avoid concurrent access issues
> by here by using the wrapper version of set_state that properly
> locks the mutex lock for us.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index 3ad8dc7..0b46b99 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -1048,7 +1048,7 @@ static int send_mpa_reply(struct c4iw_ep *ep, const void *pdata, u8 plen)
>  	skb_get(skb);
>  	t4_set_arp_err_handler(skb, NULL, arp_failure_discard);
>  	ep->mpa_skb = skb;
> -	__state_set(&ep->com, MPA_REP_SENT);
> +	state_set(&ep->com, MPA_REP_SENT);
>  	ep->snd_seq += mpalen;
>  	return c4iw_l2t_send(&ep->com.dev->rdev, skb, ep->l2t);
>  }
> --


send_mpa_reply() is called with the ep mutex held.  See c4iw_accept_cr().
