From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH/libmlx] Set the ibv_wc.opcode even if the wc is an error
 wc
Date: Wed, 9 Mar 2011 09:37:26 +0200
Message-ID: <4D772E36.90103@mellanox.com>
References: <20110309042613.GA21606@obsidianresearch.com> <4D771E0F.7040402@mellanox.com> <20110309070441.GA25213@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110309070441.GA25213-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> Did you mean wr_id not opcode?

yes, sure, I was referring to the wr_id (cookie) and status.

> I'd say that 11.4.2.1 supports the view that wr_id and status are the
> only valid fields. However, the whole error handling architecture that
> the WC's fit into is based around the idea that you can go from an
> error WC back to the RQ/SQ that caused the error, correct the
> situation and resume operation. That requires the opcode indicate at
> least SEND vs RECV, and that qp_num be valid

Indeed, the qp number is required for supporting SRQ, since in that 
case, many sessions (QPs) share the same RQ buffer pool. As for the 
opcode, I understand what you're saying, but, still - given the cookie 
and the qp number the application can realize whether is was send or 
receive that failed, and with recording of the actual send opcode 
(send/rdma-read/write/etc) in the buffer pointed by the cookie further 
debug this. Ofcourse your approach would make debugging easier. The 
question is how to educate people that write to IB, should we tell them 
now they can look on the opcode? so far I was telling people never do so 
if the status isn't success.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
