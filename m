From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: ib_types.h moving
Date: Thu, 1 Oct 2009 17:38:41 -0700
Message-ID: <20091001173841.9ef6bca2.weiny2@llnl.gov>
References: <EED935897ACB4DC784DFAB4184A5DC6F@amr.corp.intel.com>
	<FCF6CB1AB515463BAB014EB7BB084FDA@amr.corp.intel.com>
	<20090917101804.12e9e5ce.weiny2@llnl.gov>
	<FD141AAD0F10420B9D0478DB68C9DEDA@amr.corp.intel.com>
	<20090917132050.041b077d.weiny2@llnl.gov>
	<20090925130908.GD26931@me>
	<20090930183126.0011af7c.weiny2@llnl.gov>
	<376DB0F1C4874D9388729D1367F54C23@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <376DB0F1C4874D9388729D1367F54C23-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 1 Oct 2009 14:47:33 -0700
"Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> >So far I can only think of 2 "correct" options.
> >
> >   1) Make ib_types.h into a new library and have libibverbs, libibmad,
> >      opensm, and MPI's use the constants and helper functions there.  This of
> >      course would force some dependencies.
> >
> >   2) split up and spread ib_types.h around to appropriate places.  This will
> >      likely include libibmad and libibverbs (others?) I don't think libibumad
> >      is appropriate really.  At first, I suggested this mainly out of
> >      convenience because WinOF uses it.  However, I don't think it is
> >      architecturally correct.  libibumad looks to have a sound interface and
> >      should not be messed with.
> 
> The only issue that was pointed out was that the IB ACM duplicated some network
> structure definitions (the SA MAD format, McMemberRecord, PathRecord).  It seems
> perfectly natural to me to have the library that allows you to send and receive
> MADs to provide these definitions, especially considering how fundamental these
> specific attributes are to using IB.  Even though umad_send and umad_recv are
> both defined to take a void * input buffer, they expect a specific format to
> that buffer.

Combine libibmad into libibumad?  Or just the core structure definitions?  I
will admit that accepting void * seems wrong when you know it is
supposed to be a mad packet.  In fact both umad_send and umad_recv imediately
cast the void * to struct ib_user_mad *!  Why not specify that in the
parameter type?

> 
> libibverbs defines host structure definitions for McMemberRecord and PathRecord,
> but doesn't use them.  This allows the rdma_cm and ib_cm to remain independent,
> but use the same definition.

:-(  I missed those.  Is there a reason they must remain independent?  (I
assume you mean independent of the mad libs?)

> 
> IB ACM is coded to libibumad directly, mainly because I didn't see any benefit
> to coding to a higher level MAD interface that was more complex to use.  Trying
> to keep the defines in a higher level library, which is what we have now, either
> results in duplicating them or forcing a dependency where there wouldn't be any.

I understand the desire to avoid using libibmad.  Perhaps you are correct that
there are some things which are "core" MAD functionality, structure
definitions for example, which should be at a lower level.  However, I think
it is still appropriate to put some things from ib_types into libibverbs and
to expect people to use those definitions when required.

> 
> And to be clear, I'm only referring to definitions in ib_types.h (and some in
> mad.h), and not any actual functionality.
> 

<sigh> yes this discussion has digressed.  But I don't think we should dive
into breaking up (or moving) ib_types just to move things around.  I think
Sasha is right we need to have a plan for where things _should_ end up.  As I
look for homes for all the items of ib_types I find that it is not just one
place.  :-/

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
