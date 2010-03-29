From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: nfsrdma broken on 2.6.34-rc1?
Date: Mon, 29 Mar 2010 15:32:36 -0500
Message-ID: <4BB10E64.7060903@opengridcomputing.com>
References: <4BB0E670.3010507@opengridcomputing.com>	<B18454F3200D4A43B57F175388845AAC@amr.corp.intel.com>	<adaiq8fvtos.fsf@roland-alpha.cisco.com>	<20100329193715.GA28070@obsidianresearch.com>	<4BB104D2.9080309@opengridcomputing.com> <adaaatqx4bo.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaaatqx4bo.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > This issue is really not in the NFS-RDMA code.  the nfsd code is doing
>  > the binding.  See commit:
>
> I think the really relevant thing is 7d21c0f9 ("SUNRPC: Set IPV6ONLY
> flag on PF_INET6 RPC listener sockets") and followups.  NFS expects to
> have one IPv6-only socket and one IPv4-only socket.
>
>   

Yes, this new behavior is common to both sockets and rdma transports.

> It seems RDMA CM should create a similar V6ONLY option for binding (and
> probably default to the /proc/sys/net/ipv6/bindv6only sysctl value) to
> handle this.
>   
This makes sense to me.

Tom

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
