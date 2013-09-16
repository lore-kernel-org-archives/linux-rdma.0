From: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: rsockets addressing
Date: Mon, 16 Sep 2013 15:25:59 +0200
Message-ID: <CAJH6TXhY---UhpvsquYrNXBc5ji_hYp7zJ+CwRrfy-naM_aGaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi to all,
which kind of system is used by rsockets to address the remote host?
Is using IPoIB ?

Will I be able to support two redundant fabrics with failover managed
by OpenSM with rsockets ?
For example, two nodes connected (with 2 HBA on each) to two different
IB fabrics.
In case of an HBA failure, will rsocket be able to re-establish a
connected using the second fabric ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
