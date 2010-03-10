From: Fredrik Unger <funger-e+cCxrzAqRFWk0Htik3J/w@public.gmane.org>
Subject: kitten - mlx4: Unhandled interrupt - owner bit
Date: Wed, 10 Mar 2010 16:03:26 +0100
Message-ID: <4B97B4BE.1050809@hpce.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I am new to this list, and if my question is misplaced
please suggest a better forum on or off-list.

We are using InfiniBand (core & mlx4 of OFED 1.4.1 + OFED kernel patches)
in a light weight kernel named kitten, partially derived from linux.
http://code.google.com/p/kitten/

We see problems of one or two unhandled interrupts when doing RDMA_READ
data transfers with mlx4 cards.  (SEND and RDMA_WRITE works well)
It appears only with larger messages 1-4 Mb.
write-combining is turned off.

Below a pingpong test - 1000 iterations per messages size:
ex.
<8>(init_task)       Size     Average      Stddev         Min      Median         Max
...
<8>(init_task)     524288      271.79        7.09      138.96      271.51      429.24
<4>irq_dispatch: Unhandled interrupt 74 (4a) [Owner]
<8>(init_task)    1048576      569.99      981.73      272.01      537.56    31581.67
<8>(init_task)    2097152     1070.57       28.95      537.88     1069.66     1779.97
<8>(init_task)    4194304     2135.99       52.86     1070.10     2134.70     3124.28

This error is random and appears in about one of three runs. Note the high max
value for one 1Mb message, as I guess the connection recovers.

When investigating the error it seems to stem from next_eqe_sw in drivers/net/mlx4/eq.c
called by the interrupt handler.
What happens is that (eqe->owner & 0x80) is true causing the routine to return
NULL resulting in an unhandled interrupt (eg the interrupt routine returns 0)

My understanding is that when the interrupt gets flagged the card would
have given the eqe (event queue entry?) to the software, but it could very well be more complex.

The same message can be seen when starting the driver, but it does not cause any problems :
<6>mlx4_ib: Mellanox ConnectX InfiniBand driver v1.0 (April 4, 2008)
<4>irq_dispatch: Unhandled interrupt 74 (4a) [Owner]
 .... x 16

This problem could not be reproduced under linux so far.
The kitten interrupt handler is simple and just forwards the interrupt to the driver.

What does owner in the eqe struct mean ? Hardware or Software owns the entry ?
Has this bug been seen in Linux, even if we were not able to reproduce it ?
Can I get more debug information from the card ?
Any tips to what could go wrong in this context ? Are we missing some setup ?


Sincerely,

Fredrik Unger
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
