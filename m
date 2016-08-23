From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v3 04/15] IB/pvrdma: Add functions for Verbs support
Date: Tue, 23 Aug 2016 18:52:28 +0000
Message-ID: <BLUPR0501MB836B1C542C1296616A05080C5EB0@BLUPR0501MB836.namprd05.prod.outlook.com>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-5-git-send-email-aditr@vmware.com>
 <20160823151341.GA10264@yuval-lap> <20160823184322.GM15065@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160823184322.GM15065-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 23, 2016 at 11:43:27 -0700, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> w=
rote:
> On Tue, Aug 23, 2016 at 06:13:42PM +0300, Yuval Shaia wrote:
> > On Wed, Aug 03, 2016 at 04:27:33PM -0700, Adit Ranadive wrote:
> > > + */
> > > +int pvrdma_query_port(struct ib_device *ibdev, u8 port,
> > > +		      struct ib_port_attr *props)
> > > +{
> > > +	struct pvrdma_dev *dev =3D to_vdev(ibdev);
> > > +	union pvrdma_cmd_req req;
> > > +	union pvrdma_cmd_resp rsp;
> > > +	struct pvrdma_cmd_query_port *cmd =3D &req.query_port;
> > > +	struct pvrdma_cmd_query_port_resp *resp =3D &rsp.query_port_resp;
> > > +	int err;
> > > +
> > > +	memset(cmd, 0, sizeof(*cmd));
> > > +	cmd->hdr.cmd =3D PVRDMA_CMD_QUERY_PORT;
> > > +	cmd->port_num =3D port;
> > > +
> > > +	err =3D pvrdma_cmd_post(dev, &req, &rsp);
> >
> > Patch order again, this guy is added in patch 7/15 ("IB/pvrdma: Add dev=
ice
> > command support").
> > Maybe it is only me having trouble to read it so do not want to be a na=
gger
> > here but don't we have some (hidden) agreement that each patch is atomi=
c
> > and i should be able to compile the kernel after each one?
>=20
> IMHO, Doug will squash all these patches to one a second before adding
> it into his tree. The patches divided here for easy review.
>=20

Thanks Leon! I was hoping Doug would do that :).
While I do agree about the fact that each patch should be atomic, I don't k=
now
if it's possible in each case. I'm still new to the upstreaming process so =
correct
me if I'm wrong.
If it's easier to review I'll be happy to try to keep each patch as indepen=
dent as possible.

Thanks,
Adit

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
