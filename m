From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 09/14] IB/mlx5: Add support for resize CQ
Date: Wed, 15 Jan 2014 13:24:16 +0200
Message-ID: <20140115112416.GD31664@mtldesk30>
References: <1389714323-20130-1-git-send-email-eli@mellanox.com>
 <1389714323-20130-10-git-send-email-eli@mellanox.com>
 <1389717410.1585.67.camel@localhost.localdomain>
 <20140115073316.GB31664@mtldesk30>
 <1389780175.572.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1389780175.572.10.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 15, 2014 at 11:02:55AM +0100, Yann Droneaud wrote:
> 
> I'd like to have your opinion on this change.
> 
> I'm going to patch every call to ib_copy_from_udata() to follow my
> proposed scheme (eg. returned error code from ib_copy_from_udata()
> instead of hard coded error value).
>
Yes, makes sense to me.

> 
> Is libmlx5/libibverbs the ABI ?
> 
> Unfortunately, anybody is allowed to access the kernel uverbs API
> directly, so we must take care of the kernel ABI, just in case.
>

I am not sure I understand the question but libibverbs to libmlx5
relation is somehow like the relationship between ib_core and mlx5_ib.
e.g. libibverbs sets the API and libmlx5 implements it.
> 
> For code not yet part of a released kernel version, we can fix that.
> But for all other, it would require proper checking/thinking before
> rejecting reserved field not set to 0 since it might theoterically break
> existing userspace program: it will be a departure from previous ABI.
> 

Yes, this needs to be done carefully for each driver. We need to check
if either libibverbs or any other provider library clears the struct
before sending. If this is the case then it should be safe to fix the
kernel part.

> 
> I would found more readable to have the two locks held next each other.
> YMMV.
> 
I am not following you here. Please be more specific.
> 
> 
> But it's the size of struct mlx5_modify_cq_mbox_in, not the number of
> 'cqe' to resize the cq to.
> 

Oh I see. Well, I don't think it will ever matter that I using int.
I use it in other places too.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
