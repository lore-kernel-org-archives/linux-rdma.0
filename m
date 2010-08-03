From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 2/4] IB/srp: implement SRP_CRED_REQ
Date: Tue, 3 Aug 2010 13:40:08 +0200
Message-ID: <AANLkTikSFgcjZ0z-Py1+yeFZ8oAohBS=fpRAMqWRBnHy@mail.gmail.com>
References: <201008021732.44769.bvanassche@acm.org>
	<1280785473.2451.90.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280785473.2451.90.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 2, 2010 at 11:44 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
> On Mon, 2010-08-02 at 17:32 +0200, Bart Van Assche wrote:
> [ ... ]
>
> There seems to be an accounting change from using tx_head/tx_tail to
> using tx_req and tx_rsp. I'm not sure that really makes sense --
> splitting that into its own patch would allow for an easier review and
> may make it obvious if it is the right thing to do.

As I wrote in [PATCH 0/4], both initator-to-target requests and
initiator-to-target responses are now allocated from the same send
queue. Since tx_head - tx_tail is now the sum of the number of
requests and the number of responses allocated on the send queue, new
variables had to be introduced in order to count how many requests and
how many responses had been allocated on the send queue.

> SRP_AER_REQ isn't handled, and it wouldn't be much to add it. That would
> improve our standards compatibility.

The message "Unhandled SRP opcode" is printed for SRP_AER_REQ
information units. Support for SRP_AER_REQ can still be added in a
follow-up patch.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
