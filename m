From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Fri, 5 Jun 2015 10:57:03 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CAB4FD7@CRSMSX101.amr.corp.intel.com>
References: <1433420809-13529-1-git-send-email-kaike.wan@intel.com>
 <1433420809-13529-5-git-send-email-kaike.wan@intel.com>
 <20150604201953.GA7227@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150604201953.GA7227-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Thursday, June 04, 2015 4:20 PM
> 
> On Thu, Jun 04, 2015 at 08:26:49AM -0400, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > This patch routes a SA pathrecord query to netlink first and processes
> > the response appropriately. If a failure is returned, the request will
> > be sent through IB. The decision whether to route the request to
> > netlink first is determined by the presence of a listener for the
> > local service netlink multicast group. If the user-space local service
> > netlink multicast group listener is not present, the request will be
> > sent through IB, just like what is currently being done.
> 
> Why doesn't this follow the usual netlink usage idioms? I don't see a single
> nla_put or nla_nest_start, which, based on the RFC, is what I expect to see.
> Don't home brew net link message construction without a really great reason.

The only reason why we did not use nla_put is to avoid data copying. For example, to translate the input struct ib_sa_path_rec into struct ib_user_path_rec, we directly use the skb buffer reserved for the pathrecord attribute as the destination (ib_nl_set_path_rec_attr()) of ib_copy_path_rec_to_user, which is essentially the guts of nla_put. To use nla_put directly, we would have to use a temp buffer to hold ib_user_path_rec and then copy it to the skb.

> 
> I am very surprised to see this layered under send_mad, all the context is lost
> at that point, and it makes it impossible to provide all the non-IB context (IP
> addrs, netdevs, QOS, etc)

As Sean pointed out in a separate e-mail, this provides benefits to more applications. Currently, rdma_cm, ipoib, and SRP calls ib_sa_path_rec_get() to query pathrecord. In addition, this does not preclude optimization in other locations in the kernel in the future.

> 
> Confused why all sorts of LS_NLA_PATH_F_X are defined but only
> LS_NLA_PATH_F_USER is referenced. What does F_USER even mean? 

it indicates that the format of the attribute is struct ib_user_path_rec instead of packed MAD wire format (or struct ibv_path_rec in user space). This has been documented in the original RFC.

I'm
> pretty sure that should be the same as cma:
>   (IB_PATH_GMP | IB_PATH_PRIMARY | IB_PATH_BIDIRECTIONAL))
> 
> Why define new path flags when this is already done as a UAPI?

yes, the flag is really copied from the pathrecord flags for struct ib_path_rec_data in include/uapi/rdma/ib_user_sa.h because our pathrecord attribute (struct rdma_nla_ls_path_rec) is similar to struct ib_path_rec_data, but not exactly the same.  That's why we should define its own flags as a separate entity.

> 
> Not sure the reply parse is done right either, where is the for loop?

Well, for ib_sa_path_rec_get(), we are expecting to see only one pathrecord in the response. For other kernel locations where multiple pathrecords are expected, one may have to iterate through all returned attributes.

> 
> The entire point of the original comment was to move away from using IB SA
> Path query MADs in netlink, but this really only changes the reply format.
> Better, but wondering if we should go further.
> 
> I was hoping to see the three callers of ib_sa_path_rec_get contribute their
> information to the netlink message.
> 
> Suggest putting all the netlink stuff in its own file..

All our netlink stuff is based on the rdma_netlink.h definitions (client, multicast group, opcode, attributes) and I think that the include/uapi/rdma/rdma_entlink.h file is its natural habitat.

> 
> Bunch of smaller stuff, can look at v4..
> 
> Overall, much improved, I think.
> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
