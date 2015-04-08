From: Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v3 for-next 01/33] IB/core: Add RoCE GID cache
Date: Wed, 8 Apr 2015 04:10:48 +0000
Message-ID: <7F44EA5110810A40B7DAFB605C41975D58F98121@CMEXMB1.ad.emulex.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
 <44ab0dce-c7c9-400b-af24-10b8981358a7@CMEXHTCAS2.ad.emulex.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FBE792@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FBE792-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

> -----Original Message-----
> From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
> Sent: Wednesday, April 08, 2015 6:00 AM
> To: Somnath Kotur; roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Matan Barak
> Subject: RE: [PATCH v3 for-next 01/33] IB/core: Add RoCE GID cache
> 
> > In order to manage multiple types, vlans and MACs per GID, we need to
> > store them along the GID itself. We store the net device as well, as
> > sometimes GIDs should be handled according to the net device they came
> > from. Since populating the GID table should be identical for every
> > RoCE provider, the GIDs table should be handled in ib_core.
> >
> > Adding a GID cache table that supports a lockless find, add and delete
> > gids. The lockless nature comes from using a unique sequence number
> > per table entry and detecting that while reading/ writing this
> > sequence wasn't changed.
> >
> > By using this RoCE GID cache table, providers must implement a
> > modify_gid callback. The table is managed exclusively by this
> > roce_gid_cache and the provider just need to write the data to the
> > hardware.
> >
> > Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/core/Makefile         |   3 +-
> >  drivers/infiniband/core/core_priv.h      |  24 ++
> >  drivers/infiniband/core/roce_gid_cache.c | 518
> 
> Why does RoCE need such a complex gid cache?  If a gid cache is needed at
> all, why should it be restricted to RoCE only?  And why is such a complex
> synchronization scheme needed?  Seriously, how many times will GIDs
> change and how many readers at once do you expect to have?
> 
> 
> > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h index
> > 65994a1..1866595 100644
> > --- a/include/rdma/ib_verbs.h
> > +++ b/include/rdma/ib_verbs.h
> > @@ -64,6 +64,36 @@ union ib_gid {
> >  	} global;
> >  };
> >
> > +extern union ib_gid zgid;
> > +
> > +enum ib_gid_type {
> > +	/* If link layer is Ethernet, this is RoCE V1 */
> 
> I don't understand this comment.  Does RoCE v2 not run on Ethernet?
> 
Yes, this comment probably could use a reword..
> > +	IB_GID_TYPE_IB        = 0,
> > +	IB_GID_TYPE_ROCE_V2   = 1,
> > +	IB_GID_TYPE_SIZE
> > +};
> 
> Can you explain the purpose of defining a 'GID type'.  A GID is just a global
> address.  Why does it matter to anyone using it how it was constructed?

This is part of RoCE V2 Specification.  Please refer to Section A 17.8 . 
The GID Type determines the protocol for outbound packet generation i.e RoCE V1 (0x8915 Ether Type) or RoCEV2 (IPv4 or IPv6)
> 
> > +
> > +struct ib_gid_attr {
> > +	enum ib_gid_type	gid_type;
> > +	struct net_device	*ndev;
> > +};
> > +
> > +struct ib_roce_gid_cache_entry {
> > +	/* seq number of 0 indicates entry being changed. */
> > +	unsigned int        seq;
> > +	union ib_gid        gid;
> > +	struct ib_gid_attr  attr;
> > +	void		   *context;
> > +};
> > +
> > +struct ib_roce_gid_cache {
> > +	int		     active;
> > +	int                  sz;
> > +	/* locking against multiple writes in data_vec */
> > +	struct mutex         lock;
> > +	struct ib_roce_gid_cache_entry *data_vec; };
> > +
> >  enum rdma_node_type {
> >  	/* IB values map to NodeInfo:NodeType. */
> >  	RDMA_NODE_IB_CA 	= 1,
> > @@ -265,7 +295,9 @@ enum ib_port_cap_flags {
> >  	IB_PORT_BOOT_MGMT_SUP			= 1 << 23,
> >  	IB_PORT_LINK_LATENCY_SUP		= 1 << 24,
> >  	IB_PORT_CLIENT_REG_SUP			= 1 << 25,
> > -	IB_PORT_IP_BASED_GIDS			= 1 << 26
> > +	IB_PORT_IP_BASED_GIDS			= 1 << 26,
> > +	IB_PORT_ROCE				= 1 << 27,
> > +	IB_PORT_ROCE_V2				= 1 << 28,
> 
> Why does RoCE suddenly require a port capability bit?  RoCE runs today
> without setting any bit.
Again, this is part of RoCE V2 SPEC, please refer to Section A17.5.1- Query HCA(Pasting snippet below)
A new "RoCE Supported" capability bit shall be added to the Port Attributes
list. This capability bit applies exclusively to ports of the new
"RoCEv2" type


Thanks
Som
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
