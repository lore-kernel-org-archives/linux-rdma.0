From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ewg] Re: [PATCH] rdmaoe/libibverbs: handle binary
 compatibility
Date: Mon, 14 Dec 2009 10:41:27 +0200
Message-ID: <20091214084127.GB10744@mtls03>
References: <20091210170536.GA3229@mtls03>
 <20091210173353.GW1966@obsidianresearch.com>
 <20091210211455.GA5166@mtls03>
 <C657920367C84928A5A013CC8E49912B@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <C657920367C84928A5A013CC8E49912B-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2009 at 01:50:00PM -0800, Sean Hefty wrote:
> >@@ -306,7 +314,7 @@ static struct pingpong_context *pp_init_ctx(struct
> >ibv_device *ib_dev, int size,
> > 		return NULL;
> > 	}
> >
> >-	memset(ctx->buf, 0, size);
> >+	memset(ctx->buf, 0x7b + is_server, size);
> >
> > 	ctx->context = ibv_open_device(ib_dev);
> > 	if (!ctx->context) {
> >@@ -481,6 +489,7 @@ static void usage(const char *argv0)
> > 	printf("  -n, --iters=<iters>    number of exchanges (default 1000)\n");
> > 	printf("  -l, --sl=<sl>          service level value\n");
> > 	printf("  -e, --events           sleep on CQ events (default poll)\n");
> >+	printf("  -g, --gid=<remote gid> gid of the other port\n");
> 
> It seems easier for the user if the tests discovered its local GID and exchanged
> it with the remote side like it does with the LID and QPN.
>  

Will be changed in the next patch set -- the user will specify the
index to the GID table of the local port.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
