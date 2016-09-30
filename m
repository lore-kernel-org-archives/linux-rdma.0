From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: EACCES errors using preload libs
Date: Fri, 30 Sep 2016 13:27:36 -0500
Message-ID: <09ef01d21b48$51bb9990$f532ccb0$@opengridcomputing.com>
References: <09db01d21b42$17aad9b0$47008d10$@opengridcomputing.com> <20160930175036.GA1867@obsidianresearch.com> <09e701d21b46$487f2b00$d97d8100$@opengridcomputing.com> <20160930181705.GB1867@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160930181705.GB1867-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> On Fri, Sep 30, 2016 at 01:13:02PM -0500, Steve Wise wrote:
> > > Hum, so I expect the patch to break things. Specifically if you change
> > > the process credentials after opening verbs. However just forking()
> > > shouldn't cause a problem. Can you confirm there is nothing that
> > > changes uid,gid, etc during the fork?
> >
> > I'll debug this further, but this is running as root, so that sort of
stuff
> > shouldn't be changing.
> 
> Based on some emails I've got I think there is a 'thing' with
> credentials in Linux where something copies the creds struct but
> (perhaps?) does not change it.
> 
> Linus designed the test to be a pointer compare, so if anything does a
> copy-but-no-modify then it will break the test unnecessarily. If I
> understand everything properly :|
> 
> If you can add any more information I'm sure people will appreciate
> it.
> 
> > Fork() is actually not supported by this preload library, but we were
> > getting by, I guess, with netserver because it fork()s before it
allocates
> > the UDP socket that then gets accelerated by the preload lib.  However,
I'm
> > thinking that librdacm is getting invoked and is opening contexts to all
the
> > verbs devices before the fork() and thus after it, this new "safe" check
it
> > biting me.
> 
> Hmm, sounds plausible. Same deal with rdmacm, it has to close/open the
> verbs device. Defering doing anything until first needed would also be
> a reasonable strategy.

I think it does.  But perhaps my offload lib is actually the culprit.  It
goes and walks all the interfaces and builds a database of available devices
that can support this user mode UDP stack.  

I'll post more as I identify the root cause.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
