From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [OPENSM] cast to remove warnings about signed vs. unsigned comparisons
Date: Thu, 1 Oct 2009 10:27:15 -0600
Message-ID: <20091001162715.GC22310@obsidianresearch.com>
References: <839303D0FDC14F77AE516FDC9CF8B6A7@amr.corp.intel.com> <20091001155613.GN17846@me> <3F6F638B8D880340AB536D29CD4C1E1912C86E862B@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E1912C86E862B-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 01, 2009 at 09:14:50AM -0700, Smith, Stan wrote:

> Upcoming patches do contain a fair amount of casting for those
> assignment cases where IB defined fields uint8_t/uint16_t are
> assiged from larger sized variable. Will examine code in further
> detail favoring var declaration changes for signed/unsigned
> comparisions.  W.r.t. opensm/* files, the end is in sight. There are
> 18 more patch files coming, will reinspect for less casting.

I've always felt the warning on implicit cast from larger to smaller
type to be somewhat useless - that is an unavoidable operation when
working with networking. Adding casts does nothing to actually improve
the code, and trying to change to smaller types results in worse code
gen and no improvement in function.

Maybe OFW would be better off just turning that warning off? :)

> > In general to simplify a detection of such cases we can consider to
> > use -Wsign-compare gcc flag in linux environment.

And -Wsign-conversion

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
