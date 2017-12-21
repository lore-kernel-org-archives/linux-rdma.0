From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Remove comp_mask checks from verbs.h
Date: Thu, 21 Dec 2017 09:24:42 -0700
Message-ID: <20171221162442.GC20015@ziepe.ca>
References: <20171220231350.GA19130@ziepe.ca>
 <20171221054216.GF2942@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171221054216.GF2942-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 21, 2017 at 07:42:16AM +0200, Leon Romanovsky wrote:

> Both these functions are performing their checks of cq_attr->comp_mask,
> but return different errno. I think that it is perfect timing to start
> organize and unite our return errors. They should return the same errno.

Bugs bugs everywhere.. This is going to be another patch. I would drop
the errno set into check_comp_mask and change all comp_mask users to
call it, and probably drop the _RESERVED uglyness too, but another
patch.

> > In the case of ibv_queryrt_values_ex, there is no check in the function
> > op, which is an ABI mistake. So move the check there.
> 
> ibv_queryrt_values_ex -> ibv_query_rt_values_ex

K.. Are you going to collect the loose patches on the list? Can you
fix the typo when you grab this one :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
