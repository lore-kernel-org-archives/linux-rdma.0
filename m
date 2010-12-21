From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V3 5/6] RDMA CM: Save Owning PID
Date: Tue, 21 Dec 2010 17:05:50 +0200
Message-ID: <1292943950.2369.3198.camel@nirm-desktop>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
	 <1292257370-24391-6-git-send-email-nirm@voltaire.com>
	 <20101214183458.GD2506@obsidianresearch.com>
	 <1292769382.2369.2145.camel@nirm-desktop>
	 <20101220215433.GB12090@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101220215433.GB12090-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-12-20 at 14:54 -0700, Jason Gunthorpe wrote:
> On Sun, Dec 19, 2010 at 04:36:22PM +0200, Nir Muchtar wrote:
> > On Tue, 2010-12-14 at 11:34 -0700, Jason Gunthorpe wrote:
> > > On Mon, Dec 13, 2010 at 06:22:49PM +0200, Nir Muchtar wrote:
> > > > Save owning PID to id-priv when creating id's/accepting connections.
> > > 
> > > This should be called creator_pid, not owner - to avoid confusion.
> 
> > But it's meant to be the owner and not necessarily the creator.
> > That's why its value is replaced in rdma_accept.
> 
> There is no such thing as a single owner for a fd based resource
> like a RDMA_CM ID. The FD can be held by multiple processes. This is
> why the best you can do by storing PIDs at certain times is to
> constuct a creator_pid. 
> 
> Owner pid can only be determined by cross-referencing the inode of the
> FD that holds the ownership of the object to the processes that hold
> that FD.
> 
> Jason

But an RDMA CM ID is not a FD based resource. An event channel is, but I
want to export ID stats and not event channel stats.
Are you saying that there's a scenario in which an RDMA CM ID is shared
between multiple processes? 
Even if there is such a scenario, I think that by taking the PID of the
one that calls rdma_accept, the idea of an owner stays consistent. 
I don't mind the name btw, just tying it to something else, which isn't
necessarily related.

Nir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
