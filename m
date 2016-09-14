From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 21/28] mlx5: Avoid gcc 5.4 warning -Wempty-body
Date: Wed, 14 Sep 2016 10:55:19 -0600
Message-ID: <20160914165519.GC16014@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1473109698-31408-22-git-send-email-jgunthorpe@obsidianresearch.com>
 <6214bd07-f40c-8458-73a2-c07383c5d85a@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6214bd07-f40c-8458-73a2-c07383c5d85a-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 14, 2016 at 07:25:25PM +0300, Yishai Hadas wrote:
> >Which is functionally okay, but strange.
> 
> As you pointed, there is no functional issue with that.

Yet is a common enough errnonous construction to attract a compiler
warning. Don't do it.

Further, it is just a way to attract bit rot in your dbg macros if you
don't check the format string during a normal compile.

> >It is much better to make mlx5_dbg an empty static inline, this way it
> >continues to do parameter type validation even when disabled, and we
> >can drop the sprinkling of #ifdef MLX5_DEBUG everywhere.
> 
> The idea was to have an 'empty' code when this macro is used as some code is
> done in the data path, see below notes.

Yes, I know what the intent was, this change does exactly the same thing.

> >+static inline void mlx5_dbg(FILE *fp, uint32_t mask, const char *fmt, ...)
> >+{
> >+}
> > #endif
> 
> Inline is not guaranteed by the compiler, calling empty function in some
> data data path flows should be prevented.

No compiler we support will leave behind a function call for an empty
static inline.

I just checked, the assembly is the same before/after modulo compiler
non-determinism. There are no extra function calls.

> > enum {
> >diff --git a/libmlx5/src/qp.c b/libmlx5/src/qp.c
> >index c805fcae4123..23270e50af7a 100644
> >+++ b/libmlx5/src/qp.c
> >@@ -356,9 +356,7 @@ static inline int copy_eth_inline_headers(struct ibv_qp *ibqp,
> > 	int inl_hdr_size = MLX5_ETH_L2_INLINE_HEADER_SIZE;
> > 	int inl_hdr_copy_size = 0;
> > 	int j = 0;
> >-#ifdef MLX5_DEBUG
> > 	FILE *fp = to_mctx(ibqp->context)->dbg_fp;
> >-#endif
> 
> This is data path flow, dropping the #ifdef may cause a redundant assignment
> for 'fp' here.

Nope:

$ nm --size libmlx4-rdmv2.so
[before]
0000000000001637 t _mlx5_post_send
[after]
0000000000001637 t _mlx5_post_send

The compilers are very smart, you don't need to hand hold them.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
