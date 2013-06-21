From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V2] libibverbs: Allow arbitrary int values for MTU.
Date: Fri, 21 Jun 2013 21:56:58 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD35EE5@ORSMSX109.amr.corp.intel.com>
References: <1371738080-18537-1-git-send-email-jsquyres@cisco.com>
 <51C32EFC.8060202@redhat.com> <20130620165305.GA19800@obsidianresearch.com>
 <51C36692.7000507@redhat.com> <20130620211454.GA2434@obsidianresearch.com>
 <51C39ECB.3040006@redhat.com> <20130621063648.GA27963@obsidianresearch.com>
 <51C48F01.5030103@redhat.com> <20130621182617.GA17700@obsidianresearch.com>
 <51C4BE25.9000501@redhat.com> <20130621212016.GA10637@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130621212016.GA10637-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > <raises hand>  I'm ready for a new project.  I already had one in mind,
> > but it required some changes to libibverbs that are pretty deep changes.
> >  Instead of doing that deep work in libibverbs, I can start here and
> > move on to my next project when this is up and running.
> 
> That would be amazing, I will try to help you as best my limited time
> permits.

I've given this some thought recently as well.  The concepts that I envision would be fairly significant relative to the current API, but build off the libibverbs framework and encapsulate all of the kernel ABI as well.  The obvious goal is to avoid introducing any performance impact.  Working down to something concrete would definitely take some time.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
