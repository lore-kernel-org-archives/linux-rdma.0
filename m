From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 5/6] RDMA CM: Save Owning PID
Date: Tue, 21 Dec 2010 11:10:43 -0700
Message-ID: <20101221181043.GD12090@obsidianresearch.com>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
 <1292257370-24391-6-git-send-email-nirm@voltaire.com>
 <20101214183458.GD2506@obsidianresearch.com>
 <1292769382.2369.2145.camel@nirm-desktop>
 <20101220215433.GB12090@obsidianresearch.com>
 <1292943950.2369.3198.camel@nirm-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1292943950.2369.3198.camel@nirm-desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 21, 2010 at 05:05:50PM +0200, Nir Muchtar wrote:

> But an RDMA CM ID is not a FD based resource. An event channel is, but I
> want to export ID stats and not event channel stats.
> Are you saying that there's a scenario in which an RDMA CM ID is shared
> between multiple processes?

It *is* a FD based resource. Nearly everything in Linux is.

It is tied to the ucma_fops FD (ie /dev/rdma_cm, aka the event
channel), which when closed calls ucma_free_ctx which calls
rdma_destroy_id. Processes that can access that FD can control the
RDMA CM IDs associated with it.

The only case where this is not true is in the kernel, and in that
instance the PID is meaningless - you'd be much better off exporting
the name of the module that allocated the RDMA CM ID.

> Even if there is such a scenario, I think that by taking the PID of the
> one that calls rdma_accept, the idea of an owner stays consistent. 
> I don't mind the name btw, just tying it to something else, which isn't
> necessarily related.

The proper thing for userspace is to tie it back to the FD that owns
the resource - which is the FD that destroys the resource when it is
closed.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
