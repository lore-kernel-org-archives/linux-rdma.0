From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [ofa-general][PATCH 3/4] SRP fail-over faster
Date: Thu, 22 Oct 2009 20:34:09 -0400
Message-ID: <1256258049.1598.8.camel@lap75545.ornl.gov>
References: <4AD3B453.3030109@mellanox.com> <ada1vl5alqh.fsf@cisco.com>
 <4AD63681.6080901@mellanox.com> <adaljjd8zrj.fsf@cisco.com>
 <4AD63DB1.3060906@mellanox.com> <adahbu18uf5.fsf@cisco.com>
 <1255570760.13845.4.camel@obelisk.thedillows.org>
 <4AD74C88.8030604@mellanox.com> <1255634715.29829.9.camel@lap75545.ornl.gov>
 <20091015213512.GW5191@obsidianresearch.com> <4AE0E71E.20309@mellanox.com>
 <1256254394.1579.86.camel@lap75545.ornl.gov>
 <1256254459.1579.87.camel@lap75545.ornl.gov>
 <1256254692.1579.89.camel@lap75545.ornl.gov> <4AE0F309.5040201@mellanox.com>
 <1256256984.1579.105.camel@lap75545.ornl.gov> <4AE0F7DA.20100@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <4AE0F7DA.20100-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2009-10-22 at 20:24 -0400, Vu Pham wrote:
> David Dillow wrote:
> > On Thu, 2009-10-22 at 20:04 -0400, Vu Pham wrote:
> >> Yes and you can not disable intirely. I'm still looking at 
> >> benefits/advantages to disable it entirely
> >
> > To me, the advantage is I have a perfectly viable backup path to the
> > storage, and can immediately start issuing commands to it rather than
> > waiting for any timeout. On my systems, 1 second can be up to 1500 MB
> > transferred and a _huge_ number of compute cycles. And I expect those
> > numbers to grow.
> >
> You can still do so with these patches applied by using the right device 
> name (ie. /dev/sdXXX)

Not in a multipath situation configured for failover. I have to use the
multipath device, which will then use the appropriate path as
prioritized by ALUA.

> >> I use the user supplied setting for local async event on port error 
> >> where link is broken from host to switch
> >
> > Perhaps that part should be in the patch that adds that support, then?
> >   
> That's patch #4

Sure, and perhaps the part that massages the timeout should be in the
patch that introduces it and actually uses it, no?

> > This makes a certain amount of sense; I was confused by the two
> > unrelated changes in this patch. I'm still not all that happy about a
> > hard-coded 5 seconds, especially with no explanation about the magic
> > number.
> >   
> As I said above, it's not magic at all, it just that certain unknown 
> seconds already passed by, therefore, just pick X seconds to sleep on.

Sorry, this is a common idiom here -- a bare number in source code, with
no explanation as to where it came from or why it was picked, is often
called a "magic number."

I'm saying you should comment on it, either in the commit message or in
a comment in the code. Or better yet, give it a #define and a comment
above that definition that says why you picked it.

In other words, don't make someone who comes along after us have to
search for this mail thread to figure out that the 5 second sleep was
pulled out of thin air.

> >> To really sleep user supplied number of seconds, we need to register 
> >> trap to SM and receiving trap for a node leaving the fabric.
> >> It requires a lot of changes in srp_daemon (registering to trap, passing 
> >> event down to srp driver) and srp driver (handling this event)
> >>     
> >
> > Well, if this were done, then you wouldn't need to sleep at all would
> > you? Just wait for the trap telling you the target rejoined the fabric?
> > Perhaps you'd want a delay before tearing down the target connection,
> > but then that could be part of the user settings above?
> >
> > Not that I'm sure it is worth it, though.
> >   
> If it's done, you still need to sleep target->device_loss_timeout 
> (instead of some unknown seconds + 5) to tear down connection so that 
> dm-multipath can fail-over.

Or I can just start failing requests due to knowing they won't get to
the target so dm-multipath will use the backup path immediately. I can
sleep as long as I want before killing the connection, just in case it
comes back, but my commands will still be going to the other path.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
