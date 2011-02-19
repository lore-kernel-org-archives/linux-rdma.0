From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC 0/8] Reliably generate large request from SRP
Date: Fri, 18 Feb 2011 19:07:17 -0500
Message-ID: <1298074037.15679.17.camel@lap75545.ornl.gov>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
 <aday66hxxwe.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <aday66hxxwe.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

[ sorry for the dupe, mis-edited Roland's address ]

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

I'm looking at this now, and it may not be too bad; I think I can re-use
the mapping machinery pretty easily without it getting too ugly.

I do have a few questions, though. It looks like I can only have up to
256 keys for each fast page registration MR, so that seems to limit the
mappings in flight -- I can see cases where we may run out and have to
push the request back to the mid-layer. We'd also be cycling through the
key space pretty quickly, negating some of the advantages of being able
to invalidate the mappings quickly.

I'm thinking about just allocating an MR per request -- this seems like
a simple way to avoid the restrictions, but would of course use more
MRs. mlx4 seems to allow just shy of 512 K of them, so that's probably
not a large concern.

What do you think? Is that overkill? Do I misunderstand the BMM
extensions?
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
