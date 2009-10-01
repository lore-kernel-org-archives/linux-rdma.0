From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [OPENSM] cast to remove warnings about signed vs. unsigned
 comparisons
Date: Thu, 1 Oct 2009 19:02:12 +0200
Message-ID: <20091001170212.GR17846@me>
References: <839303D0FDC14F77AE516FDC9CF8B6A7@amr.corp.intel.com>
 <20091001155613.GN17846@me>
 <3F6F638B8D880340AB536D29CD4C1E1912C86E862B@orsmsx501.amr.corp.intel.com>
 <20091001162715.GC22310@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091001162715.GC22310-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10:27 Thu 01 Oct     , Jason Gunthorpe wrote:
> 
> I've always felt the warning on implicit cast from larger to smaller
> type to be somewhat useless - that is an unavoidable operation when
> working with networking. Adding casts does nothing to actually improve
> the code, and trying to change to smaller types results in worse code
> gen and no improvement in function.

In general I would agree, but in case of OpenSM we are not in so
excellent state where fixed size int types are always used for a reason.
For instance a code like:

	int32_t i;

	for (i = 0; i < SOME_CONST; i++)
		do_something(array[i]);

is not so uncommon.

I would prefer to use generic int types where is possible and fixed
sized where is needed. And then yes - to ignore "int casting" warning
seems fine for me.

This could be true, but not always in our case - OpenSM code base has a
lot of fixed sized types unmotivated case where 

> Maybe OFW would be better off just turning that warning off? :)

To minimize a porting efforts it could be an option.

> > > In general to simplify a detection of such cases we can consider to
> > > use -Wsign-compare gcc flag in linux environment.
> 
> And -Wsign-conversion

Yes.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
