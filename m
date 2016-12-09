From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 11/28] bnxt_re: Enabling RoCE control path
Date: Fri, 9 Dec 2016 16:20:04 +0530
Message-ID: <CA+sbYW27WyB5q0CXom3ahf0kB1s4GXYX0m+dsfwV6YgdjaksvA@mail.gmail.com>
References: <1480919912-1079-1-git-send-email-selvin.xavier@broadcom.com>
 <1480919912-1079-12-git-send-email-selvin.xavier@broadcom.com> <973d0642-1d06-72d4-bbbd-d360663d287b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <973d0642-1d06-72d4-bbbd-d360663d287b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jonathan,
 Thanks for your review.

On Thu, Dec 8, 2016 at 10:24 PM, Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> This retry logic looks like a complicated infinite loop, I am not seeing
> where there is a counter or some other mechanism to break out of this
> retry cycle if for some reason the HW stops or some other issue occurs.
> Can you help me understand this section?
>
You are right. This is a bug which could cause a system hang.
cmdq_bitmap is set while sending the commands to FW and this will be cleared
when completion interrupts are received (handled by function
bnxt_qplib_process_qp_event which is a part
 "bnxt_re: Add QP event handling" patch in this series).

I missed your mail before sending out v2 patch set. I will include
this change as a bug fix patch
or will fix it while incorporating other review comments in v3 patch set.

Thanks

>> +
>> +     /* Cmdq are in 16-byte units, each request can consume 1 or more
>> +      * cmdqe
>> +      */
>> +     spin_lock_irqsave(&cmdq->lock, flags);
>> +     if (req->cmd_size > cmdq->max_elements -
>> +         ((HWQ_CMP(cmdq->prod, cmdq) - HWQ_CMP(cmdq->cons, cmdq)) &
>> +          (cmdq->max_elements - 1))) {
>> +             dev_err(&rcfw->pdev->dev, "QPLIB: RCFW: CMDQ is full!");
>> +             spin_unlock_irqrestore(&cmdq->lock, flags);
>> +             goto retry;
>> +     }
>> +
>> +     cookie = atomic_inc_return(&rcfw->seq_num) & RCFW_MAX_COOKIE_VALUE;
>> +     cbit = cookie % RCFW_MAX_OUTSTANDING_CMD;
>> +     if (is_block)
>> +             cookie |= RCFW_CMD_IS_BLOCKING;
>> +     req->cookie = cpu_to_le16(cookie);
>> +     if (test_and_set_bit(cbit, rcfw->cmdq_bitmap)) {
>> +             dev_err(&rcfw->pdev->dev,
>> +                     "QPLIB: RCFW MAX outstanding cmd reached!");
>> +             atomic_dec(&rcfw->seq_num);
>> +             spin_unlock_irqrestore(&cmdq->lock, flags);
>> +             goto retry;
>> +     }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
