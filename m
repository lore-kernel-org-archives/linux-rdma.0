From: Sugesh Chandran <sugesh.chandran-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Query on 'IB_WR_LSO' mode usage for UD mode transport
Date: Wed, 3 Sep 2014 20:41:50 +0200
Message-ID: <CANGzqPwG=rT9f2U-Dca1OCMMrg3yDdyMBdcoFNE=E3xM5zswqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi All,

I really appreciate this forum for the great support and help to
improve my knowledge.
Now my requirement is to transfer large chunks of data(obviously > 4K
and need not be network packets) using UD mode in kernel. I managed
develop a kernel module prototype using LSO opcode , however it
suffers much of data corruption and loss.
The prototype works as below.
The sender module devide a 64K data into 16 , 4K chunks and maps to
single sg-list. Every "post_send" request have one such sglist. Every
sg_entry in the list holds 4k data, and list can have 16 such entries.
My work request queue size is also 16, so that it post total 16
messages(16 * 64k) in a series.

>From the completion events its clear that the data getting transmitter
to receiver side, But its not the same/partial than the sender sends,
So my questions are
1) UD mode transport adds a 40 byte GRH header to every data packet.
What happen in case of LSO mode? In case of above example, will it
append for every sg entry(every 4K)? for its just one header for whole
sglist?

2)LSO mode insist to add a header (wr.ud.header) for every post_send?
Whats the relevance of this header? Is it possible to provide custom
headers than TCP+IP ?  At receiver side every 4k has this header too?

3)I registered the same memory(64K --> 4K * 16) at receiver side too.
Will HCA fill the entire 64K(the whole sg_list) before trigger the
"IB_WC_RECV" ? Or is it for every 4K chunk?  what if one packet loss
in the list?

4) If the receiver is also doing offloading, will it take care of
ordering of packets too. (I mean 1st sglist entry from sender should
be copied to 1 in receiver, and so on?)


I am using Mellanox ConnectX cards in both hosts which are connected
directly each other.

Can anyone please help me to understand this. I have done some
codewalkthrough in IPoIB code , but couldn't find anything for this
use case.

Thanks in advance

-- 
Regards
_Sugesh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
