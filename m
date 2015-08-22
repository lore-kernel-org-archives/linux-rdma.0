From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v9 0/4] Sending kernel pathrecord query to user cache
 server
Date: Sat, 22 Aug 2015 06:17:20 +0000
Message-ID: <HE1PR05MB1355E1D8E5BB937DBAA489E2C1640@HE1PR05MB1355.eurprd05.prod.outlook.com>
References: <1439556729-27876-1-git-send-email-kaike.wan@intel.com>,<20150821230734.GA16951@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150821230734.GA16951-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Saturday, August 22, 2015 2:07 AM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Fri, Aug 14, 2015 at 08:52:05AM -0400, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> 
>> Some tests with namespace have been performed:
>> 1. An unprivileged user cannot bind to the RDMA_NL_GROUP_LS multicast
>>    group;
>> 2. An unprivileged user cannot create a new network namespace. However,
>>    it can create a new user namespace together with a new network
>>    namespace by using clone() with CLONE_NEWUSER | CLONE_NEWNET flags;
>> 3. In the user and network namespaces created by an unprivileged user,
>>    the user can be mapped into root and thus be able to bind to the
>>    RDMA_NL_GROUP_LS multicast group. However, it can neither send
>>    requests to the kernel RDMA netlink code nor receive requests from
>>    it. This is because kernel RDMA netlink code associates itself with
>>    the init_net network namespace, which in turn associates itself with
>>    init_user_ns namespace.
> 
> Haggie, how does this coverage match your expectations with your
> namespace series?

It sounds good. Our thinking was that the network namespace assigns netdevs to namespaces, and we don't want to assign an entire IB device to a namespace, so it isn't suitable for restricting applications that deal with IB directly. RDMA CM already used IP addressing so it is was suitable to be changed to work only with the devices in a process's network namespace.

We also discussed creating a cgroup for RDMA later on, that could make sure a container can only use certain P_Keys, for applications that don't use RDMA CM. Such a cgroup could also be used to limit the SA queries a process can issue.

Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
