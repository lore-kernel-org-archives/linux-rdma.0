From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] iwcm: rem_ref() - don't touch cm_id after deref.
Date: Sun, 15 Dec 2013 16:45:43 -0800
Message-ID: <CAG4TOxP0zhkGpASSnXA2dR808ponPULyF=ngyQyPgVqsNju8Ug@mail.gmail.com>
References: <20131121214014.27527.79925.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131121214014.27527.79925.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 21, 2013 at 1:40 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
>  static void rem_ref(struct iw_cm_id *cm_id)
>  {
>         struct iwcm_id_private *cm_id_priv;
> +       int cb_destroy;
> +
>         cm_id_priv = container_of(cm_id, struct iwcm_id_private, id);
> -       if (iwcm_deref_id(cm_id_priv) &&
> -           test_bit(IWCM_F_CALLBACK_DESTROY, &cm_id_priv->flags)) {

Don't we have bigger problems if iwcm_deref_id() returns 1 (meaning
this thread is the one dropping the last reference) but then another
thread frees the cm_id_priv?  For one thing we go on to call
free_cm_id() which does kfree(cm_id_priv), which is no good if another
thread has already freed it.

Is the point that CALLBACK_DESTROY will never be set in that case?
OIC there is a BUG_ON iw_destroy_cm_id, got it.

Looks good.

> +
> +       /*
> +        * Test bit before deref in case the cm_id gets freed on another
> +        * thread.
> +        */
> +       cb_destroy = test_bit(IWCM_F_CALLBACK_DESTROY, &cm_id_priv->flags);
> +       if (iwcm_deref_id(cm_id_priv) && cb_destroy) {
>                 BUG_ON(!list_empty(&cm_id_priv->work_list));
>                 free_cm_id(cm_id_priv);
>         }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
