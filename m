From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 2/5 v6] IB/srp: IB/srp: Implement SRP_CRED_REQ and SRP_AER_REQ
Date: Wed, 25 Aug 2010 18:50:51 +0200
Message-ID: <AANLkTiknzQx_T-J1uhePtOu-X3_itq3sS5GUfNk7EGvE@mail.gmail.com>
References: <201008221856.29895.bvanassche@acm.org>
	<1282704503.24982.22.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282704503.24982.22.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 25, 2010 at 4:48 AM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wro=
te:
>
> On Sun, 2010-08-22 at 18:56 +0200, Bart Van Assche wrote:
> > [ ... ]
> > =A0static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *ta=
rget,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 enum srp_request_type req_type)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 enum srp_tx_iu_type iu_type)
> > =A0{
> > - =A0 =A0 s32 rsv =3D (req_type =3D=3D SRP_REQ_TASK_MGMT) ? 0 : SRP=
_TSK_MGMT_SQ_SIZE;
> > + =A0 =A0 s32 rsv =3D (iu_type =3D=3D SRP_IU_REQ_TSK_MGMT) ? 0 : SR=
P_TSK_MGMT_SQ_SIZE;
>
> You check for credits even if this is an SRP_IU_RSP, so we'll fail to
> allocate an IU if we're low on credits. Not a common condition, but
> possible within the spec.

The code below was present in version five of the patch series and has
been removed accidentally. I'll resend the patch series.

+	if (tx_iu_type !=3D SRP_TX_IU_RSP && target->req_lim <=3D rsv) {
+		++target->zero_req_lim;
+		return NULL;
+	}

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
