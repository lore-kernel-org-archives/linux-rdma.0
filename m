From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] ibacm/libacm.c: Use IPv4 rather than IPv6 for ACM server
 communication
Date: Thu, 5 Apr 2012 14:51:18 -0600
Message-ID: <20120405205118.GB6575@obsidianresearch.com>
References: <4F7DFB04.2030803@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4F7DFB04.2030803-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 05, 2012 at 04:05:24PM -0400, Hal Rosenstock wrote:
 
> When both IPv4 and IPv6 are running, getaddrinfo indicates IPv6
> rather than IPv4 and that currently causes a failure to connect to
> the ACM server. Fix is to set the address family in the hint to
> getaddrinfo to IPv4.

We are in the future, the daemon should listen for IPv6 connections.

Drepper has a description on how to do this properly:

http://www.akkadia.org/drepper/userapi-ipv6.html

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
