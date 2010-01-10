From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Sun, 10 Jan 2010 11:34:06 +0100
Message-ID: <e2e108261001100234k7dcb45cescb9ae133c0cdc256@mail.gmail.com>
References: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com>
	 <ada4omyud7c.fsf@roland-alpha.cisco.com>
	 <e2e108261001062352l1925f4e1i24bdbdde08056c4c@mail.gmail.com>
	 <adak4vuqrcw.fsf@roland-alpha.cisco.com>
	 <e2e108261001070003y6881eac7g3e8129e44b78a475@mail.gmail.com>
	 <adavdfapimb.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adavdfapimb.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 10, 2010 at 7:41 AM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrot=
e:
>
> =A0> The patch I posted is really fixing the original bug. The proble=
m was
> =A0> that neither the SRP target nor the SRP initiator had support fo=
r
> =A0> SRP_CRED_REQ. Support for SRP_CRED_REQ has to be added to both
> =A0> software components in order to fix this bug.
>
> There's no way for the target to return credits through responses? =A0=
I
> agree that we should implement the full SRP spec in the initiator but=
 it
> seems unfortunate to force both an initiator and target upgrade to fi=
x
> what really appears to be a target bug. =A0This means anyone running =
a
> pre-2.6.34 kernel won't be able to use the SCST SRP target reliably.

Please let me explain why the SCST SRP target behaves as observed, why
this behavior is not specific to SCST, and which workaround is
available for pre-2.6.34 SRP initiator users.

As known an SRP target passes the so-called req_lim value to the SRP
initiator via the REQUEST LIMIT DELTA field of the SRP_LOGIN_RSP
information unit. Let's call this value RL. As specified in the SRP
r16a document, an initiator may never send more than RL - 2 unanswered
SRP_CMD information units to an SRP target.

When an SRP_CMD request is being processed by an SRP target, the SRP
target can e.g. process this request using one of the following
strategies:
1. Using the buffer in which the SRP_CMD request was received to build
the response. In this case once the response has been built the target
will call ib_post_send() and will wait until the send completion has
been received before it will declare that buffer again available for
receiving by calling ib_post_recv().
2. Using separate sets of buffers for receiving SRP_CMD requests and
sending back SRP_RSP responses. In this case it is possible for the
target to re-enable receiving for the buffer in which the SRP_CMD
request was received before the SRP_RSP response is sent back.

Regarding approach (2): with this approach the value of the REQUEST
LIMIT DELTA field in the SRP_RSP information unit will always equal
one. With this approach it will never be necessary that the targets
sends an SRP_CRED_REQ information unit to the initiator.

Regarding approach (1): since for each SRP_RSP response sent back by
the target ib_post_recv() is called in the target after
ib_post_send(), at least for the first SRP_RSP response the REQUEST
LIMIT DELTA field will be equal to zero. And for a target that is able
to process all received SRP_CMD information units in parallel, it can
happen that the SRP target sends a contiguous series of (RL - 2)
SRP_RSP information units to the initiator with the REQUEST LIMIT
DELTA field equal to zero. As a consequence, the value of the req_lim
variable in the SRP initiator will be equal to 2 and the initiator
won't send any further SRP_CMD requests to the target. A scenario for
how to get the SRP initiator into this state can be found in
http://bugzilla.kernel.org/show_bug.cgi?id=3D14235.

The only way to get out of this deadlock is that the target send an
SRP_CRED_REQ information unit to the initiator with a non-zero REQUEST
LIMIT DELTA field, and that the SRP initiator processes this
SRP_CRED_REQ information unit.

Because of this possible SRP initiator lockup SCST-SRPT users have
been recommended to disable parallel processing of information units
in this SRP target (by specifying the ib_srpt kernel parameter
thread=3D1).

My conclusion is that the SRP initiator lockup explained in
http://bugzilla.kernel.org/show_bug.cgi?id=3D14235 is not specific to
SCST-SRPT but that this lockup can be triggered by any SRP target that
processes SRP_CMD requests in parallel.

So as far as I can see the choices we have are:
* Document that SRP_CRED_REQ support is missing in the Linux SRP
initiator and hence that command processing in SRP targets must be
complicated by making sure that never (RL - 2) contiguous SRP_RSP
information units are sent to the SRP initiator with the REQUEST LIMIT
DELTA field equal to zero.
* Add support for the SRP_CRED_REQ information unit in the Linux SRP in=
itiator.

Note: I do not know of any SRP targets that implement approach (2). As
far as I know all SRP targets use approach (1).

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
