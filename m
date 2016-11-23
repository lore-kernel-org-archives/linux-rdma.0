From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 3/7] IB/rxe: Don't update the response PSN unless it's
 going forwards
Date: Wed, 23 Nov 2016 17:04:47 +0200
Message-ID: <0b60628c-6c4a-6782-8047-141d843b48b0@mellanox.com>
References: <1479479809-10798-1-git-send-email-andrew.boyer@dell.com>
 <1479479809-10798-3-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479479809-10798-3-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/18/2016 4:36 PM, Andrew Boyer wrote:
> A client might post a read followed by a send. The partner receives
> and acknowledges both transactions, posting an RCQ entry for the
> send, but something goes wrong with the read ACK. When the client
> retries the read, the partner's responder processes the duplicate
> read but incorrectly resets the PSN to the value preceding the
> original send. When the duplicate send arrives, the responder cannot
> tell that it is a duplicate, so the responder generates a duplicate
> RCQ entry, confusing the client.
>
> Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_resp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
> index dd3d88a..cb3fd4c 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> @@ -742,7 +742,8 @@ static enum resp_states read_reply(struct rxe_qp *qp,
>  	} else {
>  		qp->resp.res = NULL;
>  		qp->resp.opcode = -1;
> -		qp->resp.psn = res->cur_psn;
> +		if (psn_compare(res->cur_psn, qp->resp.psn) >= 0)
> +			qp->resp.psn = res->cur_psn;
>  		state = RESPST_CLEANUP;
>  	}
>
>
Reviewed-by: Yonatan Cohen <yonatanc-z4ba+sSBFvVWk0Htik3J/w@public.gmane.org>
Nice catch.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
