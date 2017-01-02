From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Do not copy uninitialized data in
 ibv_cmd_modify_qp
Date: Mon, 2 Jan 2017 14:14:30 -0700
Message-ID: <20170102211430.GC5544@obsidianresearch.com>
References: <20161222221334.GA15907@obsidianresearch.com>
 <1483344105.3592.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483344105.3592.1.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 02, 2017 at 08:02:02AM +0000, Bart Van Assche wrote:
> On Thu, 2016-12-22 at 15:13 -0700, Jason Gunthorpe wrote:
> > Valgrind reports:
> > 
> > ==1196== Syscall param write(buf) points to uninitialised byte(s)
> > ==1196==    at 0x506250D: ??? (syscall-template.S:84)
> > ==1196==    by 0x527756F: ibv_cmd_modify_qp (cmd.c:1291)
> > ==1196==    by 0x8008D74: mlx4_modify_qp (verbs.c:820)
> > ==1196==    by 0x527E4F4: ibv_modify_qp@@IBVERBS_1.1 (verbs.c:561)
> > ==1196==    by 0x4E3FAB3: ucma_modify_qp_err.isra.6 (cma.c:1115)
> > ==1196==    by 0x4E41D56: rdma_get_cm_event.part.15 (cma.c:2180)
> > ==1196==    by 0x402CF0: cm_thread (rping.c:576)
> > ==1196==    by 0x5059709: start_thread (pthread_create.c:333)
> > ==1196==    by 0x558A82C: clone (clone.S:109)
> > ==1196==  Address 0x9847980 is on thread 2's stack
> > ==1196==  in frame #2, created by mlx4_modify_qp (verbs.c:775)
> > 
> > This is because of code like this:
> > 
> >         struct ibv_qp_attr qp_attr;
> >         qp_attr.qp_state = IBV_QPS_ERR;
> >         return rdma_seterrno(ibv_modify_qp(id->qp, &qp_attr, IBV_QP_STATE));
> > 
> > Always pass 0 into the kernel for for attributes that are not requested

> Have you considered to modify Valgrind? It is possible to modify Valgrind
> such that it doesn't report false positives like the above report without
> changing the rdma-core code. See also PRE(sys_ioctl) in source file
> coregrind/m_syswrap/syswrap-linux.c.

I felt that passing uninitialized memory into the kernel was just
in general a bad idea, and adding the branchs to copy zero instead of
un-init is probably performance neutral.

Even so, I don't think we can fix valgrind, ioctl is a different case
as ioctls are much more well defined, this is write() and valgrind
would have to first know we are writing to a uverbs FD which seems
challenging to determine, can valgrind already do this?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
