From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [PATCH v3 10/28] IB/Verbs: Reform cm related part in IB-core cma
Date: Mon, 13 Apr 2015 20:31:06 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FC0B58@ORSMSX109.amr.corp.intel.com>
References: <552BB470.4090407@profitbricks.com>
 <552BB60F.60109@profitbricks.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FC0ACF@ORSMSX109.amr.corp.intel.com>
 <20150413195040.GB19112@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150413195040.GB19112@obsidianresearch.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Michael Wang <yun.wang@profitbricks.com>, Roland Dreier <roland@kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, infinipath <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, "Latif, Faisal" <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, "Weiny, Ira" <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

> On Mon, Apr 13, 2015 at 07:25:48PM +0000, Hefty, Sean wrote:
> > > @@ -1037,17 +1033,13 @@ void rdma_destroy_id(struct rdma_cm_id *id)
> > >  	mutex_unlock(&id_priv->handler_mutex);
> > >
> > >  	if (id_priv->cma_dev) {
> > > -		switch (rdma_node_get_transport(id_priv->id.device-
> > > >node_type)) {
> > > -		case RDMA_TRANSPORT_IB:
> > > +		if (rdma_ib_or_iboe(id_priv->id.device, id_priv->id.port_num))
> >
> > A listen id can be associated with a device without being associated
> > with a port (see the listen_any_list).  Some other check is needed
> > to handle this case.  I guess the code could check the first port on
> > the device (replace port_num with hardcoded value 1).  Then we
> > wouldn't be any more broken than the code already is.  (The 'break'
> > is conceptual, not practical.)
> 
> Hum. So, devices on a port must have some compatibility when it comes
> to these invariants. It looks like all ports must have the same
> iwarpyness, for multiple reasons.
> 
> Less clear is how rocee vs ib work within a device... Can you APM
> between those two kinds of ports?

No idea

> All these switches are so ugly :| Function pointers setup in
> iw_/ib_create_cm_id would be a lot clearer and safer.

I noticed this too.  The if checks throughout the cma are becoming unmaintainable.  It may be cleaner if all devices adopted using the cm device function pointers.

> > This appears to be highlighting an architectural flaw in the iboe
> integration.
> 
> You mean iwarp?

I meant iboe.  Wildcard listens map to multiple listens, one per device.  The assumption being that all ports on the device are the same.  IBoE changed that assumption.
