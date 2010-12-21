From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH V3 5/6] RDMA CM: Save Owning PID
Date: Tue, 21 Dec 2010 21:43:01 +0200
Message-ID: <7E95F01E94AB484F83061FCFA35B39F8794E3F@exil.voltaire.com>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com><1292257370-24391-6-git-send-email-nirm@voltaire.com><20101214183458.GD2506@obsidianresearch.com><1292769382.2369.2145.camel@nirm-desktop><20101220215433.GB12090@obsidianresearch.com><1292943950.2369.3198.camel@nirm-desktop> <20101221181043.GD12090@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Class: urn:content-classes:message
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:

> > But an RDMA CM ID is not a FD based resource. An event channel is, but I
> > want to export ID stats and not event channel stats.
> > Are you saying that there's a scenario in which an RDMA CM ID is shared
> > between multiple processes?
> 
> It *is* a FD based resource. Nearly everything in Linux is.

Yes, nearly everything which is exported by Linux. but an RDMA CM ID
is not a resource that has to be exported to the userspace.
it's not FD based on its own.

> 
> It is tied to the ucma_fops FD (ie /dev/rdma_cm, aka the event
> channel), which when closed calls ucma_free_ctx which calls
> rdma_destroy_id. Processes that can access that FD can control the
> RDMA CM IDs associated with it.
> 

Right. Like I already mentioned, an event channel is indeed FD based.
However, an event channel doesn't (necessarily) have a one to one 
relation with IDs. This is also reflected in the need to create/destroy 
IDs separately from event channels, and also in the fact that you can
have many IDs for one event channel. These are some of the differences
from the socket interface, which immediately creates a kernel resource
for each FD that is opened.

> The only case where this is not true is in the kernel, and in that
> instance the PID is meaningless - you'd be much better off exporting
> the name of the module that allocated the RDMA CM ID.
> 

But the PID is not meaningless in this case.
More often then not, the owner will be a kernel thread and will have a
PID.

> > Even if there is such a scenario, I think that by taking the PID of the
> > one that calls rdma_accept, the idea of an owner stays consistent. 
> > I don't mind the name btw, just tying it to something else, which isn't
> > necessarily related.
> 
> The proper thing for userspace is to tie it back to the FD that owns
> the resource - which is the FD that destroys the resource when it is
> closed.
> 
> Jason

What destroys an ID is rdma_destroy_id.
When calling rdma_destroy_event_channel the ID might be destroyed as 
a side effect (Although according to the documentation you have to 
have all of your IDs destroyed prior to calling destroy_event_channel),
but why should we rely on something that might control the ID when we 
can rely on the ID itself? After all, this is the object we're really
interested in.

Nir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
