From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] iw_cm: reject connect requests if cmid is not in LISTEN
Date: Wed, 22 Feb 2012 23:46:18 -0800
Message-ID: <CAL1RGDV7ZoKWgbh+ERF+af3_B7K2USAkXSPKWeQEg5atpHY0og@mail.gmail.com>
References: <20120222214307.23921.83903.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120222214307.23921.83903.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 22, 2012 at 1:43 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+v7I7tHvgBF7@public.gmane.org=
m> wrote:
> diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core=
/iwcm.c
> index 1a696f7..6847d76 100644
> --- a/drivers/infiniband/core/iwcm.c
> +++ b/drivers/infiniband/core/iwcm.c
> @@ -631,6 +631,8 @@ static void cm_conn_req_handler(struct iwcm_id_pr=
ivate *listen_id_priv,
> =A0 =A0 =A0 =A0spin_lock_irqsave(&listen_id_priv->lock, flags);
> =A0 =A0 =A0 =A0if (listen_id_priv->state !=3D IW_CM_STATE_LISTEN) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore(&listen_id_priv=
->lock, flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iw_cm_reject(cm_id, NULL, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iw_destroy_cm_id(cm_id);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock_irqrestore(&listen_id_priv->lock, flags);

Thanks, this makes more sense to my brain at least.

I assume this works just as well in your testing? :)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
