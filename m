From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv7 7/9] ib_core: Add API to support RoCEE from userspace
Date: Sun, 17 Jan 2010 10:13:47 +0200
Message-ID: <20100117081347.GA30297@mtls03>
References: <20100105103322.GI31480@mtls03>
 <52D379D24301435CB26E9B1FE51DBA57@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52D379D24301435CB26E9B1FE51DBA57-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Eli Cohen' <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 13, 2010 at 01:55:41PM -0800, Sean Hefty wrote:
> >Add ib_uverbs_get_mac() to be used by ibv_create_ah() to retirieve the remote
> >port's MAC address from the remote port's GID. Port link layer is also returned
> >by ibv_query_port().
> 
> Is this really to map the GID of a remote port to its MAC address, or is the
> mapping for a local port?
> 
> If it's the former, then I would expect the functionality to more naturally fall
> into ib_addr, with rdma_resolve_addr being the user space interface for this.

Actually the intention is that this API will resolve any GID, local
or remote, to the port's MAC address. I am not sure if
rdma_resolve_addr() is a good choice for this task since it involves
sockets stuff; and if we want to utilize this API for pure IB verbs
then that would be inappropriate.

> 
> >+/**
> >+  * ib_get_mac - get the mac address for the specified gid
> >+  * @device: IB device used for traffic
> >+  * @port: port number used.
> >+  * @gid: gid to be resolved into mac
> >+  * @mac: mac of the port bearing this gid
> >+  */
> >+int ib_get_mac(struct ib_device *device, u8 port, u8 *gid, u8 *mac);
> 
> Other calls use union ib_gid * where gids are expected.

Agree. Will change this.
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
