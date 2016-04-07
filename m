From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH 0/4] IB/srpt and the percpu_ida conversion
Date: Thu, 07 Apr 2016 16:24:24 -0700
Message-ID: <1460071464.18732.57.camel@haakon3.risingtidesystems.com>
References: <57055BC6.7070402@sandisk.com>
	 <1460068181.18732.23.camel@haakon3.risingtidesystems.com>
	 <20160407230110.GA9842@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160407230110.GA9842-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2016-04-08 at 01:01 +0200, Christoph Hellwig wrote:
> On Thu, Apr 07, 2016 at 03:29:41PM -0700, Nicholas A. Bellinger wrote:
> > I asked to not revert the percpu_ida conversion and again you simply
> > ignored subsystem maintainer feedback, and included a different
> > percpu_ida conversion without using alloc_session callback that still
> > does pre-allocation of buffers before session login even completes.
> 
> He doesn't revert it after the patch series, but reverts it first
> to then do it properly.  If you don't like that it's fine to ask
> Bart to resend with a different patch ordering, but it would be really
> helpful to do it politely.

I've already taken the time to send out a patch to address the
regression for v4.6-rc.

If there is a problem with that patch he should comment with the
specifics of the issue he found, and not revert for v4.6 and do his own
thing for v4.7.

> 
> > The whole point of the alloc_session callback is so that extra
> > pre-allocation doesn't happen until after se_node_acl lookup has
> > finished, and is what ib_srpt needs to be using given SRP's completely
> > existent spec level security model.
> 
> Your original patch didn't use the alloc_session callback either,
> so I don't really see the fuzz here.  I don't see how it makes things
> clearer, but if you ask politely, and provide a detailed and valid
> explanation I'm pretty sure Bart will adopt the series to your taste.
> 
> > 
> > In any event, I'm fixing the regression ahead of the next v4.6-rc PULL
> > in:
> > 
> > http://www.spinics.net/lists/target-devel/msg12535.html
> > 
> > Any issues you find with this patch should be sent out as an incremental
> > patch, and not rolling your own concoction.
> 
> That patch doesn't work.  While it's great to have a maintainer that
> sets overall architectural direction it also really helps to work nicely
> with contributors that have detailed experience with the transport (or in
> this case even wrote the original driver).
> 

Yep, will address for -v2 after verifying with IB ports.

> I think a lot of these disagreements could be sorted out much better if
> you work with Bart at a technical level rather than having a personal
> vandetta.

It's nice that Bart has decided to wake up after 5 years of inactivity
while I've been maintaining ib_srpt during that time.

I'll let the failed attempt at high-jacking the upstream target drivers
be water under the bridge, but if he continues to ignore feedback and
constantly mix-up unrelated issues at every opportunity like with the
TMR stuff, plus ib_srpt patches never make it on target-devel, don't
expect me to be in a particularly friendly mood.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
