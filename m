From: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH 14/14] SIWv2: Documentation: siw.txt
Date: Mon, 20 Jun 2011 14:52:05 +0200
Message-ID: <OF45BC90D6.AE8F5104-ONC12578B5.0045FDBF-C12578B5.0046B034@ch.ibm.com>
References: <4DFD8357.3090406@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DFD8357.3090406-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Agreed. In any case, I am convinced debug stuff must go away from sysfs.
debugfs is one good idea. Since I was building also for older
kernels, IB netlink infrastructure was not an option yet. Let
me look into IB netlink.

many thanks,
Bernard.

linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org wrote on 06/19/2011 07:04:23 AM:

> Bernard Metzler wrote:
>
> > +/sys/class/infiniband/siw*/stats:
> > +   Summary of allocated WQE's, PD's, QP's, CQ's, SRQ's, MR's, CEP's.
> > +   WQE statistics are not gathered if 'DPRINT_MASK' is set to '0'
> > +/sys/class/infiniband/siw*/qp:
> > +   Summary of allocated queue pairs. If queue pairs are allocated,
> > +   after reading 'qp' a more detailed status of all queue pairs has
> > +/sys/class/infiniband/siw*/cep:
> > +   Summary of allocated connection end points. If connection endpoints
> > +   are allocated, after reading 'cep' a more detailed status of all
> > +   CEP's is printed to the kernel syslog and can be retrieved via
>
> any reason not to use the IB stack netlink infrastructure to support
> these counters?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
