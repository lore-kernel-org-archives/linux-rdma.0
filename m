From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: ib mad definitions
Date: Wed, 20 Oct 2010 10:10:10 -0700
Message-ID: <20101020101010.329ff377.weiny2@llnl.gov>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB38D9@orsmsx501.amr.corp.intel.com>
	<AANLkTimc7sgmyTvW_dgXarUvGzHcN3sRJ6TJQGxU5p7G@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB3CDB@orsmsx501.amr.corp.intel.com>
	<AANLkTimbmQS0pcfF3CdSokPbAtbCZT7KFbWcSSNsYobk@mail.gmail.com>
	<20101019102244.21cd2b1e.weiny2@llnl.gov>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB404C@orsmsx501.amr.corp.intel.com>
	<20101019212926.GH10362@obsidianresearch.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B801F393@orsmsx501.amr.corp.intel.com>
	<20101019181256.d0a15afe.weiny2@llnl.gov>
	<20101020032818.GC413@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101020032818.GC413-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 19 Oct 2010 20:28:18 -0700
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Tue, Oct 19, 2010 at 06:12:56PM -0700, Ira Weiny wrote:
> 
> > I am all for "cleaner, more capable..." but why incompatible?  If we want to
> > start fresh and then convert OpenSM later, fine.  But _don't_ forget to go
> > back and convert OpenSM, because if you leave ib_types.h out there someone is
> > going to use it and we are back to where we started...  :-(  Same for ibmad,
> > when these definitions become available in umad, mad can be simplified.
> 
> ib_types.h should not be installed in /usr/include, stop doing that
> and that risk goes away.

That is one way to solve it, but only after those definitions (or equivalent) are available in /usr/include.

> 
> ibmad can't really be changed, it is system library with a defined
> API. Maybe ibmad.2 or something, I don't know. I tried to use some of
> the PR APIs in it, and I've found them not useful :(

ibmad.2 is the way to go.  I have expressed my distaste for ibmad in the past and I agree, it is too established to be changed.  But I have not had the time.  Mainly I am trying to support Sean who has the time.

Ira

> 
> For instance we can't just abandon the mad_get_fields approach because
> we have real, usuable field access in umad, it has to stay.
> 
> > Right now there are 3 headers I find path record in.
> 
> > libibverbs: sa.h
> 
> This isn't a MAD path record, this is the kernel version, which is
> unpacked. What we really needs is MAD 2 kernel and vice versa
> conversion in a library. I already have code that does this in
> several places :(
> 
> > libibmad: mad.h
> 
> You mean mad_get_fields IB_SA_PR_DGID_F, etc? It doesn't even have all
> the fields :(
> 
> > opensm: ib_types.h
> 
> Yep.
>  
> > Node type is defined in:
> > 
> > libibverbs: verbs.h
> > opensm: ib_types.h
> > libibmad: mad.h
> > 
> > I could go on.
> 
> Keep in mind that for the most part libibmad is someones attempt to
> make a set of accessors and structures for mads. It is incomplete. It
> is largely unusable. I certainly haven't been able to use its PR
> structure parsing functions for any real app. Was it just pulled out
> of opensm? I don't know, I'd just as soon see that part of it be
> discarded, and a complete set of structures added to umad.
> 
> opensm has unique problems because they want to remain independent of the
> OFA stack, I don't think they have a choice but to duplicate.
> 
> Jason


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
