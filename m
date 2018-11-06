From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma] net/mlx5: Fix XRC SRQ umem valid bits
Date: Tue, 6 Nov 2018 22:02:13 +0000
Message-ID: <20181106220206.GC30490@mellanox.com>
References: <20181031102028.9142-1-leon@kernel.org>
 <cb4d41e3a24c667c5c4e0492d3d3b21a5a165919.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cb4d41e3a24c667c5c4e0492d3d3b21a5a165919.camel@redhat.com>
Content-Language: en-US
Content-ID: <7FFD0158A0333846ADDBC1F908141342@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>, Yishai Hadas <yishaih@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 06, 2018 at 04:31:08PM -0500, Doug Ledford wrote:
> On Wed, 2018-10-31 at 12:20 +0200, Leon Romanovsky wrote:
> > From: Yishai Hadas <yishaih@mellanox.com>
> >=20
> > Adapt XRC SRQ to the latest HW specification with fixed definition
> > around umem valid bits. The previous definition relied on a bit which
> > was taken for other purposes in legacy FW.
> >=20
> > Fixes: bd37197554eb ("net/mlx5: Update mlx5_ifc with DEVX UID bits")
> > Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> > Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > Hi Doug, Jason
> >=20
> > This commit fixes code sent in this merge window, so I'm not marking it
> > with any rdma-rc/rdma-next. It will be better to be sent during this me=
rge
> > window if you have extra pull request to issue, or as a -rc material, i=
f
> > not.
> >=20
> > BTW, we didn't combine reserved fields, because our convention is to al=
ign such
> > fields to 32 bits for better readability.
> >=20
> > Thanks
>=20
> This looks fine.  Let me know when it's in the mlx5-next tree to pull.

It needs to go to -rc...=20

This needs a mlx5-rc branch for this I guess?

Jason=20
