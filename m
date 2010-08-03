From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 1/4] IB/srp: rename some symbolic constants
Date: Tue, 3 Aug 2010 13:33:58 +0200
Message-ID: <AANLkTi=PHPXk3irmXsgr03GcBk+5L43BJA25hWLUESAV@mail.gmail.com>
References: <201008021732.38682.bvanassche@acm.org>
	<1280784227.2451.72.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280784227.2451.72.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 2, 2010 at 11:23 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wro=
te:
>
> On Mon, 2010-08-02 at 17:32 +0200, Bart Van Assche wrote:
> > [ ... ]
> >
> > @@ -1051,7 +1052,7 @@ static struct srp_iu *__srp_get_tx_iu(struct =
srp_target_port *target,
> >
> > =A0 =A0 =A0 srp_send_completion(target->send_cq, target);
> >
> > - =A0 =A0 if (target->tx_head - target->tx_tail >=3D SRP_SQ_SIZE)
> > + =A0 =A0 if (target->tx_head - target->tx_tail >=3D SRP_REQ_SQ_SIZ=
E)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>
> I'm not keen on the name SRP_REQ_SQ_SIZE. I had used SRP_SQ_FULL here
> and SRP_MAX_CREDIT elsewhere to be more descriptive of their use, but
> I'm not sold on those names either. Anyone have better ideas?

SRP_REQ_SQ_SIZE is the number of elements of the send queue reserved
for sending requests (SRP_CMD, SRP_TSK_MGMT and in the future maybe
SRP_I_LOGOUT), and SRP_RSP_SQ_SIZE is the number of elements on the
send queue reserved for sending responses (SRP_CRED_RSP and in the
future also SRP_AER_RSP). So the names you suggested do not reflect
what these constants are used for.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
