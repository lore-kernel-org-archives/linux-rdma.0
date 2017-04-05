From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V3 for-next 4/7] IB/core: Change idr objects to use the
 new schema
Date: Wed, 5 Apr 2017 21:59:29 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB10FB14@ORSMSX109.amr.corp.intel.com>
References: <1491301907-32290-1-git-send-email-matanb@mellanox.com>
 <1491301907-32290-5-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB10FAD8@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB10FAD8-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > @@ -3142,7 +2583,7 @@ ssize_t ib_uverbs_attach_mcast(struct
> > ib_uverbs_file *file,
> >  	if (copy_from_user(&cmd, buf, sizeof cmd))
> >  		return -EFAULT;
> >
> > -	qp =3D idr_write_qp(cmd.qp_handle, file->ucontext);
> > +	qp =3D uobj_get_obj_read(qp, cmd.qp_handle, file->ucontext);
>=20
> This converts an idr_write to get_obj_read...
>=20
> >  	if (!qp)
> >  		return -EINVAL;
> >
> > @@ -3171,7 +2612,7 @@ ssize_t ib_uverbs_attach_mcast(struct
> > ib_uverbs_file *file,
> >  		kfree(mcast);
> >
> >  out_put:
> > -	put_qp_write(qp);
> > +	uobj_put_obj_read(qp);
> >
> >  	return ret ? ret : in_len;
> >  }
> > @@ -3190,16 +2631,16 @@ ssize_t ib_uverbs_detach_mcast(struct
> > ib_uverbs_file *file,
> >  	if (copy_from_user(&cmd, buf, sizeof cmd))
> >  		return -EFAULT;
> >
> > -	qp =3D idr_write_qp(cmd.qp_handle, file->ucontext);
> > +	qp =3D uobj_get_obj_read(qp, cmd.qp_handle, file->ucontext);
>=20
> Same here.  Are these changes correct?

I think your next patch addresses this comment.  :)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
