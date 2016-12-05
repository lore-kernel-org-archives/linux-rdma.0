From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Use ib_drain_qp instead of ib_drain_rq in ib_srp
Date: Mon, 5 Dec 2016 09:05:28 -0800
Message-ID: <b2a1ed73-fb4c-07a5-c343-389bdc29501c@sandisk.com>
References: <fa2d38be-bc59-5120-6dfd-f24ab01d6d8f@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fa2d38be-bc59-5120-6dfd-f24ab01d6d8f-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, sagig <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/05/2016 06:43 AM, Max Gurtovoy wrote:
> hi guys,
> I've noticed that we use ib_drain_rq in teardown flow in ib_srp driver.
> Trying to figure out why is this better than ib_drain_qp ?
> BTW, the recv_cq != send_cq in srp so it's even better to use
> ib_drain_qp, isn't it ?
>
> I haven't encountered a bug in this area yet, but just trying to
> understand if it's there.

Hello Max,

The description of a patch that was accepted upstream about two years 
ago explains the purpose of the ib_drain_rq() call:

commit 7dad6b2e440d810273946b0e7092a8fe043c3b8a
Author: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Date:   Tue Oct 21 18:00:35 2014 +0200

     IB/srp: Fix a race condition triggered by destroying a queue pair

     At least LID reassignment can trigger a race condition in the SRP
     initiator driver, namely the receive completion handler trying to
     post a request on a QP during or after QP destruction and before
     the CQ's have been destroyed. Avoid this race by modifying a QP
     into the error state and by waiting until all receive completions
     have been processed before destroying a QP.

     Reported-by: Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
     Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
     Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
     Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

There is no risk that any send work will be posted while the ib_srp 
driver destroys a QP.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
