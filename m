From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 07/14] IB/mlx5: Make sure doorbell record is
 visible before doorbell
Date: Wed, 15 Jan 2014 11:19:18 +0100
Message-ID: <1389781158.572.14.camel@localhost.localdomain>
References: <1389714323-20130-1-git-send-email-eli@mellanox.com>
	 <1389714323-20130-8-git-send-email-eli@mellanox.com>
	 <1389717393.1585.66.camel@localhost.localdomain>
	 <20140115064747.GA31664@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140115064747.GA31664@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le mercredi 15 janvier 2014 =C3=A0 08:47 +0200, Eli Cohen a =C3=A9crit =
:
> >=20
> > In linux-next, as of next-20140114, I'm seeing the write memory bar=
rier
> > before "qp->db.db[MLX5_SND_DBR] =3D cpu_to_be32(qp->sq.cur_post);"
> > It was introduced by commit e126ba97dba9e:
> >=20
> > out:
> >         if (likely(nreq)) {
> >                 qp->sq.head +=3D nreq;
> >=20
> >                 /* Make sure that descriptors are written before
> >                  * updating doorbell record and ringing the doorbel=
l
> >                  */
> >                 wmb();
> >=20
> >                 qp->db.db[MLX5_SND_DBR] =3D cpu_to_be32(qp->sq.cur_=
post);
> >=20
> >                 if (bf->need_lock)
> >                         spin_lock(&bf->lock);
> >=20
> > So this add a second wmb().
> > Is it really necessary ?
> >=20
>=20
> Yes both are required. The first one makes sure that the descriptors
> are visible before update of the doorbell record, and the newly added
> one is required to ensure the doorbell record is visible before the
> hardware is notified.

OK.

They are both needed to ensure ordered write (correct serialization), s=
o
that the descriptors are valids after reading the record.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
