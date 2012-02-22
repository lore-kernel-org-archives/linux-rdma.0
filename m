From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] iw_cm: Call provider listen_destroy function before
 changing state.
Date: Wed, 22 Feb 2012 12:32:24 -0800
Message-ID: <CAG4TOxMXTzLDynza4KOaccx2C+Nn0485Xk_hXgg_bG0CiCTSEQ@mail.gmail.com>
References: <20120222194337.21025.30754.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120222194337.21025.30754.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 22, 2012 at 11:43 AM, Steve Wise
<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> =A0 =A0 =A0spin_lock_irqsave(&cm_id_priv->lock, flags);
> =A0 =A0 =A0 =A0switch (cm_id_priv->state) {
> =A0 =A0 =A0 =A0case IW_CM_STATE_LISTEN:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cm_id_priv->state =3D IW_CM_STATE_DESTR=
OYING;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore(&cm_id_priv->lo=
ck, flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* destroy the listening endpoint */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D cm_id->device->iwcm->destroy_l=
isten(cm_id);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock_irqsave(&cm_id_priv->lock, f=
lags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cm_id_priv->state =3D IW_CM_STATE_DESTR=
OYING;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0case IW_CM_STATE_ESTABLISHED:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cm_id_priv->state =3D IW_CM_STATE_DEST=
ROYING;

This seems a bit wonky to me... with the old code, we set the state to
DESTROYING inside the lock, so we know all previous connections
were either done with their locked region or saw the new state.

Now we have a window where are done with destroy_listen() but
the state is still not DESTROYING.

Is it possible to have the provider reject requests instead of silently
dropping them?  Would that be a better fix?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
