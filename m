From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 5/6] RDMA CM: Save Owning PID
Date: Tue, 21 Dec 2010 13:36:27 -0700
Message-ID: <20101221203627.GE12090@obsidianresearch.com>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
 <1292257370-24391-6-git-send-email-nirm@voltaire.com>
 <20101214183458.GD2506@obsidianresearch.com>
 <1292769382.2369.2145.camel@nirm-desktop>
 <20101220215433.GB12090@obsidianresearch.com>
 <1292943950.2369.3198.camel@nirm-desktop>
 <20101221181043.GD12090@obsidianresearch.com>
 <7E95F01E94AB484F83061FCFA35B39F8794E3F@exil.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7E95F01E94AB484F83061FCFA35B39F8794E3F-QfUkFaTmzUSUvQqKE/ONIwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 21, 2010 at 09:43:01PM +0200, Nir Muchtar wrote:
> Jason Gunthorpe wrote:
> 
> > > But an RDMA CM ID is not a FD based resource. An event channel is, but I
> > > want to export ID stats and not event channel stats.
> > > Are you saying that there's a scenario in which an RDMA CM ID is shared
> > > between multiple processes?
> > 
> > It *is* a FD based resource. Nearly everything in Linux is.
> 
> Yes, nearly everything which is exported by Linux. but an RDMA CM ID
> is not a resource that has to be exported to the userspace.
> it's not FD based on its own.

But we are talking about a PID which primarily a userspace identifier.

> > It is tied to the ucma_fops FD (ie /dev/rdma_cm, aka the event
> > channel), which when closed calls ucma_free_ctx which calls
> > rdma_destroy_id. Processes that can access that FD can control the
> > RDMA CM IDs associated with it.

> Right. Like I already mentioned, an event channel is indeed FD based.
> However, an event channel doesn't (necessarily) have a one to one 
> relation with IDs.

So? Each RDMA CM ID is owned by userspace returns a reference to the
FD that owns it, and there can be many CM ID's referencing one FD.

> > The only case where this is not true is in the kernel, and in that
> > instance the PID is meaningless - you'd be much better off exporting
> > the name of the module that allocated the RDMA CM ID.

> But the PID is not meaningless in this case.  More often then not,
> the owner will be a kernel thread and will have a PID.

Well, there will always be a PID, it just might not be at all
informative (ie it could be kthreadd, ksoftirqd or something).  My
understanding was that actual named kernel threads are not really
preferred anymore, work queues/thread pool/etc are looking more
popular.. (eg http://lwn.net/Articles/347822/)

So I don't see the special case that kernel consumers don't have an
event channel FD as relevant. If you really care about this returning
the name of the module that created the ID is much more useful.

> but why should we rely on something that might control the ID when we 
> can rely on the ID itself? After all, this is the object we're really
> interested in.

The question is how do your correlate the kernel ID with the userspace
process(es) that have ownership of it. The only way to do that is to
associate the ID with the event channel FD with the process(es) that
have access to it.

Unfortunately there is no other way to correlate the in-kernel ID with
the process(es) that control it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
