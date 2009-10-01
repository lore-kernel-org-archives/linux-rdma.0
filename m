From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: ib_types.h moving [was: Re: [ofa-general] [RFC] 3/5: IB ACM:
 libibacm]
Date: Thu, 1 Oct 2009 15:50:07 -0700
Message-ID: <20091001155007.5bdf73f1.weiny2@llnl.gov>
References: <EED935897ACB4DC784DFAB4184A5DC6F@amr.corp.intel.com>
	<FCF6CB1AB515463BAB014EB7BB084FDA@amr.corp.intel.com>
	<20090917101804.12e9e5ce.weiny2@llnl.gov>
	<FD141AAD0F10420B9D0478DB68C9DEDA@amr.corp.intel.com>
	<20090917132050.041b077d.weiny2@llnl.gov>
	<20090925130908.GD26931@me>
	<20090930183126.0011af7c.weiny2@llnl.gov>
	<20091001025752.GA22310@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091001025752.GA22310-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 30 Sep 2009 20:57:52 -0600
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Wed, Sep 30, 2009 at 06:31:26PM -0700, Ira Weiny wrote:
> 
> > > Now I likely would agree with Ira that moving ib_types.h to libibumad
> > > is a least painful option. Do we have a better ideas?
> > 
> > So far I can only think of 2 "correct" options.
> > 
> >    1) Make ib_types.h into a new library and have libibverbs, libibmad,
> >       opensm, and MPI's use the constants and helper functions there.  This of
> >       course would force some dependencies.
> 
> You are going the wrong way.. libibverbs is the 'fundamental' lowest
> level library. Everything should build on it, not re-invent its stuff.

I agree, however, I think others do not.  In particular is Roland ready to
accept a significant portion of ib_types.h?  I don't have any problem
requiring libibverbs for anything IB related.  OTOH, I am not so against
having many libraries as long as they are well defined and well known.

If the only solution is to have one massive libib library, so be it!  I don't
have a problem with that.  But I think the maintainer of this lib is going to
have a hard job.  And perhaps some (switch vendors?) might want at least a
little more break down of functionality to pick and choose what is required?

> 
> libibumad should not have device discovery and handling functions!
> It should use ibv_device and ibv_context identifiers from libibverbs.

I also agree, however, ib_types does not have any device discover functions.
I was only speaking of where to put the ib_types functionality.  Not about
other problems which may exist.  ;-)

> 
> It should not duplicate constants and functions from libibverbs.

Absolutely!  Sasha are you ready to make OpenSM depend on libibverbs?

> 
> >    2) split up and spread ib_types.h around to appropriate places.  This will
> >       likely include libibmad and libibverbs (others?) I don't think libibumad
> >       is appropriate really.  At first, I suggested this mainly out of
> >       convenience because WinOF uses it.  However, I don't think it is
> >       architecturally correct.  libibumad looks to have a sound interface and
> >       should not be messed with.
> 
> It has a horrid interface, it should be destoyed :P
> 
> It needs exactly 4 functions:
> 1) open QP0/QP1 special FD based on ibv_device/ibv_context
> 2) read/write MADs from the special FD into user buffers. Maybe some
>    higher level helper functions (ie send/recv with retry, timeout, etc)
> 3) Do some basic parsing and whatever of the user buffers (if
>    necessary, probably not anymore)
> 4) Do any special control functions on the QP0/QP1/port
>    (ie set control bits, etc, etc)

Ok, ok.  Once again I was only speaking of where to put the ib_types stuff.  I
think you would agree that adding ib_types stuff to libibumad is the wrong
direction, right?

>
> 
> libibmad should do all the hard core mad processing, structure
> definitions, parsing helpers, redirection and other special function
> logic, etc. It should be able to ride either on the QP0/QP1 special FD
> or directly on a UD QP from libibverbs.

Yes, yes, and yes!

> 
> Two libraries are probably not needed, one library containing both
> layers (with architectural purity), or putting the umad access layer
> in libibverbs would be best. We have too many libraries.

Ok, as I said one massive libib library is fine with me.  Are Roland and Sasha
ready to accept this?

One final thought.  Does WinOF use libibverbs as well?  Would moving ib_types
functionality in to libibverbs be a problem for them?

Ira


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
