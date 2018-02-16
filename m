From: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 1/2] Protect larger order pages from breaking up
Date: Fri, 16 Feb 2018 14:13:12 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1802161411440.11934@nuc-kabylake>
References: <20180216160110.641666320@linux.com> <20180216160121.519788537@linux.com> <5108eb20-2b20-bd48-903e-bce312e96974@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5108eb20-2b20-bd48-903e-bce312e96974-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Mel Gorman <mel-wJa12IhQEiizQB+pC5nmwQ@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Thomas Schoebel-Theuer <tst-0Nly+W1lFbFDiq0p6IFu4YQuADTiUCJX@public.gmane.org>, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Nellans <dnellans-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 16 Feb 2018, Mike Kravetz wrote:

> > Well that f.e brings up huge pages. You can of course
> > also use this to reserve those and can then be sure that
> > you can dynamically resize your huge page pools even after
> > a long time of system up time.
>
> Yes, and no.  Doesn't that assume nobody else is doing allocations
> of that size?  For example, I could image THP using huge page sized
> reservations.  The when it comes time to resize your hugetlbfs pool
> there may not be enough.  Although, we may quickly split THP pages
> in this case.  I am not sure.

Yup it has a pool for everyone. Question is how to divide the loot ;-)

> IIRC, Guy Shattah's use case was for allocations greater than MAX_ORDER.
> This would not directly address that.  A huge contiguous area (2GB) is
> the sweet spot' for best performance in his case.  However, I think he
> could still benefit from using a set of larger (such as 2MB) size
> allocations which this scheme could help with.

MAX_ORDER can be increased to allow for larger allocations. IA64 has f.e.
a much larger MAX_ORDER size. So does powerpc. And then the reservation
scheme will work.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
