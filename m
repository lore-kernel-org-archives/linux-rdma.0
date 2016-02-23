From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RESEND] infiniband:core:Fix error handling in the function
 cm_lap_handler
Date: Tue, 23 Feb 2016 10:54:23 +0200
Message-ID: <56CC1E3F.9070500@mellanox.com>
References: <1456167558-10123-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456167558-10123-1-git-send-email-xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/22/2016 8:59 PM, Nicholas Krause wrote:
> This fixes error handling in the function cm_lap_handler to properly
> check if the internal call to the function cm_init_av_for_response
> has failed by returning a error code and if so exit immediately from
> this particular function by freeing all previously allocated
> resources before returning the error code to this function's caller
> in order to allow the caller to handle the error properly in it's
>
> Signed-off-by: Nicholas Krause<xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

I think this is the longest sentence I have ever read in English, and it 
even doesn't have a end... please break it and tell us the (hopefully) 
happy end.

Use IB/core: prefix and point to the commit you are fixing

Fixes: xxx ('yyy')

where xxx is the 12 digit abbrev-iated git short log  and yyy the commit 
title

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
