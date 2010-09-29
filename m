From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 09/11 v2] RDMA/cxgb4: Support on-chip SQs.
Date: Wed, 29 Sep 2010 12:14:54 -0500
Message-ID: <4CA3740E.9020104@opengridcomputing.com>
References: <20100913162357.20948.28267.stgit@build.ogc.int>	<adad3rx699s.fsf@cisco.com> <4CA22E84.404@opengridcomputing.com> <adatyl943ob.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adatyl943ob.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09/28/2010 10:41 PM, Roland Dreier wrote:
>   >  We would remove it I guess.   I see that mlx4 assumes
>   >  pgprot_writecombine() exists and works correctly across all platforms.
>   >  See mlx4_ib_mmap().
>
> It might be more accurate to say that mlx4 assumes pgprot_writecombine()
> is defined on all platforms.  Any platform that hasn't defined it (or
> where the concept of write combining doesn't make sense) just falls back
> to defining it as pgprot_noncached().
>
> > From a quick grep it seems that /arch/powerpc has no definition of
> pgprot_writecombine() but your code seems to say that one could be
> given.
>
>    

This came from the ofed version of mlx4.  I assume it works. :)


>   >  If all platforms support pgprot_writecombine() correctly, then we
>   >  don't need ocqp_supported().
>
> As I said, it's a bit tricky.  All platforms get some definition of
> pgprot_writecombine(), but some platforms might define it as just giving
> a non-cached mapping, which might lead to dire performance (perhaps
> worse than just putting the SQ in host memory).  I'm not sure what the
> best way to handle it is -- I suppose if you wanted to get fancy you
> could do a quick benchmark on startup (if such a thing is possible).
>
>    

oof.  I don't want to get that fancy.  :)

Seems like what I need is an arch-specific function that indicates if 
write combining is supported or not.  Or leave the code as-is.

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
