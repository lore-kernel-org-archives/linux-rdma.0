From: Werther Pirani <wpirani-hv++7WL8WN4@public.gmane.org>
Subject: Re: Documentation for libiverbs?
Date: Thu, 14 Jan 2010 09:59:24 +0000
Message-ID: <4B4EEAFC.5040409@eso.org>
References: <S1752421Ab0AMJqp/20100113094645Z+1609@vger.kernel.org> <4B4D9B1E.1020604@eso.org> <4B4DB219.2020406@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B4DB219.2020406-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Tziporet Koren wrote:

 > You can look at the ping-pong examples that come with libibverbs. 
http://www.openfabrics.org/downloads/libibverbs/
 > Also you can look at the performance tests (ib_write_lat, ib_write_bw, etc). 
http://www.openfabrics.org/downloads/perftest/

Thank you for the prompt reply! Not quite what I'm looking for (a proper 
programmer's guide) but better than nothing and probably enough to get started.

However, I have a question: our application needs multicast which, if I understand 
things correctly, means the only option is Unreliable Datagrams.

I'm experimenting with ud_pingpong.c and it works, but as soon as a try to 
exchange messages bigger than 2048 bytes I have the following error:

Failed status local length error (1) for wr_id 2

A table in Mellanox' "RDMA Aware Networks Programming" shows that for UDs the max 
messages size is limited by the MTU. That really being the case, how can I 
check/change the it?


Many thanks in advance,

Werther Pirani
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
