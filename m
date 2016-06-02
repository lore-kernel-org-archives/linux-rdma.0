From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next 00/29] Soft RoCE driver
Date: Thu, 2 Jun 2016 13:05:47 -0500
Message-ID: <021601d1bcf9$63dbe8d0$2b93ba70$@opengridcomputing.com>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464886657-14258-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> 
> Hi Doug,
> 
> Soft RoCE (RXE) - The software RoCE driver
> 
> ib_rxe implements the RDMA transport and registers to the RDMA core device as
a
> kernel verbs provider. It also implements the packet IO layer. On the other
hand
> ib_rxe registers to the Linux netdev stack as a udp encapsulating protocol, in
> that case RDMA, for sending and receiving packets over any Ethernet device.
> This yields a RDMA transport over the UDP/Ethernet network layer forming a
> RoCEv2
> compatible device.

Hey Moni, 

I wonder if rxe can utilize the rdmavt library?

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
