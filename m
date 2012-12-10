From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ib/roce VLAN ibv_rc_pingpong test
Date: Mon, 10 Dec 2012 16:42:05 +0200
Message-ID: <CAJZOPZ+kX=5ZRx23y7+NU0vNAR7qr3zaWwGS+7edqyA_TjgdPQ@mail.gmail.com>
References: <OF5408F09F.E7FD583F-ONC1257AD0.0045268E-C1257AD0.0048C908@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF5408F09F.E7FD583F-ONC1257AD0.0045268E-C1257AD0.0048C908-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 10, 2012 at 3:14 PM, Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org> wrote:
> 2. The switch (BNT virt. fabric 10GB) has configured all ports as "vlan
> tagging=enabled" (trunk-mode)
[...]
> Failed status transport retry counter exceeded (12) for wr_id 2
[...]
> Now my questions are: Any ideas what causes the "ibv_rc_pingpong" to fail?
> What should be the next step in debugging this situation?

use port mirroring on the switch and have the port connected to the
server node to mirror
all its TX traffic to the port connected to 3rd host with 10g card,
issue tcpdump on that 3rd host and see that you indeed get the RoCE
packets and the switch doesn't drop them

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
