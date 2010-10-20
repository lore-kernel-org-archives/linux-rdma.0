From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: ib mad definitions
Date: Tue, 19 Oct 2010 18:32:57 -0700
Message-ID: <20101019183257.3f609c45.weiny2@llnl.gov>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB38D9@orsmsx501.amr.corp.intel.com>
	<AANLkTimc7sgmyTvW_dgXarUvGzHcN3sRJ6TJQGxU5p7G@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB3CDB@orsmsx501.amr.corp.intel.com>
	<AANLkTimbmQS0pcfF3CdSokPbAtbCZT7KFbWcSSNsYobk@mail.gmail.com>
	<20101019102244.21cd2b1e.weiny2@llnl.gov>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB404C@orsmsx501.amr.corp.intel.com>
	<20101019212926.GH10362@obsidianresearch.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B801F393@orsmsx501.amr.corp.intel.com>
	<20101020010958.GA413@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101020010958.GA413-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 19 Oct 2010 18:09:58 -0700
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Tue, Oct 19, 2010 at 06:00:51PM -0700, Hefty, Sean wrote:
> > > Can we at least agree on the usage of these structures first? Are the
> > > constants going to be in host or network byte order?
> > 
> > I was simply suggesting to 'move' some of the existing structures and defines.
> 
> But they are horrible and little used outside opensm right now, you
> really want to commit to that forever?

Not everything is horrible.  And if it is we can fix it.  But I think
defining "yet another" header with the same functionality is worse.  Like it or
not ib_types is there.  If you don't remove/fix it, someone will find it and use
it.  How does that make things cleaner just because there is something "clean"
somewhere else?  Someone will find ib_types use it.  I still feel this is the
best first step at getting rid of ib_types.h (at least as it currently stands).

Ira

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
