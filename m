From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCHv7 7/9] ib_core: Add API to support RoCEE from userspace
Date: Wed, 13 Jan 2010 13:55:41 -0800
Message-ID: <52D379D24301435CB26E9B1FE51DBA57@amr.corp.intel.com>
References: <20100105103322.GI31480@mtls03>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100105103322.GI31480@mtls03>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Eli Cohen' <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Add ib_uverbs_get_mac() to be used by ibv_create_ah() to retirieve the remote
>port's MAC address from the remote port's GID. Port link layer is also returned
>by ibv_query_port().

Is this really to map the GID of a remote port to its MAC address, or is the
mapping for a local port?

If it's the former, then I would expect the functionality to more naturally fall
into ib_addr, with rdma_resolve_addr being the user space interface for this.

>+/**
>+  * ib_get_mac - get the mac address for the specified gid
>+  * @device: IB device used for traffic
>+  * @port: port number used.
>+  * @gid: gid to be resolved into mac
>+  * @mac: mac of the port bearing this gid
>+  */
>+int ib_get_mac(struct ib_device *device, u8 port, u8 *gid, u8 *mac);

Other calls use union ib_gid * where gids are expected.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
