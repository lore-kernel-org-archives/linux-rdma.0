From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [bug report] IB/cma: Add default RoCE TOS to CMA configfs
Date: Tue, 31 Jan 2017 15:32:48 +0000
Message-ID: <01D1013C-F14B-467D-A21E-9EA6214A38F5@mellanox.com>
References: <20170131105929.GA6788@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170131105929.GA6788@mwanda>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Jan 31, 2017, at 12:59 PM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wr=
ote:
>=20
> Hello Majd Dibbiny,
Hello Daniel,

Thanks for the report.
I'll fix and send a new revision soon..

>=20
> The patch eeec11e5c404: "IB/cma: Add default RoCE TOS to CMA
> configfs" from Dec 19, 2016, leads to the following static checker
> warning:
>=20
>    drivers/infiniband/core/cma.c:303 cma_get_default_roce_tos()
>    warn: signedness bug returning '(-22)'
>=20
> drivers/infiniband/core/cma.c
>   298 =20
>   299  u8 cma_get_default_roce_tos(struct cma_device *cma_dev, unsigned i=
nt port)
>   300  {
>   301          if (port < rdma_start_port(cma_dev->device) ||
>   302              port > rdma_end_port(cma_dev->device))
>   303                  return -EINVAL;
>=20
> This is a u8 function so you can't return negative error codes.
>=20
>   304 =20
>   305          return cma_dev->default_roce_tos[port - rdma_start_port(cm=
a_dev->device)];
>   306  }
>   307 =20
>=20
> regards,
> dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
