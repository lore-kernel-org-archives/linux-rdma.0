From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: EACCES errors using preload libs
Date: Fri, 30 Sep 2016 13:13:02 -0500
Message-ID: <09e701d21b46$487f2b00$d97d8100$@opengridcomputing.com>
References: <09db01d21b42$17aad9b0$47008d10$@opengridcomputing.com> <20160930175036.GA1867@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160930175036.GA1867-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> On Fri, Sep 30, 2016 at 12:43:02PM -0500, Steve Wise wrote:
> 
> > The single case I see failing so far is trying to preload my library
with
> > netserver.  If I run netserver with '-D -f' which avoids fork() calls,
it
> > works fine.  If I omit the -f, then the forked process gets an EACCES
error
> > trying to do ibv_query_device().  Thoughts?
> 
> Hum, so I expect the patch to break things. Specifically if you change
> the process credentials after opening verbs. However just forking()
> shouldn't cause a problem. Can you confirm there is nothing that
> changes uid,gid, etc during the fork?
> 

I'll debug this further, but this is running as root, so that sort of stuff
shouldn't be changing.

> Unfortunately it was designed by Linus and Andy to work this way, so
> we cannot weaken the check.
>

Sure.
 
> I don't know how your preload library works, but after fork basically
> everything related to verbs is garbage - so it should be safe to
> close/reopen then uverbs fd which will avoid the problem. It is only
> because the FD was passed across a credential change that you got
> EACCESS.
>

Fork() is actually not supported by this preload library, but we were
getting by, I guess, with netserver because it fork()s before it allocates
the UDP socket that then gets accelerated by the preload lib.  However, I'm
thinking that librdacm is getting invoked and is opening contexts to all the
verbs devices before the fork() and thus after it, this new "safe" check it
biting me.   

> The way forward to restore the lost functionality is to rework the
> entire uAPI to use ioctl, which is what Matan/Sean/etc have been
> doing. 

Right, I'm ok with waiting for this (and helping as I can, but I've been
very quiet to date :) ).

Thanks Jason, 

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
