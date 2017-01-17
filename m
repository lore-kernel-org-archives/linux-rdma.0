From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 1/7] IB/core: Refactor IDR to be per-device
Date: Tue, 17 Jan 2017 11:09:13 -0700
Message-ID: <20170117180913.GA27528@obsidianresearch.com>
References: <1484132033-3346-1-git-send-email-matanb@mellanox.com>
 <1484132033-3346-2-git-send-email-matanb@mellanox.com>
 <20170111223917.GA31682@obsidianresearch.com>
 <CAAKD3BDMDyahSu1uFPE_bA=QXAy9Q+qdMPoVw-hJTrFN3um9rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BDMDyahSu1uFPE_bA=QXAy9Q+qdMPoVw-hJTrFN3um9rg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Tue, Jan 17, 2017 at 07:08:02PM +0200, Matan Barak wrote:

> > I'm still unclear why we want the idr to be global and not per
> > /dev/uverbs0 open fd.
> 
> Assuming we keep the current separate fds model (i.e, per-device fd
> and another rdma-cm fd), what is the actual benefit here?  Memory
> wise - we'll probably consume a lot more (every idr layer is > 2K on
> a 64bit architecture), so sharing here might have some memory usage
> benefits.

Well, it makes things simpler and clearer.

- Locking is per ucontext, not per-device global, so it is potentially
  more parallel.
- Obvious that the lifetime of these objects is tied to the lifetime
  of the ucontext
- max idr value is per-context, not per system, so the tree will be
  intrinsiclly smaller. (eg consider a MPI that allocates 1 million
  objects is permanently degrading the global IDR)
- idr exhaustion is per-context not global, thus it plays nicer with
  a memory cgroup controller.
- It is very clear you have to have a ucontext fd to make any use
  of the object numbers - this is an essential property from a
  security perspective.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
