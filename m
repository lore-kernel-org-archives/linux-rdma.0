From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 2/4] IB/srp: implement SRP_CRED_REQ
Date: Mon, 02 Aug 2010 17:44:33 -0400
Message-ID: <1280785473.2451.90.camel@lap75545.ornl.gov>
References: <201008021732.44769.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <201008021732.44769.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-08-02 at 17:32 +0200, Bart Van Assche wrote:
> This patch enables allocation of request and response information units on the
> send queue instead of only requests, and implements processing of SRP_CRED_REQ
> information units. Also, declarations have been added to include/scsi/srp.h
> for the SRP_CRED_REQ and SRP_CRED_RSP information units.

Same comment on the commit message.

There seems to be an accounting change from using tx_head/tx_tail to
using tx_req and tx_rsp. I'm not sure that really makes sense --
splitting that into its own patch would allow for an easier review and
may make it obvious if it is the right thing to do.

SRP_AER_REQ isn't handled, and it wouldn't be much to add it. That would
improve our standards compatibility.

I'm not comfortable with duplicating all the __srp_get_tx_iu()
functionality and splitting it as to if it used for a request or reply.
It just seems like a lot of it could go away with good use of function
parameters.

I started down that path -- based on your original patch -- in
http://permalink.gmane.org/gmane.linux.drivers.rdma/2023

Roland had some further comments that needed to be cleaned up.

> +/*
> + * The SRP spec defines the size of the CRED_REQ structure to be 16 bytes,
> + * so it needs to be packed to avoid having it padded to 24 bytes on
> + * 64-bit architectures.
> + */

Actually, I don't think it needs to be packed -- the req_lim_delta is at
a 32 bit boundary, so it should be aligned and the struct naturally
packed. I'm not particularly against the attribute in any event, but gcc
has been known to generate terrible code for certain architectures for
packed structs. In any event, I think the comment above is incorrect.

> +struct srp_cred_req {
> +	u8	opcode;
> +	u8	sol_not;
> +	u8	reserved[2];
> +	__be32	req_lim_delta;
> +	u64	tag;
> +} __attribute__((packed));

Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
