From: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 1/2] Protect larger order pages from breaking up
Date: Fri, 16 Feb 2018 12:25:27 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1802161224530.11268@nuc-kabylake>
References: <20180216160110.641666320@linux.com> <20180216160121.519788537@linux.com> <20180216170354.vpbuugzqsrrfc4js@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180216170354.vpbuugzqsrrfc4js-1g7Xle2YJi4/4alezvVtWx2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Cc: Mel Gorman <mel-wJa12IhQEiizQB+pC5nmwQ@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Thomas Schoebel-Theuer <tst-0Nly+W1lFbFDiq0p6IFu4YQuADTiUCJX@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Nellans <dnellans-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 16 Feb 2018, Andi Kleen wrote:

> > First performance tests in a virtual enviroment show
> > a hackbench improvement by 6% just by increasing
> > the page size used by the page allocator to order 3.
>
> So why is hackbench improving? Is that just for kernel stacks?

Less stack overhead. The large the page size the less metadata need to be
handled. The freelists get larger and the chance of hitting the per cpu
freelist increases.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
