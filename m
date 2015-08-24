From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v9 0/4] Sending kernel pathrecord query to user cache
 server
Date: Mon, 24 Aug 2015 18:10:31 +0300
Message-ID: <55DB33E7.6060500@mellanox.com>
References: <1439556729-27876-1-git-send-email-kaike.wan@intel.com>
 <20150821230734.GA16951@obsidianresearch.com>
 <3F128C9216C9B84BB6ED23EF16290AFB18548AF0@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB18548AF0-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 24/08/2015 17:32, Wan, Kaike wrote:
>> On Fri, Aug 14, 2015 at 08:52:05AM -0400, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>> > 
>>> > > Some tests with namespace have been performed:
>>> > > 1. An unprivileged user cannot bind to the RDMA_NL_GROUP_LS multicast
>>> > >    group;
>>> > > 2. An unprivileged user cannot create a new network namespace. However,
>>> > >    it can create a new user namespace together with a new network
>>> > >    namespace by using clone() with CLONE_NEWUSER | CLONE_NEWNET
>> > flags;
>>> > > 3. In the user and network namespaces created by an unprivileged user,
>>> > >    the user can be mapped into root and thus be able to bind to the
>>> > >    RDMA_NL_GROUP_LS multicast group. However, it can neither send
>>> > >    requests to the kernel RDMA netlink code nor receive requests from
>>> > >    it. This is because kernel RDMA netlink code associates itself with
>>> > >    the init_net network namespace, which in turn associates itself with
>>> > >    init_user_ns namespace.
>> > 
>> > Haggie, how does this coverage match your expectations with your
>> > namespace series?
>> > 
>> > Kaike, how does #3 work? 
> I created a test app that used clone() with CLONE_NEWUSER | CLONE_NEWNET to create child process (modeled after the user_namespace man page example: http://man7.org/linux/man-pages/man7/user_namespaces.7.html). Once the child process was mapped to root (uid 0),   it created the netlink socket and bound to the RDMA_NL_GROUP_LS and waited to receive requests from the kernel.
> 
> If I create a user namespace and try to bind it
>> > succeeds to userspace but ibnl_chk_listeners still returns false in the kernel?
> ibnl_chk_listeners() actually returned 0 (success), indicating that there were listeners. However, ibnl_multicast() failed. From the code of netlink_has_listeners(), it is apparently that the check has nothing to do with namespace (that's why it succeeded).

It looks like the ibnl socket (nls) is created with the &init_net 
network namespace, and netlink won't send multicasts to sockets on 
other namespaces (see [1]).

Haggai

[1] http://lxr.free-electrons.com/source/net/netlink/af_netlink.c?v=4.1#L1935
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
