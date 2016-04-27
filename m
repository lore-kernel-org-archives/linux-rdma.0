From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 09/11] IB/srp: Fix a NULL pointer dereference
Date: Wed, 27 Apr 2016 12:50:49 -0700
Message-ID: <57211819.7020009@sandisk.com>
References: <571A936F.7040409@sandisk.com> <571A9472.5050202@sandisk.com>
 <571FD7F4.4090006@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <571FD7F4.4090006-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/26/2016 02:04 PM, Sagi Grimberg wrote:
>> Avoid that running xfstests on top of the SRP initiator triggers
>> the call trace below. This patch has been tested by running the
>> following shell command on an initiator system that has access
>> to 3200 SRP LUNs:
>
> That's good to know, but the patch description needs to state where
> the NULL deref originates i.e. when can req be NULL and why it is
> OK to just assign to NULL and continue...

I think the issue fixed by this patch is a use-after-free of scmnd. If 
an rport is deleted srp_finish_req() calls scsi_done(). A concurrent 
scsi_queue_rq() call can reuse that scmnd before srp_process_rsp() gets 
called. This wouldn't occur if srp_wait_for_queuecommand() would also 
wait for scsi_queue_rq(). Since I expect it will be hard to convince the 
block layer maintainer to fix the root cause I came up with this patch.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
