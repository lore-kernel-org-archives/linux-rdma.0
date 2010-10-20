From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: ib mad definitions
Date: Tue, 19 Oct 2010 18:12:56 -0700
Message-ID: <20101019181256.d0a15afe.weiny2@llnl.gov>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB38D9@orsmsx501.amr.corp.intel.com>
	<AANLkTimc7sgmyTvW_dgXarUvGzHcN3sRJ6TJQGxU5p7G@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB3CDB@orsmsx501.amr.corp.intel.com>
	<AANLkTimbmQS0pcfF3CdSokPbAtbCZT7KFbWcSSNsYobk@mail.gmail.com>
	<20101019102244.21cd2b1e.weiny2@llnl.gov>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B7FB404C@orsmsx501.amr.corp.intel.com>
	<20101019212926.GH10362@obsidianresearch.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B801F393@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B801F393-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 19 Oct 2010 18:00:51 -0700
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > Can we at least agree on the usage of these structures first? Are the
> > constants going to be in host or network byte order?
> 
> I was simply suggesting to 'move' some of the existing structures and defines.
> 
> > Are you going to make something like the kernel where there is a
> > native structure and pack/unpack function set?
> 
> This would not be my preference.
> 
> > Something macro-based like foo = GET_MEMBER(*pr,preference)
> > 
> > Network byte order casting structures?
> > 
> > Host byte order casting structures? (my favorite)
> > 
> > bitfields?
> 
> again - not my preference
> 
> > Ira, I think the cleanest answer is that OSM keeps its type file, and
> > umad gets a new one that is cleaner, more capable and probably
> > incompatible. I'd hate to see us stick to the OSM scheme for umad just
> > for code compatability.
> 
> Whatever is done must fit within the windows development framework that we use.

I am all for "cleaner, more capable..." but why incompatible?  If we want to
start fresh and then convert OpenSM later, fine.  But _don't_ forget to go
back and convert OpenSM, because if you leave ib_types.h out there someone is
going to use it and we are back to where we started...  :-(  Same for ibmad,
when these definitions become available in umad, mad can be simplified.

What I would like right now is to get the definitions in 1 place!

Right now there are 3 headers I find path record in.

libibverbs: sa.h
libibmad: mad.h
opensm: ib_types.h


Node type is defined in:

libibverbs: verbs.h
opensm: ib_types.h
libibmad: mad.h

I could go on.

What Sean is offering to do is move ib_types to umad.  From there I can use
those definitions in mad (thus removing them from mad and consolidating at
least 2 of the 3 above).  Perhaps use them in ibverbs as well?  As a first
step I think we should take Sean up on his offer to start cleaning things up.
But we have to remove stuff as we go or we will just be defining yet another
place to look for these.  After this we can look at making things cleaner
(perhaps even combining mad and umad, and including some of the ideas you have
above).  As Sean said in another email, after this change; including
"ib_types.h" will be the same for anyone using it.  The exception is that we
have simplified the code.  I think this is a win-win with minimal work.

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
