From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 5/6] RDMA CM: Save Owning PID
Date: Wed, 22 Dec 2010 15:10:56 -0700
Message-ID: <20101222221056.GA11819@obsidianresearch.com>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
 <1292257370-24391-6-git-send-email-nirm@voltaire.com>
 <20101214183458.GD2506@obsidianresearch.com>
 <1292769382.2369.2145.camel@nirm-desktop>
 <20101220215433.GB12090@obsidianresearch.com>
 <1292943950.2369.3198.camel@nirm-desktop>
 <20101221181043.GD12090@obsidianresearch.com>
 <7E95F01E94AB484F83061FCFA35B39F8794E3F@exil.voltaire.com>
 <20101221203627.GE12090@obsidianresearch.com>
 <1293033813.2369.4404.camel@nirm-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1293033813.2369.4404.camel@nirm-desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 22, 2010 at 06:03:33PM +0200, Nir Muchtar wrote:

> Right now this is also the only practical way to export this
> information, because RDMA CM/UCM don't behave like sock does in terms of
> inode information. 

Are you referring to how proc/fd currently shows
/dev/infiniband/rdma_cm for the link destination ?

I thought I saw something go by that added the struct file * address
or similar to proc/fdinfo/ but I see it did not get in. Grump.

> Also, in practice, many RDMA CM IDs are, in fact, created by the kernel
> (when new connections are established), so I'm not sure if what you're
> suggesting is even feasible with the current design of RDMA CM.

All RDMA CM IDs are assigned an idr number in ctx_idr and matched to a
ucma_file object before they become visible to userspace and thus
owned by a process. RDMA CM IDs that have not gone through this step
are floating about in the kernel and don't need to be matched to pids.

It is really straighfroward to do: run idr_for_each over ctx_idr, find the
ucma_contex->cm_id that matches the rdma_cm_id you are dumping, fill a
netlink attribute with the ctx id and something from
ucma_context->file to cross refrence with (the currently missing)
something in fdinfo. If you don't find an idr entry then don't emit
anything - it isn't exported to userspace.

Anyhow, I'd be happy if you stuck with creator_pid and left this for
future. But, you might want to consider dumping the ctx id from ucma -
since that is very useful.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
