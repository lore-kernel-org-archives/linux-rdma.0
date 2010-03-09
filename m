From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Fw: About FRMR vec and SRQ post recv
Date: Mon, 08 Mar 2010 21:53:53 -0600
Message-ID: <4B95C651.1030001@opengridcomputing.com>
References: <201003072109161566975@inspur.com>, <201003072113223754872@inspur.com>, <201003090948570789220@inspur.com> <201003091142236565650@inspur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201003091142236565650-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lihaidong <lihaidong-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

lihaidong wrote:
> If I use send/recv operations to send the two arbitrary regions form A
> to B.How about the data order?
> I mean
> for side A
> sge[0] = {A_vec1_addr,A_vec1_len, A_lkey}
> sge[1] = {A_vec2_addr,A_vec2_len, A_lkey}
> ib_send_wr.sg_list = sge;
> for side B
> sge[0] = {B_vec1_addr,B_vec1_len, B_lkey}
> sge[1] = {B_vec2_addr,B_vec2_len, B_lkey}
> ib_recv_wr.sg_list = sge;
> Does lower level layers ensure that data in vec1 in A would be placed
> to vec1 in B and vec2(A) to vec2(B)?


Yes. as long as the lengths match. IE on the recv side, the data is
placed into the receive buffer in sge order based on lengths. So if A's
sge[0] was 100 bytes and sge[1] 10 bytes, and B's recv sge[0] was 110
bytes, all the 110 bytes would be placed in B's recv sge[0].



> According to krping and my experience, to use send/recv operations, I
> have to convert host byte order to net byte order when preparing
> send_buf, and convert back to host byte order when recv_buf's data is
> ready.Yet, RDMA Read/Write does not has this overhead,right?


I don't really understand this question: If you're talking about payload
data, then you don't need to do conversions if both hosts are the same
byte order.


Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
