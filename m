From: Parav Pandit <parav@mellanox.com>
Subject: RE: [PATCH rdma] IB/cache: Restore compatibility for ib_query_gid
Date: Fri, 27 Jul 2018 16:11:20 +0000
Message-ID: <VI1PR0502MB3008B2E503A83C20E00C0451D12A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20180727155402.GA15253@ziepe.ca>
 <VI1PR0502MB3008B0D78AB418E263819EE7D12A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20180727160904.GE9497@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180727160904.GE9497@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ursula Braun <ubraun@linux.ibm.com>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Friday, July 27, 2018 11:09 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: linux-rdma@vger.kernel.org; Stephen Rothwell <sfr@canb.auug.org.au>;
> David Miller <davem@davemloft.net>; Networking <netdev@vger.kernel.org>;
> Doug Ledford <dledford@redhat.com>; Linux-Next Mailing List <linux-
> next@vger.kernel.org>; Linux Kernel Mailing List <linux-
> kernel@vger.kernel.org>; Ursula Braun <ubraun@linux.ibm.com>; Leon
> Romanovsky <leonro@mellanox.com>
> Subject: Re: [PATCH rdma] IB/cache: Restore compatibility for ib_query_gi=
d
>=20
> On Fri, Jul 27, 2018 at 04:04:33PM +0000, Parav Pandit wrote:
> >
> >
> > > From: Jason Gunthorpe
> > > Sent: Friday, July 27, 2018 10:54 AM
> > > To: linux-rdma@vger.kernel.org; Stephen Rothwell
> > > <sfr@canb.auug.org.au>
> > > Cc: David Miller <davem@davemloft.net>; Networking
> > > <netdev@vger.kernel.org>; Doug Ledford <dledford@redhat.com>;
> > > Linux-Next Mailing List <linux-next@vger.kernel.org>; Linux Kernel
> > > Mailing List <linux- kernel@vger.kernel.org>; Parav Pandit
> > > <parav@mellanox.com>; Ursula Braun <ubraun@linux.ibm.com>; Leon
> > > Romanovsky <leonro@mellanox.com>; linux- rdma@vger.kernel.org
> > > Subject: [PATCH rdma] IB/cache: Restore compatibility for
> > > ib_query_gid
> > >
> > > Code changes in smc have become so complicated this cycle that the
> > > RDMA patches to remove ib_query_gid in smc create too complex merge
> conflicts.
> > > Allow those conflicts to be resolved by using the net/smc hunks by
> > > providing a compatibility wrapper. During the second phase of the
> > > merge window this wrapper will be deleted and smc updated to use the =
new
> API.
> > >
> > > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > > Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> > > include/rdma/ib_cache.h | 24 ++++++++++++++++++++++++
> > >  1 file changed, 24 insertions(+)
> > >
> > > The resolution Stephen had to make is too complicated, I think we
> > > should go this way instead. Parav can send a patch to DaveM during
> > > the 2nd half of the merge window to safely update SMC and delete this
> wrapper.
> > >
> > Last night Stephen send the changes, if Ursula can test it, its
> > preferred but if that is not possible, I am with below approach too.
>=20
> Thing is one of us has to explain to Linus how to handle this conflict, a=
s
> Stephen's resolutions do not automatically go him.
>=20
> Given how much new code the resolution introduces, I prefer to not send i=
t to
> Linus..
>=20
Ok. Sounds good.

> > > Parav, can you check this?
> > >
> > > Ursula, this is only for SMC, are you able to test SMC with it? You
> > > will need to apply it to the RDMA tree here:
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h
> > > =3Dfor-next
> > >
> > > Thanks,
> > > Jason
> > >
> > > diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h index
> > > 1108d422027696..c7e9b42b96e5b8 100644
> > > +++ b/include/rdma/ib_cache.h
> > > @@ -132,4 +132,28 @@ const struct ib_gid_attr
> > > *rdma_get_gid_attr(struct ib_device *device,
> > >  					    u8 port_num, int index);
> > >  void rdma_put_gid_attr(const struct ib_gid_attr *attr);  void
> > > rdma_hold_gid_attr(const struct ib_gid_attr *attr);
> > > +
> > > +/*
> > > + * This is to be removed. It only exists to make merging rdma and sm=
c
> simpler.
> > > + */
> > > +static inline __deprecated int ib_query_gid(struct ib_device *device=
,
> > > +					    u8 port_num, int index,
> > > +					    union ib_gid *gid,
> > > +					    struct ib_gid_attr *attr_out) {
> > > +	const struct ib_gid_attr *attr;
> > > +
> > > +	attr =3D rdma_get_gid_attr(device,port_num,index);
> > White space after each variable is needed to avoid warnings.
>=20
> Woops, no problem.
>=20
> > > +	if (IS_ERR(attr))
> > > +		return PTR_ERR(attr);
> > > +
> > > +	if (attr->ndev)
> > > +		dev_hold(attr->ndev);
> > > +	*attr_out =3D *attr;
> > > +
> > > +	rdma_put_gid_attr(attr);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > >  #endif /* _IB_CACHE_H */
> >
> > Rest looks fine.
> > RB: parav@mellanox.com
>=20
> In future please spell out the Reviewed-by - patchworks will automate col=
lecting
> the tags and add it to the patch, otherwise maintainers have to do it by =
hand.
>=20
I see. I will do it correctly now on using Reviewed-by.

> Thanks,
> Jason
