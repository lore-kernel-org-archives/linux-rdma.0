From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 09/13] RDMA/bnxt_re: Allow posting when QPs are
 in error
Date: Thu, 22 Jun 2017 14:46:29 +0530
Message-ID: <CA+sbYW27PNbcznnWjWZKvZW_WgVsVUxY2RJWx-XrTYJuX4gxjQ@mail.gmail.com>
References: <1498065504-27902-1-git-send-email-selvin.xavier@broadcom.com>
 <1498065504-27902-10-git-send-email-selvin.xavier@broadcom.com> <20170622054010.GL1248@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170622054010.GL1248-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 22, 2017 at 11:10 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> +static bool bnxt_qplib_is_qp_in_sq_flushlist(struct bnxt_qplib_qp *qp)
>> +{
>> +     bool flushed = false;
>> +     unsigned long flags;
>> +
>> +     spin_lock_irqsave(&qp->scq->flush_lock, flags);
>> +     flushed = qp->sq.flushed;
>> +     spin_unlock_irqrestore(&qp->scq->flush_lock, flags);
>> +     return flushed;
>
> I don't really understand the lock/unlock here. What exactly do you
> protect? Is it the change of "flushed"? It can be and will be worthless
> immediately after your unlock.
>
> You should protect the whole flow which depends on your "flushed".
Agreed. This lock is required for handling the completions when the qp
moves from error to
reset state. But surely it needs a rework.  I will post  v2.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
