From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next 14/15] {IB, net}/mlx5: E-Switch, Use index of
 rep for vport to IB port mapping
Date: Wed, 19 Jun 2019 05:00:39 +0000
Message-ID: <20190619050036.GB11611@mtr-leonro.mtl.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-15-saeedm@mellanox.com>
 <20190618104220.GH4690@mtr-leonro.mtl.com>
 <AM0PR05MB4866DF63BB7D80483630F0A9D1EA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <7b098b42a51e5b96eca99c024719eebafa775f7a.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <7b098b42a51e5b96eca99c024719eebafa775f7a.camel@mellanox.com>
Content-Language: en-US
Content-ID: <EE5DDFCE7F16DE4F95A894DE8B61A130@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Parav Pandit <parav@mellanox.com>, Mark Bloch <markb@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Bodong Wang <bodong@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 18, 2019 at 06:25:46PM +0000, Saeed Mahameed wrote:
> On Tue, 2019-06-18 at 10:47 +0000, Parav Pandit wrote:
> > Hi Leon,
> >
> > > -----Original Message-----
> > > From: Leon Romanovsky
> > > Sent: Tuesday, June 18, 2019 4:12 PM
> > > To: Saeed Mahameed <saeedm@mellanox.com>
> > > Cc: netdev@vger.kernel.org; linux-rdma@vger.kernel.org; Bodong Wang
> > > <bodong@mellanox.com>; Parav Pandit <parav@mellanox.com>; Mark
> > > Bloch
> > > <markb@mellanox.com>
> > > Subject: Re: [PATCH mlx5-next 14/15] {IB, net}/mlx5: E-Switch, Use
> > > index of rep
> > > for vport to IB port mapping
> > >
> > > On Mon, Jun 17, 2019 at 07:23:37PM +0000, Saeed Mahameed wrote:
> > > > From: Bodong Wang <bodong@mellanox.com>
> > > >
> > > > In the single IB device mode, the mapping between vport number
> > > > and rep
> > > > relies on a counter. However for dynamic vport allocation, it is
> > > > desired to keep consistent map of eswitch vport and IB port.
> > > >
> > > > Hence, simplify code to remove the free running counter and
> > > > instead
> > > > use the available vport index during load/unload sequence from
> > > > the
> > > > eswitch.
> > > >
> > > > Signed-off-by: Bodong Wang <bodong@mellanox.com>
> > > > Suggested-by: Parav Pandit <parav@mellanox.com>
> > > > Reviewed-by: Parav Pandit <parav@mellanox.com>
> > >
> > > We are not adding multiple "*-by" for same user, please choose one.
> > >
> > Suggested-by was added by Bodong during our discussion. Later on when
> > I did gerrit +1, RB tag got added.
> >
>
> Is there a rule against having multiple "*-by" ? i don't think so  and
> there shouldn't be, users need to get the exact amount of recognition
> as the amount of work they put into this patch, if they reviewed and
> tested a patch they deserve two tags ..

Not everything in the world has and needs rules, sometimes common sense
is enough. It goes without saying that during internal review process,
developer suggested something. Recognition comes in many ways in the
kernel but definitely not by number of tags with specific developer
name on it, especially if this developer comes from same company
as patch author.

If we extend your claim, both you and me should add this type of
signature block for almost every patch which we submit:

Reviewed-by: ....
Tested-by:  ....
Suggested-by: ...
Signed-by: ...

Thanks

>
>
