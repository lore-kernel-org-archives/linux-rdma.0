From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next v2 7/7] RDMA/nldev: Provide detailed QP
 information
Date: Tue, 9 Jan 2018 21:46:56 +0000
Message-ID: <VI1PR0502MB3008480F1D00A54AC4792508D1100@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20180102081832.5264-1-leon@kernel.org>
 <20180102081832.5264-8-leon@kernel.org> <20180109200917.GF4518@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180109200917.GF4518-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> Sent: Tuesday, January 09, 2018 2:09 PM
> To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; RDMA mailing list <linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Leon
> Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next v2 7/7] RDMA/nldev: Provide detailed QP
> information
>=20
> On Tue, Jan 02, 2018 at 10:18:32AM +0200, Leon Romanovsky wrote:
>=20
> > +	/* PID =3D=3D 0 means that this QP was created by kernel */
> > +	if (qp->res.pid && nla_put_u32(msg,
> > +				       RDMA_NLDEV_ATTR_RES_PID, qp-
> >res.pid))
>=20
> This is returning a pid in the init name space, obtained here:
>=20
> +		res->pid =3D task_pid_nr(current);
>=20
> And since the netlink user is not running in the init name space this wil=
l return the
> wrong pid #, and worse potentially pids the current name space should not=
 see.
>=20
> This API also needs to filter the results and only return pids visible, a=
nd translate
> the pids as well..
>=20
Same fix needed for rdma_accept() and rdma_create_id() in near future.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
