From: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Protect larger order pages from breaking up
Date: Mon, 12 Feb 2018 12:37:33 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1802121236220.13366@nuc-kabylake>
References: <alpine.DEB.2.20.1802091311090.3059@nuc-kabylake> <20180212173630.GB9396@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180212173630.GB9396-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Schoebel-Theuer <tst-0Nly+W1lFbFDiq0p6IFu4YQuADTiUCJX@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 12 Feb 2018, Matthew Wilcox wrote:

> > One can then also f.e. operate the slub allocator with
> > 64k pages. Specify "slub_max_order=3 slub_min_order=3" on
> > the kernel command line and all slab allocator allocations
> > will occur in 16K page sizes.
>
> This example also reads weird ;-)

Right, this resulted in 32K page reservations and uses.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
