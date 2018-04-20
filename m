From: Yanjun Zhu <yanjun.zhu@oracle.com>
Subject: Re: [PATCH 1/1] IB/rxe: avoid double kfree_skb
Date: Fri, 20 Apr 2018 13:46:30 +0800
Message-ID: <89cbf00d-40b1-d3cc-dd1c-3c4b6fd365d8@oracle.com>
References: <1524146512-4188-1-git-send-email-yanjun.zhu@oracle.com>
 <1524190794.11756.18.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1524190794.11756.18.camel@redhat.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, monis@mellanox.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org
Cc: netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



On 2018/4/20 10:19, Doug Ledford wrote:
> On Thu, 2018-04-19 at 10:01 -0400, Zhu Yanjun wrote:
>> When skb is dropped by iptables rules, the skb is freed at the same time
>> -EPERM is returned. So in softroce, it is not necessary to free skb again.
>> Or else, crash will occur.
>>
>> The steps to reproduce:
>>
>>       server                       client
>>      ---------                    ---------
>>      |1.1.1.1|<----rxe-channel--->|1.1.1.2|
>>      ---------                    ---------
>>
>> On server: rping -s -a 1.1.1.1 -v -C 10000 -S 512
>> On client: rping -c -a 1.1.1.1 -v -C 10000 -S 512
>>
>> The kernel configs CONFIG_DEBUG_KMEMLEAK and
>> CONFIG_DEBUG_OBJECTS are enabled on both server and client.
>>
>> When rping runs, run the following command in server:
>>
>> iptables -I OUTPUT -p udp  --dport 4791 -j DROP
>>
>> Without this patch, crash will occur.
>>
>> CC: Srinivas Eeda <srinivas.eeda@oracle.com>
>> CC: Junxiao Bi <junxiao.bi@oracle.com>
>> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
>> Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
> I have no reason to doubt your analysis, but if there are a bunch of
> error paths for net_xmit and they all return with your skb still being
> valid and holding a reference, and then one oddball that returns with
> your skb already gone, that just sounds like a mistake waiting to happen
> (not to mention a bajillion special cases sprinkled everywhere to deal
> with this apparent inconsistency).
>
> Can we get a netdev@ confirmation on this being the right solution?
Yes. I agree with you.
After iptables rule "iptables -I OUTPUT -p udp  --dport 4791 -j DROP", 
the skb is freed in this function

/* Returns 1 if okfn() needs to be executed by the caller,
  * -EPERM for NF_DROP, 0 otherwise.  Caller must hold rcu_read_lock. */
int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
                  const struct nf_hook_entries *e, unsigned int s)
{
         unsigned int verdict;
         int ret;

         for (; s < e->num_hook_entries; s++) {
                 verdict = nf_hook_entry_hookfn(&e->hooks[s], skb, state);
                 switch (verdict & NF_VERDICT_MASK) {
                 case NF_ACCEPT:
                         break;
                 case NF_DROP:
kfree_skb(skb);                               <----here, skb is freed
                         ret = NF_DROP_GETERR(verdict);
                         if (ret == 0)
                                 ret = -EPERM;
                         return ret;
                 case NF_QUEUE:
                         ret = nf_queue(skb, state, e, s, verdict);
                         if (ret == 1)
                                 continue;
                         return ret;
                 default:
                         /* Implicit handling for NF_STOLEN, as well as 
any other
                          * non conventional verdicts.
                          */
                         return 0;
                 }
         }

         return 1;
}
EXPORT_SYMBOL(nf_hook_slow);

If I am wrong, please correct me.

And my test environment is still there, any solution can be verified in it.

Zhu Yanjun
>
>> ---
>>   drivers/infiniband/sw/rxe/rxe_net.c  | 3 +++
>>   drivers/infiniband/sw/rxe/rxe_req.c  | 5 +++--
>>   drivers/infiniband/sw/rxe/rxe_resp.c | 9 ++++++---
>>   3 files changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
>> index 9da6e37..2094434 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_net.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
>> @@ -511,6 +511,9 @@ int rxe_send(struct rxe_pkt_info *pkt, struct sk_buff *skb)
>>   
>>          if (unlikely(net_xmit_eval(err))) {
>>                  pr_debug("error sending packet: %d\n", err);
>> +               /* -EPERM means the skb is dropped and freed. */
>> +               if (err == -EPERM)
>> +                       return -EPERM;
>>                  return -EAGAIN;
>>          }
>>   
>> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
>> index 7bdaf71..9d2efec 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_req.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
>> @@ -727,8 +727,9 @@ int rxe_requester(void *arg)
>>   
>>                  rollback_state(wqe, qp, &rollback_wqe, rollback_psn);
>>   
>> -               if (ret == -EAGAIN) {
>> -                       kfree_skb(skb);
>> +               if ((ret == -EAGAIN) || (ret == -EPERM)) {
>> +                       if (ret == -EAGAIN)
>> +                               kfree_skb(skb);
>>                          rxe_run_task(&qp->req.task, 1);
>>                          goto exit;
>>                  }
>> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
>> index a65c996..6bdf9b2 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
>> @@ -742,7 +742,8 @@ static enum resp_states read_reply(struct rxe_qp *qp,
>>          err = rxe_xmit_packet(rxe, qp, &ack_pkt, skb);
>>          if (err) {
>>                  pr_err("Failed sending RDMA reply.\n");
>> -               kfree_skb(skb);
>> +               if (err != -EPERM)
>> +                       kfree_skb(skb);
>>                  return RESPST_ERR_RNR;
>>          }
>>   
>> @@ -956,7 +957,8 @@ static int send_ack(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
>>          err = rxe_xmit_packet(rxe, qp, &ack_pkt, skb);
>>          if (err) {
>>                  pr_err_ratelimited("Failed sending ack\n");
>> -               kfree_skb(skb);
>> +               if (err != -EPERM)
>> +                       kfree_skb(skb);
>>          }
>>   
>>   err1:
>> @@ -1141,7 +1143,8 @@ static enum resp_states duplicate_request(struct rxe_qp *qp,
>>                          if (rc) {
>>                                  pr_err("Failed resending result. This flow is not handled - skb ignored\n");
>>                                  rxe_drop_ref(qp);
>> -                               kfree_skb(skb_copy);
>> +                               if (rc != -EPERM)
>> +                                       kfree_skb(skb_copy);
>>                                  rc = RESPST_CLEANUP;
>>                                  goto out;
>>                          }
>> -- 
>> 2.7.4
>>
