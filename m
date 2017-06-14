From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/2] IB/core: Add generic function to extract IB speed
 from netdev
Date: Wed, 14 Jun 2017 23:00:36 +0300
Message-ID: <20170614200035.GA2872@yuvallap>
References: <20170611054450.7221-1-yuval.shaia@oracle.com>
 <20170611054450.7221-3-yuval.shaia@oracle.com>
 <e58c9e7782774aa1b710b779c44f918d@XCH-RCD-017.cisco.com>
 <20170614130235.GB3329@yuvallap>
 <e61752e6cd164574b08161ae5f4c43f6@XCH-RCD-017.cisco.com>
 <20170614191406.GA2375@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170614191406.GA2375@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Christian Benvenuti (benve)" <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Dave Goodell (dgoodell)" <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org" <sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org>, "bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, yishaih@
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 14, 2017 at 10:14:07PM +0300, Yuval Shaia wrote:
> On Wed, Jun 14, 2017 at 03:04:43PM +0000, Christian Benvenuti (benve) wrote:
> > > -----Original Message-----
> > > From: Yuval Shaia [mailto:yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> > > Sent: Wednesday, June 14, 2017 6:03 AM
> > > To: Christian Benvenuti (benve)
> > > Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org;
> > > selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org; devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org;
> > > somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org; sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org; Dave Goodell
> > > (dgoodell); monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org;
> > > dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org;
> > > bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org; yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Subject: Re: [PATCH v3 2/2] IB/core: Add generic function to extract IB speed
> > > from netdev
> > > 
> > > On Tue, Jun 13, 2017 at 08:07:48AM +0000, Christian Benvenuti (benve) wrote:
> > > > >
> > > > > +int ib_get_eth_speed(struct ib_device *dev, u8 port_num, u8 *speed, u8
> > > > > +*width) {
> > > > > +	int rc;
> > > > > +	u32 netdev_speed;
> > > > > +	struct net_device *netdev;
> > > > > +	struct ethtool_link_ksettings lksettings;
> > > > > +
> > > > > +	if (rdma_port_get_link_layer(dev, port_num) != IB_LINK_LAYER_ETHERNET)
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	if (!dev->get_netdev)
> > > > > +		return -EINVAL;
> > > >
> > > > -EOPNOTSUPP ?
> > > 
> > > Looks better.
> > > Assuming the same should be for the above one and the one below, right?
> > 
> > I am not sure about the other two:
> > - rdma_port_get_link_layer() does not entirely depend on ib_device->get_link_layer()
> > - ib_device->get_netdev() can fail for different reasons I guess
> 
> I see,
> 
> So back to your proposal, the fact that dev->get_netdev is not set means
> that the IB device is not relayed on Ethernet one (RoCE folks, correct me
> if i'm wrong) so with the given input - the operation is not supported. Is
> that means that -EINVAL is better than -EOPNOTSUPP?
> 
> As far as the name suggest, EINVAL is where input values are wrong while
> EOPNOTSUPP is where input values are fine but the operation is not
> supported.

Please ignore, i looked at some other places.
Will post v4 soon.

> 
> Yuval
> 
> > 
> > /Chris
> > 
> > > >
> > > > > +	netdev = dev->get_netdev(dev, port_num);
> > > > > +	if (!netdev)
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	rtnl_lock();
> > > > > +	rc = __ethtool_get_link_ksettings(netdev, &lksettings);
> > > > > +	rtnl_unlock();
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
