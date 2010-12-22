From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V3 5/6] RDMA CM: Save Owning PID
Date: Wed, 22 Dec 2010 18:03:33 +0200
Message-ID: <1293033813.2369.4404.camel@nirm-desktop>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
	 <1292257370-24391-6-git-send-email-nirm@voltaire.com>
	 <20101214183458.GD2506@obsidianresearch.com>
	 <1292769382.2369.2145.camel@nirm-desktop>
	 <20101220215433.GB12090@obsidianresearch.com>
	 <1292943950.2369.3198.camel@nirm-desktop>
	 <20101221181043.GD12090@obsidianresearch.com>
	 <7E95F01E94AB484F83061FCFA35B39F8794E3F@exil.voltaire.com>
	 <20101221203627.GE12090@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101221203627.GE12090-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-12-21 at 13:36 -0700, Jason Gunthorpe wrote:

> The question is how do your correlate the kernel ID with the userspace
> process(es) that have ownership of it. The only way to do that is to
> associate the ID with the event channel FD with the process(es) that
> have access to it.
> 
> Unfortunately there is no other way to correlate the in-kernel ID with
> the process(es) that control it.
> 
> Jason

Ok, seems like we're going in circles...
The fact is that there is a way, that, all arguments aside, just works,
and IMO is coherent with the current way that RDMA CM IDs are managed.

Right now this is also the only practical way to export this
information, because RDMA CM/UCM don't behave like sock does in terms of
inode information. 

Also, in practice, many RDMA CM IDs are, in fact, created by the kernel
(when new connections are established), so I'm not sure if what you're
suggesting is even feasible with the current design of RDMA CM.

I realize you disagree, but I still want to move forward with the rest,
so I'll separate this patch from the rest and we can have a separate
discussion over this in the future.

Nir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
