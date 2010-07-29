From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] libibverbs: Add reg/unreg I/O memory verbs
Date: Thu, 29 Jul 2010 14:19:44 -0600
Message-ID: <20100729201944.GB7920@obsidianresearch.com>
References: <20100729163030.14901.87547.stgit@build.ogc.int> <20100729163202.14901.44211.stgit@build.ogc.int> <1280434056.6820.136.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1280434056.6820.136.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>, "rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org" <brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, "swise-/Yg/VP3ZvrM@public.gmane.org" <swise-/Yg/VP3ZvrM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 29, 2010 at 01:07:36PM -0700, Ralph Campbell wrote:

> > @@ -640,6 +640,9 @@ struct ibv_context_ops {
> >  					    size_t length,
> >  					    int access);
> >  	int			(*dereg_mr)(struct ibv_mr *mr);
> > +        struct ibv_mr *         (*reg_io_mr)(struct ibv_pd *pd, void *addr, size_t length,
> > +					     int access);
> > +        int                     (*dereg_io_mr)(struct ibv_mr *mr);
> >  	struct ibv_mw *		(*alloc_mw)(struct ibv_pd *pd, enum ibv_mw_type type);
> >  	int			(*bind_mw)(struct ibv_qp *qp, struct ibv_mw *mw,
> >  					   struct ibv_mw_bind *mw_bind);
> 
> Doesn't adding these in the middle of the struct break the
> libibverbs to libxxxverbs.so binary interface?
> Shouldn't they be added at the end of the struct?
> I'm not sure how the versioning works between libibverbs and
> device plugins. Don't we need to protect against libibverbs
> being upgraded but the libxxxverbs.so being older?

Adding them at all, anywhere, breaks the ABI, and needs a soname bump
of libibverbs. Last time this was done a versioned symbol approach was
used to try and keep handling a 1.0 ibv_context structure, but that
only works some times and breaks in corner cases :(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
