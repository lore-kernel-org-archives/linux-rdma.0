From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Thu, 7 Jan 2010 08:52:59 +0100
Message-ID: <e2e108261001062352l1925f4e1i24bdbdde08056c4c@mail.gmail.com>
References: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com>
	 <ada4omyud7c.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada4omyud7c.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 6, 2010 at 10:37 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrot=
e:
>
> =A0> When the SRP initiator is communicating with an SRP target under=
 load it can
> =A0> happen that the SRP initiator locks up. The communication patter=
n that causes
> =A0> the lockup is as follows:
> =A0> * SRP initiator sends (req_lim - 2) SRP_CMD requests to the targ=
et.
> =A0> * The REQUEST LIMIT DELTA field of each SRP_RSP response is zero=
=2E
> =A0> * The target sends an SRP_CRED_REQ information unit with non-zer=
o REQUEST
> =A0> =A0 LIMIT DELTA.
> =A0>
> =A0> The above communication pattern brings the initiator in the foll=
owing state:
> =A0> * srp_queuecommand() always returns SCSI_MLQUEUE_HOST_BUSY.
> =A0> * The per-session variable zero_req_lim keeps increasing.
> =A0> The initiator never leaves this state because it ignores SRP_CRE=
D_REQ
> =A0> information units.
>
> This is all a bit obfuscated. =A0The problem is that the initiator ru=
ns
> out of credits and stops sending commands; because we don't process
> SRP_CRED_REQ messages from the target, we never get more credits.
>
> I'm wondering why this took so long to come up? =A0Does SCST send
> SRP_CRED_REQ only under unusual circumstances? =A0Also I'm wondering =
why
> the "Unhandled SRP opcode" message didn't show up in the kernel log a=
nd
> help debug this?

It was only recently that I had the time to analyze this issue in
depth and that I added SRP_CRED_REQ support in SCST (checked in that
support about one week ago). Before SRP_CRED_REQ support was added in
SCST, the SRP initiator could not log the "Unhandled SRP opcode"
message because it did not receive any unhandled SRP opcodes.

> =A0> + =A0 =A0for (i =3D 0; i < ARRAY_SIZE(target->txp_ring); ++i)
> =A0> + =A0 =A0 =A0 =A0 =A0 =A0srp_free_iu(target->srp_host, target->t=
xp_ring[i]);
>
> Not sure I understand why we need two TX rings -- why can't we just h=
ave
> one bigger TX ring that handles both requests and responses?

At the time I added the second TX ring it wasn't yet clear to me that
one single TX ring would work too. I'll merge both TX rings.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
