From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Thu, 4 Jun 2015 14:19:53 -0600
Message-ID: <20150604201953.GA7227@obsidianresearch.com>
References: <1433420809-13529-1-git-send-email-kaike.wan@intel.com>
 <1433420809-13529-5-git-send-email-kaike.wan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433420809-13529-5-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 04, 2015 at 08:26:49AM -0400, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> This patch routes a SA pathrecord query to netlink first and processes the
> response appropriately. If a failure is returned, the request will be sent
> through IB. The decision whether to route the request to netlink first is
> determined by the presence of a listener for the local service netlink
> multicast group. If the user-space local service netlink multicast group
> listener is not present, the request will be sent through IB, just like
> what is currently being done.

Why doesn't this follow the usual netlink usage idioms? I don't see a
single nla_put or nla_nest_start, which, based on the RFC, is what I
expect to see. Don't home brew net link message construction without a
really great reason.

I am very surprised to see this layered under send_mad, all the
context is lost at that point, and it makes it impossible to provide
all the non-IB context (IP addrs, netdevs, QOS, etc)

Confused why all sorts of LS_NLA_PATH_F_X are defined but only
LS_NLA_PATH_F_USER is referenced. What does F_USER even mean? I'm
pretty sure that should be the same as cma:
  (IB_PATH_GMP | IB_PATH_PRIMARY | IB_PATH_BIDIRECTIONAL))

Why define new path flags when this is already done as a UAPI?

Not sure the reply parse is done right either, where is the for loop?

The entire point of the original comment was to move away from using
IB SA Path query MADs in netlink, but this really only changes the
reply format. Better, but wondering if we should go further.

I was hoping to see the three callers of ib_sa_path_rec_get contribute
their information to the netlink message.

Suggest putting all the netlink stuff in its own file..

Bunch of smaller stuff, can look at v4..

Overall, much improved, I think.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
