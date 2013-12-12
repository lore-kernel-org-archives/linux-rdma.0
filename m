From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: IB/usnic: Add Cisco VIC low-level hardware driver
Date: Thu, 12 Dec 2013 12:29:27 +0300
Message-ID: <20131212092927.GU5443@mwanda>
References: <20131211224019.GC3955@elgon.mountain>
 <7E785E0E-85C8-498D-9269-46C95110BF53@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7E785E0E-85C8-498D-9269-46C95110BF53-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 12, 2013 at 03:03:15AM +0000, Upinder Malhi (umalhi) wrote:
> Why not?  
> 
> We can switch to WARN_ON.  The kernel provides this macro -
> assert_spin_locked - which does asserts via BUG_ON that
> spin_is_locked, which makes me think that using BUG_ON in conjunction
> with spin_is_locked is legal.  We should use this macro instead of
> manually asserting, unless that it is not legal, in which case WARN_ON
> will do.

It's better to not halt the kernel.  That way you can do some debugging.

But the main thing is the scheduling with a spin lock held.  The other
I don't care about.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
