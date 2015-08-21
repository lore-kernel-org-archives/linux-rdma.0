From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v9 0/4] Sending kernel pathrecord query to user cache
 server
Date: Fri, 21 Aug 2015 17:07:34 -0600
Message-ID: <20150821230734.GA16951@obsidianresearch.com>
References: <1439556729-27876-1-git-send-email-kaike.wan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1439556729-27876-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 14, 2015 at 08:52:05AM -0400, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:

> Some tests with namespace have been performed:
> 1. An unprivileged user cannot bind to the RDMA_NL_GROUP_LS multicast
>    group;
> 2. An unprivileged user cannot create a new network namespace. However,
>    it can create a new user namespace together with a new network
>    namespace by using clone() with CLONE_NEWUSER | CLONE_NEWNET flags;
> 3. In the user and network namespaces created by an unprivileged user,
>    the user can be mapped into root and thus be able to bind to the
>    RDMA_NL_GROUP_LS multicast group. However, it can neither send 
>    requests to the kernel RDMA netlink code nor receive requests from
>    it. This is because kernel RDMA netlink code associates itself with
>    the init_net network namespace, which in turn associates itself with
>    init_user_ns namespace. 

Haggie, how does this coverage match your expectations with your
namespace series?

Kaike, how does #3 work? If I create a user namespace and try to bind
it succeeds to userspace but ibnl_chk_listeners still returns false in
the kernel?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
