From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [Patch infiniband-diags:perfquery] Loop through all local
 HCAs/ports
Date: Fri, 29 Jul 2011 16:26:12 -0600
Message-ID: <20110729222612.GM18090@obsidianresearch.com>
References: <4E332CE5.3010706@redhat.com>
 <20110729220912.GL18090@obsidianresearch.com>
 <4E3330AF.9050208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4E3330AF.9050208-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 29, 2011 at 06:14:07PM -0400, Doug Ledford wrote:
> On 07/29/2011 06:09 PM, Jason Gunthorpe wrote:
> >On Fri, Jul 29, 2011 at 05:57:57PM -0400, Doug Ledford wrote:
> >>The -a mode of perfquery is intended to loop through all ports on a
> >>single HCA and provide aggregated output across all ports.
> >>
> >>The -l mode is intended to loop through all ports of a single HCA
> >>and output non-aggregated data.
> >
> >Actually, none of these modes are intended to support HCA scenarios,
> >they are all only for switches.
> 
> Well, they attempt to work on local HCAs if you don't specify a
> switch lid to query.  So, intended or not, they are already being
> attempted to be used in this fashion out in the field.

It is just a bug perfquery tries at all, eg the ibtool version prints
"Can't fetch all ports on a CA." when asked to do that rather than
show a cryptic error.

> >Not sure what I think of this, is dumping counters on all local HCA
> >ports really that interesting? Would this be better done by doing
> >something fancy with nodeGUID so at least all ports on remote HCAs can
> >be dumped too?
> 
> The request came in from one of our partners who wanted it for
> tracking performance stats specifically on the local machine.

Well, I think it would be best to make this work generally which is
fairly hard, unfortunately.
 - If the destination is the local HCA then you have to iterate over
   all local ports with matching node GUIDs by opening devices
 - If the destination is a remote HCA then you have to query the SA
   for all nodes with a matching GUID and iterate over them. Ira has
   been working on some common code for this..
 - Maybe you want to cross product and try to query the SA attached to
   all local end ports to try and find all ports. That would actually be
   very useful for many situations I know of...

Could you make your patch just do #1 and continue to misbehave for
the other cases?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
