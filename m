From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: nfsrdma broken on 2.6.34-rc1?
Date: Mon, 29 Mar 2010 13:26:03 -0700
Message-ID: <adaaatqx4bo.fsf@roland-alpha.cisco.com>
References: <4BB0E670.3010507@opengridcomputing.com>
	<B18454F3200D4A43B57F175388845AAC@amr.corp.intel.com>
	<adaiq8fvtos.fsf@roland-alpha.cisco.com>
	<20100329193715.GA28070@obsidianresearch.com>
	<4BB104D2.9080309@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BB104D2.9080309-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (Steve Wise's message of
	"Mon, 29 Mar 2010 14:51:46 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > This issue is really not in the NFS-RDMA code.  the nfsd code is doing
 > the binding.  See commit:

I think the really relevant thing is 7d21c0f9 ("SUNRPC: Set IPV6ONLY
flag on PF_INET6 RPC listener sockets") and followups.  NFS expects to
have one IPv6-only socket and one IPv4-only socket.

It seems RDMA CM should create a similar V6ONLY option for binding (and
probably default to the /proc/sys/net/ipv6/bindv6only sysctl value) to
handle this.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
