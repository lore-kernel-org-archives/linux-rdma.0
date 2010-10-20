From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 2.6.37] RDMA/cxgb3: When a user QP is marked in error,
 also mark the CQs in error.
Date: Wed, 20 Oct 2010 17:36:54 -0500
Message-ID: <4CBF6F06.7030703@opengridcomputing.com>
References: <20101020214432.4869.50981.stgit@build.ogc.int> <adapqv47co9.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adapqv47co9.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/20/2010 04:54 PM, Roland Dreier wrote:
>   >  - bump the ABI since the create_cq uverbs response changes.
>
>   >  - detect older libraries and reduce the mmap size accordingly.
>
> If you bump the ABI, will older libraries still run with the new driver?
> Or will they just bail out with "unsupported ABI version"?
>
>    

Well, the existing lib versions don't look at the ABI at all. :)  So 
we're ok.   And I put logic in the driver to detect the old libs vs ABI 
1 libs.

> If you can work with both old and new userspace libraries, is there any
> reason for an ABI break anyway?
>    

The ABI version bump tells the new library that the kernel driver 
supports this new functionality.  I don't know another way to do this 
without the ABI bump.  The kernel driver detects the library ABI via the 
size of the create_cq response that's passed in from the lib.  But in 
the other direction, I think the only was is with the ABI number.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
