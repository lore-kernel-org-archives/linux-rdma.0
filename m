From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC 0/8] Reliably generate large request from SRP
Date: Wed, 19 Jan 2011 07:01:17 -0500
Message-ID: <1295438477.5233.39.camel@obelisk.thedillows.org>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
	 <aday66hxxwe.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <aday66hxxwe.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2011-01-18 at 21:31 -0800, Roland Dreier wrote:
> Hi Dave,
> 
>  > Now that at least one vendor is implementing full support for the SRP
>  > indirect memory descriptor tables, we can safely expand the sg_tablesize,
>  > and realize some performance gains, in many cases quite large. I don't
>  > have vendor code that implements the full support needed for safety, but
>  > the rareness of FMR mapping failures allows the mapping code to function,
>  > at a risk, with existing targets.
> 
> Have you considered using memory registration through a send queue (from
> the base memory management extensions)?  mlx4 at least has support for
> this operation, which would let you pre-allocate everything and avoid
> the possibility of failure (I think).

I'd rather keep it to one code path if possible, rather than mix FMRs
and BMM. I also need this to work on mthca cards, though I haven't
checked if they support it.

Still, I'll check into it; avoiding the need for vendor support would be
nice.

> When do we get FMR mapping failures now?

I don't know that we ever do, but reading through the code in fmr_pool.c
and the HW implementations, there is no telling what goes on in ehca
since it is hidden in the hypervisor, or so it appeared to me last I
looked. There seemed to be error cases elsewhere, but they should also
be quite rare.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
