From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: issues with the rdma-cm server side mapping of IP to GID
Date: Mon, 3 Mar 2014 18:47:39 +0200
Message-ID: <CAJZOPZ+ZC62FeZCy17ZMkzkxqrTdTrNRDs+nWQQ4Xjb9Sx5T3A@mail.gmail.com>
References: <530C51EF.2000509@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237388D1F0BD@ORSMSX109.amr.corp.intel.com>
	<5312F107.2000404@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237388D1F39F@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388D1F39F-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 3, 2014 at 4:46 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>> I'm not sure that this results in a single error case.

>> Sorry... I'm not sure to follow, can you elaborate a bit more?

> We don't know what type of device responds to the ARP query.  It could come from an ethernet device.

Yep, this issue is really nasty..., but wait, you mentioned Ethernet,
well, if the fabric is IB we do know that the GID in the REQ belongs
to an HCA of that server node, b/c the client did route (== path
query) resolution based on this DGID and their CM REQ landed in our
hands, right?

We could come and say that we adhere to the IP --> GID mapping as
present in the CM REQ (GID in the path, IP in the CMA header) and
associate the newly created CMA ID with the device/port where this GID
resides, no matter what the local IP stack has to say. This would
work, but for people that seek HA for their apps, multiple sessions
can be created over the same server hca/port where they wanted them to
be spreaded...  what we can when such inconsistency is observed by the
rdma-cm is the following

1. print warning to the system log
2. reject the connection request
3. send Gratuitous ARP to update client nodes IPoIB neighbour IP --> GID mapping

I suggest that we 1st debate/agree on something that makes sense with
IB and later see how it would work for RoCE

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
