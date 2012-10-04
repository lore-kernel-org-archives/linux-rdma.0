From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Problem running rping over Intel adapters
Date: Thu, 4 Oct 2012 15:01:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A99126@FMSMSX151.amr.corp.intel.com>
References: <506CB0E9.90201@redhat.com>
 <1828884A29C6694DAF28B7E6B8A8237346A98E58@FMSMSX151.amr.corp.intel.com>
 <506CB4D8.4010604@redhat.com>
 <1828884A29C6694DAF28B7E6B8A8237346A98E8E@FMSMSX151.amr.corp.intel.com>
 <506CEAC1.9070808@opengridcomputing.com> <506D2174.10601@mellanox.com>
 <506D9CD2.20606@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <506D9CD2.20606-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> retry_count, I assume, is for connection establishment?  For the Chelsio
> devices, this is all up to the TCP stack and thus this counter is not
> used.  If there is no TCP listener, then the connection establishment
> will fail immediately.  If the node is not reachable, then normal TCP
> retransmit rules apply, but once TCP gives up, then the rdma connection
> establishment will fail.

On IB, this is a transport level retry of a lost request.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
