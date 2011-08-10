From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [Patch infiniband-diags:perfquery] Loop through all local
 HCAs/ports
Date: Tue, 9 Aug 2011 17:56:15 -0700
Message-ID: <20110809175615.a399a171.weiny2@llnl.gov>
References: <4E332CE5.3010706@redhat.com>
	<20110729220912.GL18090@obsidianresearch.com>
	<4E3330AF.9050208@redhat.com>
	<20110729222612.GM18090@obsidianresearch.com>
	<4E341104.90105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E341104.90105-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 30 Jul 2011 07:11:16 -0700
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On 7/29/2011 6:26 PM, Jason Gunthorpe wrote:
> >>> Not sure what I think of this, is dumping counters on all local HCA
> >>> ports really that interesting? Would this be better done by doing
> >>> something fancy with nodeGUID so at least all ports on remote HCAs can
> >>> be dumped too?
> >>
> >> The request came in from one of our partners who wanted it for
> >> tracking performance stats specifically on the local machine.
> > 
> > Well, I think it would be best to make this work generally which is
> > fairly hard, unfortunately.
> >  - If the destination is the local HCA then you have to iterate over
> >    all local ports with matching node GUIDs by opening devices
> >  - If the destination is a remote HCA then you have to query the SA
> >    for all nodes with a matching GUID and iterate over them. Ira has
> >    been working on some common code for this..
> >  - Maybe you want to cross product and try to query the SA attached to
> >    all local end ports to try and find all ports. That would actually be
> >    very useful for many situations I know of...
> > 
> > Could you make your patch just do #1 and continue to misbehave for
> > the other cases?
> 
> Well, it sort of already does.  The patch looks bigger than it is
> because I had to re-indent in order to put the main functional code
> inside of a loop.  For the most part, the loop is unchanged.  Just apply
> the patch then look at what we do when all_hcas is non-0 right before
> the do { and right before the } while (ibd_ca);  It iterates over all
> the hca names that libibumad gives us, and then loops over all the ports
> as returned by libibumad's umad_get_ca().

Sorry I am just getting around to this.  I think option 1 is probably a good use case as a start.

However, the bulk of the patch does not apply to the current master due to the addition of several options.

Could you rebase against the current master and resend?

Thanks,
Ira

> 
> 
> -- 
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: CFBFF194
> 	      http://people.redhat.com/dledford
> 
> Infiniband specific RPMs available at
> 	      http://people.redhat.com/dledford/Infiniband
> 


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
