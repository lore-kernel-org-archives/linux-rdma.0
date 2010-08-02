From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 3/4] IB/srp: adjust can_queue
Date: Mon, 02 Aug 2010 17:55:29 -0400
Message-ID: <1280786129.2451.101.camel@lap75545.ornl.gov>
References: <201008021732.48499.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <201008021732.48499.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-08-02 at 17:32 +0200, Bart Van Assche wrote:
> Makes sure that the SCSI mid-layer never tries to queue more than
> (SRP request limit) - 1 SCSI commands. Improves performance for targets whose
> request limit is less than or equal to SRP_SQ_REQ_SIZE (63) by reducing the
> number of BUSY responses.

This is a better commit message, but why is it important to be less than
SRP_REQ_SQ_SIZE or (SRP request limit) - 1 commands?

You and I know that it is because we reserve one credit for sending task
management requests, but will future readers?

On that topic, I wonder if we should have a comment there, since we'll
otherwise have a magic number.

Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
