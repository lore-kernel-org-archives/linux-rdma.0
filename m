From: Parav Pandit <parav@mellanox.com>
Subject: RE: [PATCH mlx5-next 14/15] {IB, net}/mlx5: E-Switch, Use index of
 rep for vport to IB port mapping
Date: Tue, 18 Jun 2019 10:47:42 +0000
Message-ID: <AM0PR05MB4866DF63BB7D80483630F0A9D1EA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-15-saeedm@mellanox.com>
 <20190618104220.GH4690@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190618104220.GH4690@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Bodong Wang <bodong@mellanox.com>, Mark Bloch <markb@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi Leon,

> -----Original Message-----
> From: Leon Romanovsky
> Sent: Tuesday, June 18, 2019 4:12 PM
> To: Saeed Mahameed <saeedm@mellanox.com>
> Cc: netdev@vger.kernel.org; linux-rdma@vger.kernel.org; Bodong Wang
> <bodong@mellanox.com>; Parav Pandit <parav@mellanox.com>; Mark Bloch
> <markb@mellanox.com>
> Subject: Re: [PATCH mlx5-next 14/15] {IB, net}/mlx5: E-Switch, Use index =
of rep
> for vport to IB port mapping
>=20
> On Mon, Jun 17, 2019 at 07:23:37PM +0000, Saeed Mahameed wrote:
> > From: Bodong Wang <bodong@mellanox.com>
> >
> > In the single IB device mode, the mapping between vport number and rep
> > relies on a counter. However for dynamic vport allocation, it is
> > desired to keep consistent map of eswitch vport and IB port.
> >
> > Hence, simplify code to remove the free running counter and instead
> > use the available vport index during load/unload sequence from the
> > eswitch.
> >
> > Signed-off-by: Bodong Wang <bodong@mellanox.com>
> > Suggested-by: Parav Pandit <parav@mellanox.com>
> > Reviewed-by: Parav Pandit <parav@mellanox.com>
>=20
> We are not adding multiple "*-by" for same user, please choose one.
>=20
Suggested-by was added by Bodong during our discussion. Later on when I did=
 gerrit +1, RB tag got added.

> Thanks
