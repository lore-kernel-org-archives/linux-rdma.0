From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Fri, 5 Jun 2015 11:05:21 -0600
Message-ID: <20150605170521.GB7776@obsidianresearch.com>
References: <1433420809-13529-1-git-send-email-kaike.wan@intel.com>
 <1433420809-13529-5-git-send-email-kaike.wan@intel.com>
 <20150604201953.GA7227@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CAB4FD7@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB0CAB4FD7-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 05, 2015 at 10:57:03AM +0000, Wan, Kaike wrote:

> > Why doesn't this follow the usual netlink usage idioms? I don't
> > see a single nla_put or nla_nest_start, which, based on the RFC,
> > is what I expect to see.  Don't home brew net link message
> > construction without a really great reason.
> 
> The only reason why we did not use nla_put is to avoid data
> copying. For example, to translate the input struct ib_sa_path_rec
> into struct ib_user_path_rec, we directly use the skb buffer
> reserved for the pathrecord attribute as the destination
> (ib_nl_set_path_rec_attr()) of ib_copy_path_rec_to_user, which is
> essentially the guts of nla_put. To use nla_put directly, we would
> have to use a temp buffer to hold ib_user_path_rec and then copy it
> to the skb.

Okay, but isn't that what nla_reserve is for?

> > I am very surprised to see this layered under send_mad, all the
> > context is lost at that point, and it makes it impossible to
> > provide all the non-IB context (IP addrs, netdevs, QOS, etc)
> 
> As Sean pointed out in a separate e-mail, this provides benefits to
> more applications. Currently, rdma_cm, ipoib, and SRP calls
> ib_sa_path_rec_get() to query pathrecord.

Yes, I saw Sean's comment, and I am glad we all understand there are
only 3 callers. And looking at the callers there are only a small
number of elements being used:

rdma cm:
 IB_SA_PATH_REC_DGID | IB_SA_PATH_REC_SGID |
                    IB_SA_PATH_REC_PKEY | IB_SA_PATH_REC_NUMB_PATH |
                    IB_SA_PATH_REC_REVERSIBLE | IB_SA_PATH_REC_SERVICE_ID;
 IB_SA_PATH_REC_QOS_CLASS;
 IB_SA_PATH_REC_TRAFFIC_CLASS

ipoib:
                                   IB_SA_PATH_REC_DGID          |
                                   IB_SA_PATH_REC_SGID          |
                                   IB_SA_PATH_REC_NUMB_PATH     |
                                   IB_SA_PATH_REC_TRAFFIC_CLASS |
                                   IB_SA_PATH_REC_PKEY,

srp:
                                               IB_SA_PATH_REC_SERVICE_ID |
                                               IB_SA_PATH_REC_DGID       |
                                               IB_SA_PATH_REC_SGID       |
                                               IB_SA_PATH_REC_NUMB_PATH  |
                                               IB_SA_PATH_REC_PKEY,

So, rather than a SA mad in netlink, I'd suggest actually using
extensible netlink here and define the query cleanly using nested
attributes:

RDMA_OP_RESOLVE (request)
  GIDS
  SERVICE_ID
  QOS/TCLASS
  PKEY
  QP TYPE (aka reversible)
  
RDMA_OP_RESOLVE (reply)
  IB_PATH
  IB_PATH
  IB_PATH

This could probably still be done under send_mad, and if you don't
want to finish the job then that is probably fine.

The reason to prefer native netlink format as a UAPI is because it is
more specific. It is very hard to process a general SA Path Record
query mad, there are many combinations and many wonky attributes. That
makes implementing a correct/future proof user space client
unnecessarily hard. With native netlink we can define our own
conventions for UAPI extension.

.. and with only 3 callers we don't have a huge burden to shift if a
kAPI needs to change to make this natural ..

> In addition, this does not preclude optimization in other locations
> in the kernel in the future.

Confused. Adding new netlink attributes is not an optimization, it is
a UAPI enhancement.

> > Confused why all sorts of LS_NLA_PATH_F_X are defined but only
> > LS_NLA_PATH_F_USER is referenced. What does F_USER even mean? 
> 
> it indicates that the format of the attribute is struct
> ib_user_path_rec instead of packed MAD wire format (or struct
> ibv_path_rec in user space). This has been documented in the
> original RFC.

Why do we need two formats in the uapi? Drop the !user one.

Even so, it isn't the netlink way to bury two different structs in the
same attribute, you need to use netlink headers to tell them apart,
not buried flags..

> I'm
> > pretty sure that should be the same as cma:
> >   (IB_PATH_GMP | IB_PATH_PRIMARY | IB_PATH_BIDIRECTIONAL))

You missed this one

You can't just ignore the flag bit, they have to be checked. It is
very important to have an extensible uapi.

> > Why define new path flags when this is already done as a UAPI?
> 
> yes, the flag is really copied from the pathrecord flags for struct
> ib_path_rec_data in include/uapi/rdma/ib_user_sa.h because our
> pathrecord attribute (struct rdma_nla_ls_path_rec) is similar to
> struct ib_path_rec_data, but not exactly the same.  That's why we
> should define its own flags as a separate entity.

I would keep the original flags for consistency, especially once the
!user case is dropped. This is because it should be exactly the same
protocol and system as the other users.

> > Not sure the reply parse is done right either, where is the for loop?
> 
> Well, for ib_sa_path_rec_get(), we are expecting to see only one
> pathrecord in the response. For other kernel locations where
> multiple pathrecords are expected, one may have to iterate through
> all returned attributes.

No, you must accept multiple attributes and loop to find a supported
one (today's kernel only supports (IB_PATH_GMP | IB_PATH_PRIMARY |
IB_PATH_BIDIRECTIONAL)). Review the other implementations of IB_PATH_*
flags in the kernel to see how this works.

Otherwise future extensibility is compromised.

> > Suggest putting all the netlink stuff in its own file..
> 
> All our netlink stuff is based on the rdma_netlink.h definitions
> (client, multicast group, opcode, attributes) and I think that the
> include/uapi/rdma/rdma_entlink.h file is its natural habitat.

I mean the .c file stuf.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
