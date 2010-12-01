From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 5/5] RDMA CM: Netlink Client
Date: Wed, 1 Dec 2010 17:58:54 +0200
Message-ID: <1291219134.3155.471.camel@nirm-desktop>
References: <1291047399-430-1-git-send-email-nirm@voltaire.com>
	 <1291047399-430-6-git-send-email-nirm@voltaire.com>
	 <20101129191136.GC16788@obsidianresearch.com>
	 <1291126171.3155.250.camel@nirm-desktop>
	 <20101130181944.GI16788@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101130181944.GI16788-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-11-30 at 11:19 -0700, Jason Gunthorpe wrote:

> > I don't know of an IB device index mapping like the one in netdevice.
> > Am I missing one? Do you mean we should create one?
> 
> Yes, definately. It is very easy to do and goes hand-in-hand with the
> typical netlink protocol design.

I agree, but this is a bit out of scope for the current patches and I
think this kind of change should be given some thought. It needs to
supply userspace with mapping functions and I don't think it will be
that easy to complete. The patch in its current state uses names but it
doesn't perpetuate their use because the rdma cm export is separate from
the infrastructure. Once we have such an ability, it will be very easy
to use here.

> Well, I was outlining how I think the QP-centric information can be
> returned. You are right that we also have non-QP info, like listening
> objects, and I think that can be best returned with a seperate
> query. Trying to conflate them seems like it would be
> trouble. Certainly, as I've described IBNL_QP messages should only
> refer to active QPs.
> 
> Remember you can have as many queries as you like, this is just the QP
> object query.
> 
> I guess an alternative would be to have many tables: RDMA_CM, QP, and
> IB_CM and then rely on userspace to 'join' them by ifindex+QPN - but
> that seems like alot of work in userspace and I think pretty much
> everyone is going to want to have the joined data.

So we are in agreement that more then one export type is required here.
I do agree that your suggestion will make sense once we try to export QP
related data, so maybe we can agree that I will fully support such a
scheme, so it will be easy to implement later. By that I mean that the
infrastructure will allow adding arbitrary attributes to messages (in
type and in size). What do you think?

> No, this isn't quite right. The dumpcb is also called after userspace
> calls recvmsg(), which continues the dump once the buffer is
> freed. The idea is to return a bit of the table on every dump call
> back.
> 
> The way it is used is:
>  1. Userspace does send()
>  2. Kernel calls netlink_dump_start()
>  3. netlink_dump_start calls callback which returns non-zero
>  4. send() returns in userspace
>  5. Userspace does recv()
>  6. Kernel copies the data from #3 into userspace
>  7. netlink_dump calls callback which returns non-zero
>  8. recv() returns in userspace

Yes that's correct, but inet_diag takes care of the last two steps by
updating its cb index, and not dump_start. If we use it that way we can
have problems with changes in data structure on subsequent recv calls,
so if we want to keep it the same we would still need to employ locking.
I don't see a way to keep the same data without locking and without a
session mechanism of some sort.

Nir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
