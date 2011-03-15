From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] rdma/cm: Fix crash in request handlers
Date: Mon, 14 Mar 2011 17:12:33 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCB3A08D@orsmsx501.amr.corp.intel.com>
References: <AcvTdFYeaaQMO705R2eTRRqJqdfjwA==>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC6C536C@orsmsx501.amr.corp.intel.com>
 <AANLkTinE3hzALRn9=5QOHiZCOGJU8RYm77c2vb_qzW5P@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinE3hzALRn9=5QOHiZCOGJU8RYm77c2vb_qzW5P-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > --- a/drivers/infiniband/core/cma.c
> > +++ b/drivers/infiniband/core/cma.c
> > @@ -1210,6 +1210,11 @@ static int cma_req_handler(struct ib_cm_id *=
cm_id,
> struct ib_cm_event *ib_event)
> > =A0 =A0 =A0 =A0cm_id->context =3D conn_id;
> > =A0 =A0 =A0 =A0cm_id->cm_handler =3D cma_ib_handler;
> >
> > + =A0 =A0 =A0 /*
> > + =A0 =A0 =A0 =A0* Protect against the user destroying conn_id from=
 another
> thread
> > + =A0 =A0 =A0 =A0* until we're done accessing it.
> > + =A0 =A0 =A0 =A0*/
> > + =A0 =A0 =A0 atomic_inc(&conn_id->refcount);
>=20
> This is a good catch, but I'm not sure I see why this is the right fi=
x.
>=20
> What prevents the destroy from happening right before the atomic_inc =
here?
> Does this just make the race window much smaller?

This is for a new request.  Until we call the user's event_handler (nex=
t line after bumping the refcount) with the new id, they can't destroy =
it.

> >                mutex_unlock(&conn_id->handler_mutex);
> > +               cma_deref_id(conn_id);
> >                rdma_destroy_id(&conn_id->id);
>=20
> likewise this seems to drop the additional reference, and then use
> the conn_id.  Why can't it be destroyed right after the cma_deref_id
> leading to use-after-free?

That is a double free error by the user.  If they return a non-zero val=
ue from the callback, that indicates that the rdma_cm should destroy th=
e id.  The user cannot use the id at that point.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
