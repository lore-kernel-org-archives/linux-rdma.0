From: "Christian Benvenuti (benve)" <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 2/2] IB/core: Add generic function to extract IB speed
 from netdev
Date: Wed, 14 Jun 2017 15:04:43 +0000
Message-ID: <e61752e6cd164574b08161ae5f4c43f6@XCH-RCD-017.cisco.com>
References: <20170611054450.7221-1-yuval.shaia@oracle.com>
 <20170611054450.7221-3-yuval.shaia@oracle.com>
 <e58c9e7782774aa1b710b779c44f918d@XCH-RCD-017.cisco.com>
 <20170614130235.GB3329@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170614130235.GB3329@yuvallap>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Dave Goodell (dgoodell)" <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org" <sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org>, "bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, yishaih@
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Yuval Shaia [mailto:yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> Sent: Wednesday, June 14, 2017 6:03 AM
> To: Christian Benvenuti (benve)
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org;
> selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org; devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org;
> somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org; sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org; Dave Good=
ell
> (dgoodell); monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org;
> dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org;
> bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org; yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TasMV2rI37PzA@public.gmane.org=
org
> Subject: Re: [PATCH v3 2/2] IB/core: Add generic function to extract IB s=
peed
> from netdev
>=20
> On Tue, Jun 13, 2017 at 08:07:48AM +0000, Christian Benvenuti (benve) wro=
te:
> > >
> > > +int ib_get_eth_speed(struct ib_device *dev, u8 port_num, u8 *speed, =
u8
> > > +*width) {
> > > +	int rc;
> > > +	u32 netdev_speed;
> > > +	struct net_device *netdev;
> > > +	struct ethtool_link_ksettings lksettings;
> > > +
> > > +	if (rdma_port_get_link_layer(dev, port_num) !=3D IB_LINK_LAYER_ETHE=
RNET)
> > > +		return -EINVAL;
> > > +
> > > +	if (!dev->get_netdev)
> > > +		return -EINVAL;
> >
> > -EOPNOTSUPP ?
>=20
> Looks better.
> Assuming the same should be for the above one and the one below, right?

I am not sure about the other two:
- rdma_port_get_link_layer() does not entirely depend on ib_device->get_lin=
k_layer()
- ib_device->get_netdev() can fail for different reasons I guess

/Chris

> >
> > > +	netdev =3D dev->get_netdev(dev, port_num);
> > > +	if (!netdev)
> > > +		return -EINVAL;
> > > +
> > > +	rtnl_lock();
> > > +	rc =3D __ethtool_get_link_ksettings(netdev, &lksettings);
> > > +	rtnl_unlock();
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
