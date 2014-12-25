From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: RDMA atomic operations fail
Date: Thu, 25 Dec 2014 10:42:19 +0200
Message-ID: <549BCDEB.9060402@dev.mellanox.co.il>
References: <loom.20141224T040342-951@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20141224T040342-951-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: floaterions <floaterions-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/24/2014 5:08 AM, floaterions wrote:
> When I try to submit an RDMA FETCH_AND_ADD or CMP_AND_SWAP ,
> the ibv_post_send() function fails, with Errno set to "Invalid argument".
> I have no such problems with RDMA READ/WRITE.
>
> I developed my entire code using RDMA CM (so no manual QP transitioning).
> The queue pair is RC, and Atomic is enabled at the responder queue pair,
> and the memory regions are registered with atomic access.
>
> I suspected that there might be the source of this problem,
> so I wrote a small program using libibcm where I transition the QPs manually
> and set the flags fro atomic operations:
> qp_attr->qp_access_flags = IBV_ACCESS_REMOTE_ATOMIC;
> qp_attr->max_rd_atomic = <something greater than zero>;
> qp_attr->max_dest_rd_atomic = <something greater than zero>;
>
> But still, the same error (invalid argument).
>
> I'd appreciate your help.

Which device are you using?

It would help if you add the send wr setting code...

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
