From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: DREQ timeout for rdma-cm consumers
Date: Thu, 28 Jan 2010 09:41:35 -0800
Message-ID: <C2C13483FFBB484FB03A08F58E5D0DC0@amr.corp.intel.com>
References: <Pine.LNX.4.64.1001261749260.13804@zuben.voltaire.com> <F766FA8B1AD74F0E98EF28981448A4CF@amr.corp.intel.com> <4B618B3F.9030803@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B618B3F.9030803-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>I understand that, however, currently the code I am working with (iser)
>wait to get both flushes on all the posted work requests AND disconnect
>or address-change event to mark the <rdmacm id, qp> couple as
>disconnected, clear it up and signal higher level to reconnect. I'll
>have to look what is the way to go for fast reconnection, maybe connect
>a new <id, qp> couple before the current one is totally
>flushed/disconnected. Also, destroying the ID doesn't remove the qpn
>from the IB CM timewait database, correct? hence if I don't wait long
>enough and the driver/hw reuses the qpn short enough to hit the IB CM
>stale connection/etc logic, I will not be able to reconnect, I guess.

It's the remote side that may be the problem.  In general, there's no
guarantee that the remote side has exited timewait, which is what you
really need to know, or is even aware that the previous connection is no
longer in use.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
