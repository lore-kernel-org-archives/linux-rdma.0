From: Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Add huge page support to ibv_madvise_range()
Date: Thu, 13 May 2010 17:04:11 +0300
Message-ID: <4BEC06DB.30505@gmail.com>
References: <4B12AA78.7090401@gmail.com>	<ada8wbzi490.fsf@roland-alpha.cisco.com> <4BCFFC48.4060401@gmail.com> <adazl0c92kp.fsf@roland-alpha.cisco.com>
Reply-To: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adazl0c92kp.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org, roland <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier Wrote:
>  > In order to avoid adding additional dependency to libibverbs, maybe
>  > we should just to enhance the get_huge_page_size() so it will support
>  > multiple huge page sizes?
> 
> I think that does make sense.  However see my reply to Alexander
> Schmidt -- maybe there is something clever we can do with /proc/*/maps
> to figure out when we need to use this?
> 
>  - R.

Maybe we should use the /proc/pid/pagemap and /proc/kpageflags files? These files let a userspace process find out which physical frame each virtual page is mapped to and to get the properties of each page frame including the page size.
The disadvantage of this method is, that it applicable on kernel >= 2.6.25, since this interface is supported starting from the kernel 2.6.25.

-Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
