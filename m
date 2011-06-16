From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/17] rdma/core: Add SRQ type
Date: Thu, 16 Jun 2011 15:00:38 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823730217A6@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373020FFA@ORSMSX101.amr.corp.intel.com>
 <4DFA1923.8080201@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DFA1923.8080201-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I don't see mlx4 in the hw drivers list, probably you handle it later
> on, to have things clearer and bisect-able, I guess you might want to
> touch mlx4 already at this point of the series?

Yes - I can add the same check to mlx4 and remove it when xrc srq support is added in a later patch.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
