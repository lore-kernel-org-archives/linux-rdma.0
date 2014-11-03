From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs] Add MR re-registeration
Date: Mon, 3 Nov 2014 12:20:49 -0700
Message-ID: <20141103192049.GC24412@obsidianresearch.com>
References: <1414920605-18943-1-git-send-email-ogerlitz@mellanox.com>
 <20141103025049.GA31929@obsidianresearch.com>
 <54573CA9.8060202@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54573CA9.8060202-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 03, 2014 at 10:28:25AM +0200, Matan Barak wrote:
> On 3/11/2014 4:50 AM, Jason Gunthorpe wrote:
> >On Sun, Nov 02, 2014 at 11:30:05AM +0200, Or Gerlitz wrote:
> >
> >>@@ -886,7 +887,7 @@ struct ibv_context_ops {
> >>  	int			(*dealloc_pd)(struct ibv_pd *pd);
> >>  	struct ibv_mr *		(*reg_mr)(struct ibv_pd *pd, void *addr, size_t length,
> >>  					  int access);
> >>-	struct ibv_mr *		(*rereg_mr)(struct ibv_mr *mr,
> >>+	int			(*rereg_mr)(struct ibv_mr *mr,
> >>  					    int flags,
> >>  					    struct ibv_pd *pd, void *addr,
> >>  					    size_t length,
> >
> >What is going on here?
> >
> >Signatures in the ops structure should not be changed without quite a
> >bit more explanation. I'd like to see this in a dedicated patch with a
> >proper discussion about why it is safe...

> I don't mind re-spin this change into another patch, but since I
> don't consider the current state of libibverbs as having memory
> re-registration support, I don't think it's necessary.

Even so, this changes ABI senstive structures so it needs to be in a
dedicated patch and you must include this rational for why it is safe.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
