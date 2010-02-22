From: "Vu Pham" <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [ewg] nfsrdma fails to write big file,
Date: Mon, 22 Feb 2010 12:22:42 -0800
Message-ID: <9FA59C95FFCBB34EA5E42C1A8573784F02662EA8@mtiexch01.mti.com>
References: <9FA59C95FFCBB34EA5E42C1A8573784F02662E58@mtiexch01.mti.com> <4B82D1B4.2030902@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mahesh Siddheshwar <siddheshwar.mahesh-xsfywfwIY+M@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Tom,

Some more info on the problem:
1. Running with memreg=4 (FMR) I can not reproduce the problem
2. I also see different error on client

Feb 22 12:16:55 mellanox-2 rpc.idmapd[5786]: nss_getpwnam: name 'nobody'
does not map into domain 'localdomain' 
Feb 22 12:16:55 mellanox-2 kernel: QP 0x70004b: WQE overflow
Feb 22 12:16:55 mellanox-2 kernel: QP 0x6c004a: WQE overflow
Feb 22 12:16:55 mellanox-2 kernel: QP 0x6c004a: WQE overflow
Feb 22 12:16:55 mellanox-2 kernel: RPC: rpcrdma_ep_post: ib_post_send
returned -12 cq_init 48 cq_count 32
Feb 22 12:17:00 mellanox-2 kernel: RPC:       rpcrdma_event_process:
send WC status 5, vend_err F5
Feb 22 12:17:00 mellanox-2 kernel: rpcrdma: connection to
13.20.1.9:20049 closed (-103)

-vu

> -----Original Message-----
> From: Tom Tucker [mailto:tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org]
> Sent: Monday, February 22, 2010 10:49 AM
> To: Vu Pham
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Mahesh Siddheshwar;
> ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> Subject: Re: [ewg] nfsrdma fails to write big file,
> 
> Vu Pham wrote:
> > Setup:
> > 1. linux nfsrdma client/server with OFED-1.5.1-20100217-0600,
> ConnectX2
> > QDR HCAs fw 2.7.8-6, RHEL 5.2.
> > 2. Solaris nfsrdma server svn 130, ConnectX QDR HCA.
> >
> >
> > Running vdbench on 10g file or *dd if=/dev/zero of=10g_file bs=1M
> > count=10000*, operation fail, connection get drop, client cannot
> > re-establish connection to server.
> > After rebooting only the client, I can mount again.
> >
> > It happens with both solaris and linux nfsrdma servers.
> >
> > For linux client/server, I run memreg=5 (FRMR), I don't see problem
> with
> > memreg=6 (global dma key)
> >
> >
> 
> Awesome. This is the key I think.
> 
> Thanks for the info Vu,
> Tom
> 
> 
> > On Solaris server snv 130, we see problem decoding write request of
> 32K.
> > The client send two read chunks (32K & 16-byte), the server fail to
> do
> > rdma read on the 16-byte chunk (cqe.status = 10 ie.
> > IB_WC_REM_ACCCESS_ERROR); therefore, server terminate the
connection.
> We
> > don't see this problem on nfs version 3 on Solaris. Solaris server
> run
> > normal memory registration mode.
> >
> > On linux client, I see cqe.status = 12 ie. IB_WC_RETRY_EXC_ERR
> >
> > I added these notes in bug #1919 (bugs.openfabrics.org) to track the
> > issue.
> >
> > thanks,
> > -vu
> > _______________________________________________
> > ewg mailing list
> > ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> > http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
> >

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
