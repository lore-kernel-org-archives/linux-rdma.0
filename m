From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ewg] Re: [PATCH] rdmaoe/libibverbs: handle binary
	compatibility
Date: Mon, 14 Dec 2009 12:14:09 -0700
Message-ID: <20091214191409.GU6188@obsidianresearch.com>
References: <20091210170536.GA3229@mtls03> <20091210173353.GW1966@obsidianresearch.com> <20091210211455.GA5166@mtls03> <C657920367C84928A5A013CC8E49912B@amr.corp.intel.com> <20091214084127.GB10744@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091214084127.GB10744@mtls03>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 14, 2009 at 10:41:27AM +0200, Eli Cohen wrote:
> On Thu, Dec 10, 2009 at 01:50:00PM -0800, Sean Hefty wrote:
> > >@@ -306,7 +314,7 @@ static struct pingpong_context *pp_init_ctx(struct
> > >ibv_device *ib_dev, int size,
> > > 		return NULL;
> > > 	}
> > >
> > >-	memset(ctx->buf, 0, size);
> > >+	memset(ctx->buf, 0x7b + is_server, size);
> > >
> > > 	ctx->context = ibv_open_device(ib_dev);
> > > 	if (!ctx->context) {
> > >@@ -481,6 +489,7 @@ static void usage(const char *argv0)
> > > 	printf("  -n, --iters=<iters>    number of exchanges (default 1000)\n");
> > > 	printf("  -l, --sl=<sl>          service level value\n");
> > > 	printf("  -e, --events           sleep on CQ events (default poll)\n");
> > >+	printf("  -g, --gid=<remote gid> gid of the other port\n");
> > 
> > It seems easier for the user if the tests discovered its local GID and exchanged
> > it with the remote side like it does with the LID and QPN.
> >  
> 
> Will be changed in the next patch set -- the user will specify the
> index to the GID table of the local port.

It would be nice if the tools would consistently let you choose the
source device based on gid.. I've been meaning to make a patch for
verbs to add a ibv_open_device_by_gid() function or something like
that.

Using gid idx is pretty unfriendly ...

But it is just a test prorgam, no worries.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
