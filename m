From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Encode the private ABI version number
 in verbs_register_driver
Date: Fri, 1 Sep 2017 15:30:21 -0500
Message-ID: <20170901203021.GA5832@ctung-MOBL3.amr.corp.intel.com>
References: <20170824215601.GA19717@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170824215601.GA19717-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 24, 2017 at 04:56:01PM -0500, Jason Gunthorpe wrote:
> This causes the symbol table to look like:
> 
>    208: 000000000000c000   142 FUNC    GLOBAL DEFAULT   13 verbs_register_driver_15@@IBVERBS_PRIVATE_15
> 
> Which encodes the expected private ABI version inside the symbol name
> as well as with the symbol version.
> 
> This ensures that the ABI version is checked even if the linking
> environment does not include symbol versions, for instance if an
> end user is linking a provider static library to the system dynamic
> libibverbs.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  buildlib/config.h.in         |  1 +
>  libibverbs/driver.h          | 11 +++++++++++
>  libibverbs/libibverbs.map.in |  2 +-
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> Since Leon says people are using static provider libraries we should
> do more to make sure they work right.

Jason,

Can you dumb this down for me?  I don't understand the provider static library part.
Do you mean an application statically linking in a provider library and dynamically
to libibverbs?  Why would someone do this?  Are there examples of this?

Thanks,

Chien
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
