From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] rdma/cm: Fix crash in request handlers
Date: Mon, 14 Mar 2011 17:00:05 -0700
Message-ID: <AANLkTinE3hzALRn9=5QOHiZCOGJU8RYm77c2vb_qzW5P@mail.gmail.com>
References: <AcvTdFYeaaQMO705R2eTRRqJqdfjwA==> <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC6C536C@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC6C536C-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 23, 2011 at 8:11 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -1210,6 +1210,11 @@ static int cma_req_handler(struct ib_cm_id *cm=
_id, struct ib_cm_event *ib_event)
> =A0 =A0 =A0 =A0cm_id->context =3D conn_id;
> =A0 =A0 =A0 =A0cm_id->cm_handler =3D cma_ib_handler;
>
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Protect against the user destroying conn_id from a=
nother thread
> + =A0 =A0 =A0 =A0* until we're done accessing it.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 atomic_inc(&conn_id->refcount);

This is a good catch, but I'm not sure I see why this is the right fix.

What prevents the destroy from happening right before the atomic_inc he=
re?
Does this just make the race window much smaller?

>                mutex_unlock(&conn_id->handler_mutex);
> +               cma_deref_id(conn_id);
>                rdma_destroy_id(&conn_id->id);

likewise this seems to drop the additional reference, and then use
the conn_id.  Why can't it be destroyed right after the cma_deref_id
leading to use-after-free?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
