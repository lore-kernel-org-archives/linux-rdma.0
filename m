From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Documentation for libiverbs?
Date: Thu, 14 Jan 2010 09:23:41 -0800
Message-ID: <ada7hrkmwgy.fsf@roland-alpha.cisco.com>
References: <S1752421Ab0AMJqp/20100113094645Z+1609@vger.kernel.org>
	<4B4D9B1E.1020604@eso.org> <4B4DB219.2020406@mellanox.co.il>
	<4B4EEAFC.5040409@eso.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B4EEAFC.5040409-hv++7WL8WN4@public.gmane.org> (Werther Pirani's message of "Thu, 14
	Jan 2010 09:59:24 +0000")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Werther Pirani <wpirani-hv++7WL8WN4@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > I understand things correctly, means the only option is Unreliable
 > Datagrams.

Yes.

 > I'm experimenting with ud_pingpong.c and it works, but as soon as a
 > try to exchange messages bigger than 2048 bytes I have the following
 > error:
 > 
 > Failed status local length error (1) for wr_id 2
 > 
 > A table in Mellanox' "RDMA Aware Networks Programming" shows that for
 > UDs the max messages size is limited by the MTU. That really being the
 > case, how can I check/change the it?

UD messages are limited to a single packet.  The packet MTU is a
hardware/fabric property, and it is quite likely that 2048 is the
maximum for your fabric.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
