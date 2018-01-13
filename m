From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: krping problem on 4.15-rc4
Date: Fri, 12 Jan 2018 18:07:17 -0600
Message-ID: <006d01d38c02$793de8c0$6bb9ba40$@opengridcomputing.com>
References: <CAN-5tyH1HO7yzzQLyb5z5Pq=OrHnKzmCrR2MffLguqsEA-mwWg@mail.gmail.com> <00ff01d38a4f$1a979eb0$4fc6dc10$@opengridcomputing.com> <CAN-5tyEwdSOiAk04xjfazxBqwkkTiCjr2dVcCoYLQJw8f37U=w@mail.gmail.com> <017d01d38b14$cbe95670$63bc0350$@opengridcomputing.com> <CAN-5tyGq=hmXY9HZYXpfaytOUV=gb0fri69gj69WKbbYtW3nTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN-5tyGq=hmXY9HZYXpfaytOUV=gb0fri69gj69WKbbYtW3nTQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Olga Kornievskaia' <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Cc: 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Ok.  The memory probably doesn't matter.  Maybe run krping client and
> server on the same host (to use hw-loopback), and see if it works on both,
> one, or neither systems when they are both the client and server.
> 
> Loopback on the original "server" machine produces the same failure.
> Jan 12 17:05:40 localhost kernel: mlx5_0:dump_cqe:277:(pid 0): dump error
> cqe
> Jan 12 17:05:40 localhost kernel: 00000000 00000000 00000000 00000000
> Jan 12 17:05:40 localhost kernel: 00000000 00000000 00000000 00000000
> Jan 12 17:05:40 localhost kernel: 00000000 00000000 00000000 00000000
> Jan 12 17:05:40 localhost kernel: 00000000 93003204 1000017c 0005e1d2
> Jan 12 17:05:40 localhost kernel: krping: cq completion failed with
> wr_id 0 status 4 opcode 0 vender_err 32

Can someone from Mellanox comment more on the above CQE error?  What exactly is it tell us?

> 
> What does this means?

Not sure.  But it does seem to be tied to that specific machine.  Question:  Is an IOMMU enabled on that system?  Perhaps that is exposing a dma mapping problem with krping?

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
