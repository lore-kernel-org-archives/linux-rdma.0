From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 5/37] librdmacm: replace query_route call with separate
 queries
Date: Mon, 10 May 2010 16:07:42 -0500
Message-ID: <4BE8759E.2040500@opengridcomputing.com>
References: <D81E70C032A3452B9FD00D7EB445F6CF@amr.corp.intel.com> <4BE84B7D.40703@opengridcomputing.com> <053733AA9B7B4EBFB94A54DEF34DC73A@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <053733AA9B7B4EBFB94A54DEF34DC73A-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
>> You define global int af_ib_support.  It never gets set to non-zero.
>> Was this debug code or does it get set somewhere else that I'm missing?
>>     
>
> It doesn't get set until a later patch in the series, once all the needed
> infrastructure is in place.
>
>   

Ok I see it.  It allows you to only enable this if the kernel CMA 
modules support it.

I reviewed the whole series, but only at a high level.  There are LOTS 
of changes.  :)

The query gid stuff looks ok to me though. 

If you update the series with the iwarp gid changes, I'll review that too.

Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
