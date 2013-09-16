From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rsockets addressing
Date: Mon, 16 Sep 2013 15:44:40 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CC0B81@ORSMSX109.amr.corp.intel.com>
References: <CAJH6TXhY---UhpvsquYrNXBc5ji_hYp7zJ+CwRrfy-naM_aGaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXhY---UhpvsquYrNXBc5ji_hYp7zJ+CwRrfy-naM_aGaA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> which kind of system is used by rsockets to address the remote host?
> Is using IPoIB ?

rsockets is built over the RDMA CM.  The rdma cm uses ipoib indirectly when connecting over IB, by mapping the IP addresses to GIDs.

rsockets can also support using native IB addresses, though this is a new feature which requires the latest kernel and upstream, but unreleased rsockets code.
 
> Will I be able to support two redundant fabrics with failover managed
> by OpenSM with rsockets ?
> For example, two nodes connected (with 2 HBA on each) to two different
> IB fabrics.
> In case of an HBA failure, will rsocket be able to re-establish a
> connected using the second fabric ?

rsockets does not implement failover.  An application would need to reestablish a connection in the case of a failure.  I have not looked to see what it would take to implement failover inside rsockets, and that's not something I would have time to implement anytime soon.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
