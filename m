From: Yanjun Zhu <yanjun.zhu@oracle.com>
Subject: Re: [PATCHv2 1/1] IB/rxe: avoid double kfree_skb
Date: Thu, 26 Apr 2018 13:22:42 +0800
Message-ID: <384c7cce-d1e9-214b-4e9e-e97e9b080f3f@oracle.com>
References: <1524717670-10901-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1524717670-10901-1-git-send-email-yanjun.zhu@oracle.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: monis@mellanox.com, dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Add netdev@vger.kernel.org


On 2018/4/26 12:41, Zhu Yanjun wrote:
> When skb is sent, it will pass the following functions in soft roce.
>
> rxe_send [rdma_rxe]
>      ip_local_out
>          __ip_local_out
>          ip_output
>              ip_finish_output
>                  ip_finish_output2
>                      dev_queue_xmit
>                          __dev_queue_xmit
>                              dev_hard_start_xmit
>
> In the above functions, if error occurs in the above functions or
> iptables rules drop skb after ip_local_out, kfree_skb will be called.
> So it is not necessary to call kfree_skb in soft roce module again.
> Or else crash will occur.
>
> The steps to reproduce:
>
>       server                       client
>      ---------                    ---------
>      |1.1.1.1|<----rxe-channel--->|1.1.1.2|
>      ---------                    ---------
>
> On server: rping -s -a 1.1.1.1 -v -C 10000 -S 512
> On client: rping -c -a 1.1.1.1 -v -C 10000 -S 512
>
> The kernel configs CONFIG_DEBUG_KMEMLEAK and
> CONFIG_DEBUG_OBJECTS are enabled on both server and client.
>
> When rping runs, run the following command in server:
>
> iptables -I OUTPUT -p udp  --dport 4791 -j DROP
>
> Without this patch, crash will occur.
>
> CC: Srinivas Eeda <srinivas.eeda@oracle.com>
> CC: Junxiao Bi <junxiao.bi@oracle.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
> ---
> V1->V2: Not only the dropped skb is freed, but also the error skb
>          is also freed. So in soft roce, it is not necessary to call
>          kfree_skb again.
> ---
>   drivers/infiniband/sw/rxe/rxe_req.c  | 1 -
>   drivers/infiniband/sw/rxe/rxe_resp.c | 6 +-----
>   2 files changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
> index 7bdaf71..7851999 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> @@ -728,7 +728,6 @@ int rxe_requester(void *arg)
>   		rollback_state(wqe, qp, &rollback_wqe, rollback_psn);
>   
>   		if (ret == -EAGAIN) {
> -			kfree_skb(skb);
>   			rxe_run_task(&qp->req.task, 1);
>   			goto exit;
>   		}
> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
> index a65c996..955ff3b 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> @@ -742,7 +742,6 @@ static enum resp_states read_reply(struct rxe_qp *qp,
>   	err = rxe_xmit_packet(rxe, qp, &ack_pkt, skb);
>   	if (err) {
>   		pr_err("Failed sending RDMA reply.\n");
> -		kfree_skb(skb);
>   		return RESPST_ERR_RNR;
>   	}
>   
> @@ -954,10 +953,8 @@ static int send_ack(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
>   	}
>   
>   	err = rxe_xmit_packet(rxe, qp, &ack_pkt, skb);
> -	if (err) {
> +	if (err)
>   		pr_err_ratelimited("Failed sending ack\n");
> -		kfree_skb(skb);
> -	}
>   
>   err1:
>   	return err;
> @@ -1141,7 +1138,6 @@ static enum resp_states duplicate_request(struct rxe_qp *qp,
>   			if (rc) {
>   				pr_err("Failed resending result. This flow is not handled - skb ignored\n");
>   				rxe_drop_ref(qp);
> -				kfree_skb(skb_copy);
>   				rc = RESPST_CLEANUP;
>   				goto out;
>   			}
