From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 2/4] IB/srp: implement SRP_CRED_REQ
Date: Wed, 4 Aug 2010 18:40:38 +0200
Message-ID: <AANLkTi=F7Ks=eZJUqdE6JBwzFGqmumM-ibAMcxDstN5V@mail.gmail.com>
References: <201008021732.44769.bvanassche@acm.org>
	<1280785473.2451.90.camel@lap75545.ornl.gov>
	<AANLkTikSFgcjZ0z-Py1+yeFZ8oAohBS=fpRAMqWRBnHy@mail.gmail.com>
	<1280847933.20446.29.camel@lap75545.ornl.gov>
	<AANLkTinMU8QkX-5WrsW18UJ7qNfp7ZDchpqcPw0JGAJz@mail.gmail.com>
	<1280850256.20446.56.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280850256.20446.56.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 3, 2010 at 5:44 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
>
> [ ... ]
>
> If SRQ_SQ_SIZE is 64, we set .can_queue to 63 which will leave a buffer
> available for the reply.
>
> Now, if the target sends us multiple SRP_CRED_REQ without waiting for a
> reply, then we could use up buffers and not be able to send requests,
> but that would be a protocol violation on the target's side.

I'll wait for more opinions about the tx_req / tx_rsp elimination.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
