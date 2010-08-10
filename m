From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 2/4] IB/srp: implement SRP_CRED_REQ
Date: Tue, 10 Aug 2010 09:55:40 +0200
Message-ID: <AANLkTikmh4+15_3wPGaBkb5o5wkyyiLnRbqKu2Tzmbgp@mail.gmail.com>
References: <201008021732.44769.bvanassche@acm.org>
	<1280785473.2451.90.camel@lap75545.ornl.gov>
	<AANLkTikSFgcjZ0z-Py1+yeFZ8oAohBS=fpRAMqWRBnHy@mail.gmail.com>
	<1280847933.20446.29.camel@lap75545.ornl.gov>
	<AANLkTinMU8QkX-5WrsW18UJ7qNfp7ZDchpqcPw0JGAJz@mail.gmail.com>
	<1280850256.20446.56.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280850256.20446.56.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 3, 2010 at 5:44 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrot=
e:
>
> On Tue, 2010-08-03 at 17:26 +0200, Bart Van Assche wrote:
> [ ... ]
> > I'm not sure it is a good idea to allow that all transmit buffers g=
et
> > allocated for sending CMD_RSP information units and that none remai=
n
> > for replying to incoming SRP_CRED_REQ / SRP_AER_REQ / SRP_T_LOGOUT
> > requests. Wouldn't that be a protocol violation ?
>
> You mean SRP_CMD? We don't do that, we clamp the outstanding requests=
 we
> generate so we'll always have a buffer to reply to SRP_CRED_REQ et al=
=2E
>
> If SRQ_SQ_SIZE is 64, we set .can_queue to 63 which will leave a buff=
er
> available for the reply.
>
> Now, if the target sends us multiple SRP_CRED_REQ without waiting for=
 a
> reply, then we could use up buffers and not be able to send requests,
> but that would be a protocol violation on the target's side.

(resending as plain text)

I have been looking further into this. There is a slight asymmetry in
the current transmit buffer allocation code: one buffer element is
reserved on the target for task management requests but not on the
initiator. So - at least in theory - it is possible that all elements
of the initiator transmit ring are allocated for SRP_CMD requests at
the time an SRP_TSK_MGMT request should be sent. Wouldn't it be more
symmetric to change __srp_get_tx_iu() as follows (diff against the
current for-next branch) ?

--- a/drivers/infiniband/ulp/srp/
ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -989,14 +989,14 @@ static void srp_send_completion(struct ib_cq
*cq, void *target_ptr)
=A0static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target=
,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 enum srp_request_type req=
_type)
=A0{
-=A0=A0=A0=A0=A0=A0 s32 min =3D (req_type =3D=3D SRP_REQ_TASK_MGMT) ? 1=
 : 2;
+=A0=A0=A0=A0=A0=A0 s32 rsv =3D (req_type =3D=3D SRP_REQ_TASK_MGMT) ? 0=
 : 1;

=A0=A0=A0=A0=A0=A0=A0 srp_send_completion(target->send_cq, target);

-=A0=A0=A0=A0=A0=A0 if (target->tx_head - target->tx_tail >=3D SRP_SQ_S=
IZE)
+=A0=A0=A0=A0=A0=A0 if (target->tx_head - target->tx_tail >=3D SRP_SQ_S=
IZE - rsv)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;

-=A0=A0=A0=A0=A0=A0 if (target->req_lim < min) {
+=A0=A0=A0=A0=A0=A0 if (target->req_lim <=3D rsv) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ++target->zero_req_lim;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return NULL;
=A0=A0=A0=A0=A0=A0=A0 }

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
