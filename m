From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Mon, 05 Jun 2017 11:08:16 -0400
Message-ID: <1496675296.7171.179.camel@redhat.com>
References: <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com>
         <20170531040437.GE5406@mtr-leonro.local>
         <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com>
         <1496261429.2608.15.camel@sandisk.com>
         <20170602162849.GA28660@ssaleem-MOBL4.amr.corp.intel.com>
         <20170604053635.GD6868@mtr-leonro.local>
         <20170605022313.GB18172@ctung-MOBL3.amr.corp.intel.com>
         <20170605040030.GG6868@mtr-leonro.local>
         <20170605042007.GA19068@ctung-MOBL3.amr.corp.intel.com>
         <20170605045043.GA17148@ctung-MOBL3.amr.corp.intel.com>
         <20170605060318.GH6868@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170605060318.GH6868-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Ismail, Mustafa" <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-06-05 at 09:03 +0300, Leon Romanovsky wrote:
> On Sun, Jun 04, 2017 at 11:50:43PM -0500, Chien Tin Tung wrote:
> > 
> > You jump around in this thread so much it is hard for a sane person
> > to follow
> > so I will attempt to summarize what has taken place.
> > 
> > You try to revert a patch that fixed a real problem in portmapper,
> > claiming:
> > 
> > 1) Code in question impacts the whole RDMA subsystem.
> > 	which is false by my multiple replies on this.

I haven't seen this as false.  Right now the rdma subsystem's netlink
usage is pretty small.  In the future it will be much larger.  Changing
the default semantics of a newly opened RDMA netlink socket does in
fact impact all of the RDMA subsystem's current and future netlink
sockets.  So, it *does* impact the whole RDMA subsystem, at least as
far as their netlink sockets are concerned.

> > 2) There is a deadlock.
> > 	Which is false.  I'm still asking for proof.

I'm not sure of the deadlock, but as I already pointed out, your fix is
not a guaranteed fix.  It never was.  It just moved the goal post of
how hard you would have to push the subsystem before it would fail.

> > 3) you want netlink receive to be non-blocking and asynchronous
> > 	what does that have to do with the non-existing deadlock?

Nothing, it's a separate point and need not be tied to a deadlock.  It
stands on its own merits.

> > 	Asnwer is you can't when there isn't one.
> > 	If you want it, create a patch for it instead of creating a
> > 	regression with a lazy revert.

If the original patch broke our semantics so that we have created an
ambiguous API for netlink sockets in general, which I will investigate,
then this patch is buggy, whether it fixed a problem for you or not,
and will have to be reverted eventually.  We can coordinate with doing
the revert after you've fixed iw_portmapper, but an ambiguous API will
not be allowed to remain.  See my other emails in this thread.

> > I will continue this discussion if you answer directly to any of
> > those
> > points.  If you choose to dance around the subject and claim
> > falsehood, you
> > will only damage your own creditibility on the list.  I hope you
> > take that
> > to heart.

Leon is not a native english speaker, as I assume you aren't.  I would
suggest that it might be more about failure to understand each other
and failure to get at the root of the issue than anything that would
legitimately do damage to anyone's credibility.  You might wish to calm
down and read my posts in this thread.  I hope I was able to clarify
things a bit.

> OK, I got your point. It is worthless discussion.
> 
> FYI, ibnl_unicast holds global lock for whole NETLINK_RDMA
> static void ibnl_rcv(struct sk_buff *skb)
> {
>         mutex_lock(&ibnl_mutex);
>         ibnl_rcv_reply_skb(skb);
>         netlink_rcv_skb(skb, &ibnl_rcv_msg);
>         mutex_unlock(&ibnl_mutex);
> }
> 
> I'll wait for a maintainer's decision on the proposed patch.

I should be able to finish my investigation by tomorrow (I have two
appointments today that will make this a short day for me,
unfortunately :-/).

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
