From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: RDMA atomic operations fail
Date: Sun, 28 Dec 2014 12:13:35 +0200
Message-ID: <20141228101335.GC1806@mtldesk30>
References: <loom.20141224T040342-951@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <loom.20141224T040342-951-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: floaterions <floaterions-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 24, 2014 at 03:08:45AM +0000, floaterions wrote:
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

Hi,
the current code in upstream does not support atomic operations.
Patches were sent already that will allow to use atomic operations
over mlx5 supported devices.

For now, if you query the HCA capabilites you should get ATOMIC_NONE
at the atomic_cap field when you query the device capabilites.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
