From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 5/5] RDMA CM: Netlink Client
Date: Tue, 30 Nov 2010 11:19:44 -0700
Message-ID: <20101130181944.GI16788@obsidianresearch.com>
References: <1291047399-430-1-git-send-email-nirm@voltaire.com>
 <1291047399-430-6-git-send-email-nirm@voltaire.com>
 <20101129191136.GC16788@obsidianresearch.com>
 <1291126171.3155.250.camel@nirm-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1291126171.3155.250.camel@nirm-desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 30, 2010 at 04:09:31PM +0200, Nir Muchtar wrote:

> > struct ib_nl_qp
> > {
> >         // String names for IB devices was a mistake, don't perpetuate it.
> 
> I don't know of an IB device index mapping like the one in netdevice.
> Am I missing one? Do you mean we should create one?

Yes, definately. It is very easy to do and goes hand-in-hand with the
typical netlink protocol design.
 
> >         __u32 ib_dev_if;
> > 	__u32 qp_num;
> >         __s32 creator_pid; // -1 for kernel consumer
> > };
> > 
> > struct ib_nl_qp_cm_info
> > {
> >       u32 cm_state; // enum ib_cm_state
> >       u32 lap_state;
> > };
> > 
> > struct ib_nl_rdma_cm_info
> > {
> > 	__u32 bound_dev_if;
> >         __u32 family;
> > 	__u32 cm_state; // enum rdma_cm_state
> > };
> > 
> > This captures more information and doesn't tie things to RDMA_CM.
> 
> My problem with making everything QP related is that not everything
> necessarily is. For example, when creating rdma cm id's they are still 
> not bound to QP's. I guess you could send all zeros in this case, but as
> more and more of such exceptions are needed this framework will become a
> bit unnatural. The current implementation is not tying anything to RDMA
> CM. It allows other modules to export data exactly the way they need.

Well, I was outlining how I think the QP-centric information can be
returned. You are right that we also have non-QP info, like listening
objects, and I think that can be best returned with a seperate
query. Trying to conflate them seems like it would be
trouble. Certainly, as I've described IBNL_QP messages should only
refer to active QPs.

Remember you can have as many queries as you like, this is just the QP
object query.

I guess an alternative would be to have many tables: RDMA_CM, QP, and
IB_CM and then rely on userspace to 'join' them by ifindex+QPN - but
that seems like alot of work in userspace and I think pretty much
everyone is going to want to have the joined data.

> > > +static int cma_get_stats(struct sk_buff **nl_skb, int pid)
> > 
> > You really have to use netlink_dump_start here, doing it like this
> > will deadlock. See how other places use NLM_F_DUMP as well.
> 
> Well, I already reviewed netlink_dump_start, and this is how it works 
> as much as I can see (Please correct me if I'm wrong):
> 1. Allocates an skb
> 2. Calls its supplied dump cb
> 3. Calls its supplied done cb if if applicable
> 4. Appends NLMSG_DONE

No, this isn't quite right. The dumpcb is also called after userspace
calls recvmsg(), which continues the dump once the buffer is
freed. The idea is to return a bit of the table on every dump call
back.

The way it is used is:
 1. Userspace does send()
 2. Kernel calls netlink_dump_start()
 3. netlink_dump_start calls callback which returns non-zero
 4. send() returns in userspace
 5. Userspace does recv()
 6. Kernel copies the data from #3 into userspace
 7. netlink_dump calls callback which returns non-zero
 8. recv() returns in userspace
 [...]

> Thanks again for all your input.

Thanks for working on this!

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
