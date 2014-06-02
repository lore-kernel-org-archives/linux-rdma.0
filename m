From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V3] svcrdma: refactor marshalling logic
Date: Mon, 2 Jun 2014 12:06:39 -0500
Message-ID: <004b01cf7e85$04c6c7c0$0e545740$@opengridcomputing.com>
References: <20140529165532.16349.95248.stgit@build.ogc.int> <EE7902D3F51F404C82415C4803930ACD3FE01265@CMEXMB1.ad.emulex.com> <000001cf7c07$72e613d0$58b23b70$@opengridcomputing.com> <EE7902D3F51F404C82415C4803930ACD3FE01355@CMEXMB1.ad.emulex.com> <004101cf7e82$68b58ad0$3a20a070$@opengridcomputing.com> <20140602165151.GA20031@fieldses.org> <004901cf7e83$15107790$3f3166b0$@opengridcomputing.com> <20140602165716.GB20031@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140602165716.GB20031-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Content-Language: en-us
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'J. Bruce Fields'" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: 'Devesh Sharma' <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> On Mon, Jun 02, 2014 at 11:52:47AM -0500, Steve Wise wrote:
> > > > You're correct.  And this bug appears to be in the current upstream code as well.
If
> > an
> > > > IB_WR_LOCAL_INV wr is used, it must include IB_SEND_FENCE to fence it until the
prior
> > > read
> > > > completes.
> > > >
> > > > Good catch!  I'll post V4 soon.
> > >
> > > Any chance that can be handled as a separate patch rather than folded
> > > in?
> > >
> > > (Disclaimer: I've been following the discussion only very
> > > superficially.)
> > >
> >
> > Sure.  I'll post the patch soon.
> 
> Thanks, and, again, I'm not terribly happy about the monster
> patch--anything you can split off it is great, even if that thing's
> small.  As long as all the intermediate stages still build and run.
> 

I don't see any way to do this for this particular patch.  It rewrites the entire rdma
read logic.  

> (And any bugs you've identified in upstream code are good candidates for
> separate patches, hopefully preceding the rewrite.  That also allows us
> to apply those fixes to stable kernels if appropriate.)
> 

If I do this, then I'd have to respin the refactor patch.  I really would like to get this
merged as-is (with the one change I'm sending soon), and move on.  I definitely will try
and keep the patches smaller and more discrete going forward.  

Will that work?


Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
