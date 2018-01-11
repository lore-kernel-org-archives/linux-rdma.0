From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: krping problem on 4.15-rc4
Date: Thu, 11 Jan 2018 13:45:55 -0600
Message-ID: <017d01d38b14$cbe95670$63bc0350$@opengridcomputing.com>
References: <CAN-5tyH1HO7yzzQLyb5z5Pq=OrHnKzmCrR2MffLguqsEA-mwWg@mail.gmail.com> <00ff01d38a4f$1a979eb0$4fc6dc10$@opengridcomputing.com> <CAN-5tyEwdSOiAk04xjfazxBqwkkTiCjr2dVcCoYLQJw8f37U=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN-5tyEwdSOiAk04xjfazxBqwkkTiCjr2dVcCoYLQJw8f37U=w@mail.gmail.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Olga Kornievskaia' <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Cc: 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Hey Olga,
> >
> > Are the machines the same kernel version / distro sw / and hw -
> cpu/motherboard/memory/etc?  If not, what is different about them?  Is it the
> krping server that sees the CQ error?  Do other rdma devices work on these
> systems?
> 
> Hi Steve,
> 
> Machines software is the same kernel version (4.15-rc4) / distro sw
> (RHEL7.4). Hardware of those machines the same (PRIMERGY RX200 S7) but
> one machine has 8G less memory than the other (64G vs 56G). kpring
> error was on the server. These machines only have 1 CX-5 no other RDMA
> devices.
> 

Ok.  The memory probably doesn't matter.  Maybe run krping client and server on the same host (to use hw-loopback), and see if it works on both, one, or neither systems when they are both the client and server.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
