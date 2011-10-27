From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: REQ GID enforcement in the CM
Date: Thu, 27 Oct 2011 10:55:22 -0600
Message-ID: <20111027165522.GA16878@obsidianresearch.com>
References: <4EA9672F.2010601@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4EA9672F.2010601-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 27, 2011 at 04:14:07PM +0200, Or Gerlitz wrote:

> Looking on that case, I noted that the CM code (SB) checks that the
> GID in the incoming REQ is present in at least of one the ports of
> the relevant device, but not specifically on the port this request
> arrived to, is that following IBTA? I thought it could be
> problematic e.g in the case of RC QP being set by this
> establishment, later the RC packets would be dropped by the device
> if they have GRH and the GID isn't on that port table, isn't that?

You can use the CM to establish a connection on another port, eg send
CM GMPs to port 1, specify the primary data path is port 2 and specify
the alternate data path is port 1.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
