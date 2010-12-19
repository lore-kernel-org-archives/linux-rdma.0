From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V3 6/6] RDMA CM: Netlink Client
Date: Sun, 19 Dec 2010 16:47:32 +0200
Message-ID: <1292770052.2369.2157.camel@nirm-desktop>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
	 <1292257370-24391-7-git-send-email-nirm@voltaire.com>
	 <20101214184514.GE2506@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101214184514.GE2506-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2010-12-14 at 11:45 -0700, Jason Gunthorpe wrote:
> On Mon, Dec 13, 2010 at 06:22:50PM +0200, Nir Muchtar wrote:
> > +			if (ibnl_put_attr(skb, nlh,
> > +					  sizeof id->route.addr.src_addr,
> > +					  &id->route.addr.src_addr,
> > +					  IBNL_RDMA_CM_ATTR_SRC_ADDR)) {
> > +				goto out;
> > +			}
> 
> The sizeof the attribute should be sizeof(sockaddr_in) or
> sizeof(sockaddr_in6), not sizeof(sockaddr_storage).
> 
> Other rdma_cm code uses this sort of construct:
> 
>         memcpy(&resp.src_addr, addr, addr->sa_family == AF_INET ?
>                                      sizeof(struct sockaddr_in) :
>                                      sizeof(struct sockaddr_in6));
> 

Hmm, I was under the impression that sockaddr_storage was what Sean had
asked for. 
Sean, is sockaddr_in6/sockaddr_in good enough?

Btw, Why do you think this should be changed? Message size
considerations?

> > +struct rdma_cm_id_stats {
> > +	u8 nt;
> > +	u8 port_num;
> > +	u32 bound_dev_if;
> > +	u32 ps;
> > +	u8 cm_state;
> > +	u32 qp_num;
> > +	pid_t pid;
> > +};
> 
> Careful of alignment issues and and type issues:
> 
> struct rdma_cm_id_stats {
>   u32 bound_dev_if;
>   u32 resereved_for_ib_bound_dev_ib;
>   u32 port_space;
>   u32 creator_pid;
>   u8 nt;  // Use a better name
>   u8 port_num;
>   u8 cm_state;
>   u8 reserved;
> };
> 

I'll fix that. Thanks.

> Rather than pid I think it is better to include enough information to
> cross reference the RDMA_CM fd aginst /proc/../fd. Ie to get the pid(s)
> you trundle through proc looking for that signature. Isn't that what
> ss does?
> 
> Jason

Do you mean the file descriptor which is associated with the
rdma_event_channel? The event channel is created using ucma and not cma.
I don't think there's access to that information from cma. Even if there
was such access, ucma doesn't save inode info that can be cross
referenced as sock does.
Also, what about kernel threads that own ID's?

Nir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
