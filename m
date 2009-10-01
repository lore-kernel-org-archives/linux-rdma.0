From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [OPENSM] cast to remove warnings about signed vs. unsigned
	comparisons
Date: Thu, 1 Oct 2009 12:27:34 -0600
Message-ID: <20091001182734.GI19540@obsidianresearch.com>
References: <839303D0FDC14F77AE516FDC9CF8B6A7@amr.corp.intel.com> <20091001155613.GN17846@me> <3F6F638B8D880340AB536D29CD4C1E1912C86E862B@orsmsx501.amr.corp.intel.com> <20091001162715.GC22310@obsidianresearch.com> <5700CAE1904A41378DAE71D5F81B9C55@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5700CAE1904A41378DAE71D5F81B9C55-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 01, 2009 at 10:10:13AM -0700, Sean Hefty wrote:
> >I've always felt the warning on implicit cast from larger to smaller
> >type to be somewhat useless - that is an unavoidable operation when
> >working with networking. Adding casts does nothing to actually improve
> >the code, and trying to change to smaller types results in worse code
> >gen and no improvement in function.
> 
> An explicit cast lets someone reading the code know that the
> original programmer was aware that data could be loss, or that data
> loss wouldn't occur because of the range of the data.  IMO, adding
> explicit casts to the code is better than having an equally number
> of implicit casts.

So for every cast your patches add you generate a rigorous proof that
the surrounding usage of those variables is correct and meets the
constraint? :)

All you really get is an annotation that there is a cast here. You
don't know what the type of operand is, you don't know if it is
an important cast, you don't know the type of the assignment
target. The explicit cast actually creats more questions, like, is
this truncating by design or because something got flubbed?

But the reader already knows that there is an implicit cast there -
this is C, all assignments can perform an implicit cast. A C
programmer must be aware of this and must know the types of all the
variables to correctly understand the code.

The biggest problem is that the cast is only correct if the types
never change. If someone changes the type then every instance of every
cast must be tracked down and fixed too. This is a huge maintenance
burden that implict casting avoids.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
