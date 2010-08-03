From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 3/4 v3] IB/srp: adjust can_queue
Date: Tue, 03 Aug 2010 11:24:24 -0400
Message-ID: <1280849064.20446.46.camel@lap75545.ornl.gov>
References: <201008031608.42244.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <201008031608.42244.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-08-03 at 16:08 +0200, Bart Van Assche wrote:
> The SRP (draft) standard specifies that an SRP initiator must never queue more
> than (SRP request limit) - 1 unanswered SRP_CMD information units. This patch
> makes sure that the SCSI mid-layer never tries to queue more than (SRP request
> limit) - 1 SCSI commands to ib_srp. This improves performance for targets
> whose request limit is less than or equal to SRP_SQ_REQ_SIZE (63) by reducing
> the number of BUSY responses reported by ib_srp to the SCSI mid-layer.

Actually, the standard states we can never send more than REQUEST LIMIT
requests. But we reserve 1 request for sending task management requests,
so that's why we need to tell the mid-layer to not send us more than
req_lim - 1 commands.

Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
