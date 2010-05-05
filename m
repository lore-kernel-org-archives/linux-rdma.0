From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] [PATCHv8 02/11] ib_core: IBoE support only QP1
Date: Wed, 05 May 2010 16:12:15 -0700
Message-ID: <ada1vdqaqpc.fsf@roland-alpha.cisco.com>
References: <20100218172344.GC12286@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100218172344.GC12286@mtls03> (Eli Cohen's message of "Thu, 18
	Feb 2010 19:23:44 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > @@ -795,11 +799,12 @@ static void mcast_add_one(struct ib_device *device)
 >  	struct mcast_device *dev;
 >  	struct mcast_port *port;
 >  	int i;
 > +	int count = 0;
 >  
 >  	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
 >  		return;
 >  
 > -	dev = kmalloc(sizeof *dev + device->phys_port_cnt * sizeof *port,
 > +	dev = kzalloc(sizeof *dev + device->phys_port_cnt * sizeof *port,

 > @@ -1007,7 +1010,7 @@ static void ib_sa_add_one(struct ib_device *device)
 >  		e = device->phys_port_cnt;
 >  	}
 >  
 > -	sa_dev = kmalloc(sizeof *sa_dev +
 > +	sa_dev = kzalloc(sizeof *sa_dev +

Do you happen to remember why you needed these kmalloc -> kzalloc conversions?
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
