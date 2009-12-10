From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ewg] Re: [PATCH] rdmaoe/libibverbs: handle binary compatibility
Date: Thu, 10 Dec 2009 13:50:00 -0800
Message-ID: <C657920367C84928A5A013CC8E49912B@amr.corp.intel.com>
References: <20091210170536.GA3229@mtls03> <20091210173353.GW1966@obsidianresearch.com> <20091210211455.GA5166@mtls03>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091210211455.GA5166@mtls03>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Eli Cohen' <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>@@ -306,7 +314,7 @@ static struct pingpong_context *pp_init_ctx(struct
>ibv_device *ib_dev, int size,
> 		return NULL;
> 	}
>
>-	memset(ctx->buf, 0, size);
>+	memset(ctx->buf, 0x7b + is_server, size);
>
> 	ctx->context = ibv_open_device(ib_dev);
> 	if (!ctx->context) {
>@@ -481,6 +489,7 @@ static void usage(const char *argv0)
> 	printf("  -n, --iters=<iters>    number of exchanges (default 1000)\n");
> 	printf("  -l, --sl=<sl>          service level value\n");
> 	printf("  -e, --events           sleep on CQ events (default poll)\n");
>+	printf("  -g, --gid=<remote gid> gid of the other port\n");

It seems easier for the user if the tests discovered its local GID and exchanged
it with the remote side like it does with the LID and QPN.
 
>diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
>index 0db083a..8ef8844 100644

>
> /*
>@@ -223,7 +224,8 @@ struct ibv_query_port_resp {
> 	__u8  active_width;
> 	__u8  active_speed;
> 	__u8  phys_state;
>-	__u8  reserved[3];
>+	__u8  link_layer;
>+	__u8  reserved[2];
> };

Should we define the network layer too?  Right now we have IB transport, which
assumes IB network and link; iWarp transport, which almost assumes IP network
and Ethernet; and RDMAoE, which may or may not have a network (but requires the
L3 address) and Ethernet (or is it DCB) link.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
