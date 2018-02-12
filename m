From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC] Protect larger order pages from breaking up
Date: Mon, 12 Feb 2018 09:36:30 -0800
Message-ID: <20180212173630.GB9396@bombadil.infradead.org>
References: <alpine.DEB.2.20.1802091311090.3059@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1802091311090.3059@nuc-kabylake>
Sender: owner-linux-mm@kvack.org
To: Christopher Lameter <cl@linux.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org, akpm@linux-foundation.org, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 09, 2018 at 01:24:41PM -0600, Christopher Lameter wrote:
> Control over this feature is by writing to /proc/zoneinfo.
> 
> F.e. to ensure that 2000 16K pages stay available for jumbo
> frames do
> 
> 	echo "3=2000" >/proc/zoneinfo

That seems ... wrong.  4k is order 0, 8k is order 1, 16k is order 2,
32k is order 3.

> One can then also f.e. operate the slub allocator with
> 64k pages. Specify "slub_max_order=3 slub_min_order=3" on
> the kernel command line and all slab allocator allocations
> will occur in 16K page sizes.

This example also reads weird ;-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
