From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V4 libibverbs 2/7] Add member functions to poll an
 extended CQ
Date: Sun, 29 May 2016 19:35:07 -0600
Message-ID: <20160530013507.GA19230@obsidianresearch.com>
References: <1464533475-18949-1-git-send-email-yishaih@mellanox.com>
 <1464533475-18949-3-git-send-email-yishaih@mellanox.com>
 <574B6F71.9060808@redhat.com>
 <20160529233009.GA12420@obsidianresearch.com>
 <8F7BC9E2-75EC-413B-BEBE-11450225AF06@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8F7BC9E2-75EC-413B-BEBE-11450225AF06-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, May 29, 2016 at 07:47:54PM -0400, Doug Ledford wrote:
> > You should really read the whole prior discussion
> 
> If there's something in particular you'd like to point out, feel free. 

You can't ignore the mailing list and expect the rest of us to carry
you along when you finally wake up..

> It doesn't have to be refs. If I recall correctly, the libmlx4
> driver has to clear each cqe by changing the ownership status back
> to the hardware or something like that. The release could just as
> easily be setting that ownership on the cqe.

It also has to notify the hardware of the new ring head pointer which
becomes more expensive with refs, especially on a lockable CQ.

> The original bitmask version included a copy to an interim, variable
> struct.  The idea here is that the cqe is an opaque pointer directly
> to the hardware cqe. There would be no interim copies, just
> retrieving the desired data directly from the cqe. Maybe I should
> have called it a hcqe to be more clear.

Unless I'm mistaken, something much more more complex than just a
simple offsets is required to handle the usual hcqe format used by our
various drivers.

I agree if you could describe the typical hcqe extractor in a format
like offsets/mask/shift for all supported drivers then that might be
better (unclear if an unaligned load/mask/shift is more expensive than
a branch).  I believe I already explained that possibility earlier in
the thread, and went further to suggest doing a direct HW optimized
DIRECT option like libfabric has.

However, getting this wrong limits the future hardware we can support,
which is scary, and the branch option clearly doesn't have that
problem.

So the performance win would have to be substantial, IMHO.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
