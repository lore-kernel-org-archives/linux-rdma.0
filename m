From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Problems using krping
Date: Tue, 26 Jan 2010 09:01:24 -0600
Message-ID: <4B5F03C4.1070705@opengridcomputing.com>
References: <201001211807011710722@inspur.com>, <201001221533186875550@inspur.com>, <201001242242553436345@inspur.com>, <201001251036131874884@inspur.com> <201001261339589687690@inspur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201001261339589687690-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lihaidong <lihaidong-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

lihaidong wrote:
> Mr.Wise
> |||                 else {
> ||| 
> |||                         cb->rdma_sq_wr.opcode = IB_WR_RDMA_READ;
> |||                         if (cb->mem == FASTREG) {
> |||                                 /* 
> |||                                  * Immediately follow the read with a 
> |||                                  * fenced LOCAL_INV.
> |||                                  */
> |||                                 cb->rdma_sq_wr.next = &inv;
> |||                                 memset(&inv, 0, sizeof inv);
> |||                                 inv.opcode = IB_WR_LOCAL_INV;
> |||                                 inv.ex.invalidate_rkey = cb->fastreg_mr->rkey;
> |||                                 inv.send_flags = IB_SEND_FENCE;
> |||                         }
> |||                 }
> ||| 
> |||                 ret = ib_post_send(cb->qp, &cb->rdma_sq_wr, &bad_wr);
> |||                 if (ret) {
> |||                         printk(KERN_ERR PFX "post send error %d\n", ret);
> |||                         break;
> |||                 }
> |||                 cb->rdma_sq_wr.next = NULL;
> the last line, is that safe? There's an invalidate wr following 
> rdma_sq_wr.This line will not disturb invalidate wr being performed in 
> lower level, right? 
>  

Correct.  The work requests are copied by the verbs layer.   So once you 
return from ib_post_send, the send work request structure itself can be 
reused/freed/whatever.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
