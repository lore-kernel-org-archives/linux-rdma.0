From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 rdma-next 10/29] IB/rxe: Interface to ib_core
Date: Thu, 16 Jun 2016 12:01:31 -0600
Message-ID: <20160616180131.GD23229@obsidianresearch.com>
References: <1466084751-29901-1-git-send-email-monis@mellanox.com>
 <1466084751-29901-11-git-send-email-monis@mellanox.com>
 <00c301d1c7de$09147da0$1b3d78e0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <00c301d1c7de$09147da0$1b3d78e0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, 'Kamal Heib' <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Amir Vadai' <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 16, 2016 at 09:47:41AM -0500, Steve Wise wrote:

> > +/* callbacks from ib_rxe to network interface layer */
> > +struct rxe_ifc_ops {
> > +	void (*release)(struct rxe_dev *rxe);
> > +	__be64 (*node_guid)(struct rxe_dev *rxe);
> > +	__be64 (*port_guid)(struct rxe_dev *rxe);
> > +	struct device *(*dma_device)(struct rxe_dev *rxe);
> > +	int (*mcast_add)(struct rxe_dev *rxe, union ib_gid *mgid);
> > +	int (*mcast_delete)(struct rxe_dev *rxe, union ib_gid *mgid);
> > +	int (*prepare)(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
> > +		       struct sk_buff *skb, u32 *crc);
> > +	int (*send)(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
> > +		    struct sk_buff *skb);
> > +	int (*loopback)(struct sk_buff *skb);
> > +	struct sk_buff *(*init_packet)(struct rxe_dev *rxe, struct rxe_av *av,
> > +				       int paylen, struct rxe_pkt_info *pkt);
> > +	char *(*parent_name)(struct rxe_dev *rxe, unsigned int port_num);
> > +	enum rdma_link_layer (*link_layer)(struct rxe_dev *rxe,
> > +					   unsigned int port_num);
> > +};
> > +
> 
> Why have this layer of indirection to the underlying network ops when there is
> only one underlying network supported?  Seems like overkill...

I have done some work that binds the original version of this stuff to
a non-net device and makes it run as soft-ib.

I can't recall where the hooks ended up, but please consider that use-case.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
