From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Wed, 06 Jan 2010 13:37:43 -0800
Message-ID: <ada4omyud7c.fsf@roland-alpha.cisco.com>
References: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108261001020419l36319156hb9d625edc2e15d06-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Sat, 2 Jan 2010 13:19:13 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > When the SRP initiator is communicating with an SRP target under load it can
 > happen that the SRP initiator locks up. The communication pattern that causes
 > the lockup is as follows:
 > * SRP initiator sends (req_lim - 2) SRP_CMD requests to the target.
 > * The REQUEST LIMIT DELTA field of each SRP_RSP response is zero.
 > * The target sends an SRP_CRED_REQ information unit with non-zero REQUEST
 >   LIMIT DELTA.
 > 
 > The above communication pattern brings the initiator in the following state:
 > * srp_queuecommand() always returns SCSI_MLQUEUE_HOST_BUSY.
 > * The per-session variable zero_req_lim keeps increasing.
 > The initiator never leaves this state because it ignores SRP_CRED_REQ
 > information units.

This is all a bit obfuscated.  The problem is that the initiator runs
out of credits and stops sending commands; because we don't process
SRP_CRED_REQ messages from the target, we never get more credits.

I'm wondering why this took so long to come up?  Does SCST send
SRP_CRED_REQ only under unusual circumstances?  Also I'm wondering why
the "Unhandled SRP opcode" message didn't show up in the kernel log and
help debug this?

Some specific comments:

 > +/* Similar to is_power_of_2(), but can be evaluated at compile time. */
 > +#define IS_POWER_OF_2(n) ((n) != 0 && (((n) & ((n) - 1)) == 0))

I don't think this level of ugliness is really required -- we can just
document carefully at the definition that we need things to be powers of 2.

 > +	for (i = 0; i < ARRAY_SIZE(target->txp_ring); ++i)
 > +		srp_free_iu(target->srp_host, target->txp_ring[i]);

Not sure I understand why we need two TX rings -- why can't we just have
one bigger TX ring that handles both requests and responses?

 > + * Obtain an information unit for sending a request to the target.

I think there's a bit of overcommenting in a few places.  Does it really
help anyone to repeat that what "get_tx_iu" does is "get an information
unit for sending"?

 > -	return target->tx_ring[target->tx_head & SRP_SQ_SIZE];
 > +	return target->tx_ring[target->tx_head
 > +			       & (ARRAY_SIZE(target->tx_ring) - 1)];

is this an improvement?

 > + * Send a request to the target.
 > +static int __srp_post_send_req(struct srp_target_port *target,

same -- does the comment add anything?

 > +	/* Completion queue. */
 > +	SRP_CQ_SIZE		= SRP_SQ_SIZE + SRP_TXP_SIZE + SRP_RQ_SIZE,

etc... all these comments are mostly taking up vertical space and
visually jarring, without adding much info.

 > +/*
 > + * SRP_CRED_REQ information unit, as defined in section 6.10 of the
 > + * T10 SRP r16a document.
 > + */
 > +struct srp_cred_req {
 > +	u8	opcode;
 > +	u8	sol_not;
 > +	u8	reserved[2];
 > +	__be32	req_lim_delta;
 > +	u64	tag;
 > +} __attribute__((packed));

again... does it help anyone to say "struct srp_cred_req" corresponds to
SRP_CRED_REQ?  <scsi/srp.h> already refers to the SRP document, and I
would think anyone looking up SRP_CRED_REQ could find it faster by
looking for the string itself rather than by section number.

The existing comments in the file are actually useful -- they explain
why some structures need to be packed, and as far as I can tell neither
srp_cred_req nor srp_cred_rsp need to be packed.

 - R.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
