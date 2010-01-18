From: Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Add huge page support to ibv_madvise_range()
Date: Mon, 18 Jan 2010 14:53:55 +0200
Message-ID: <4B5459E3.2040902@gmail.com>
References: <4B12AA78.7090401@gmail.com>	<ada8wbzi490.fsf@roland-alpha.cisco.com> <4B52D8A8.7060804@gmail.com> <adak4vghcoo.fsf@roland-alpha.cisco.com>
Reply-To: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adak4vghcoo.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org, roland <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Changing which API?  

Verbs API.
Since there is no way to figure out (as we know) from user space 
if a given memory region is backed by a huge page or default one,
we can allow the user to supply us this info on memory registration.
For that we need to add version of ibv_reg_mr() with additional 
input parameter for page size (the same for ibv_dontfork_range()
and ibv_dofork_range()).

> Changing the kernel is a possibility of course.

In my opinion if we have the user space solution it is preferable
than changing the kernel, which is more complex path.

Alex.

Roland Dreier Wrote:
>  > But we couldn't find another one without changing the API or changing
>  > the kernel.
> 
> Changing which API?  Changing the kernel is a possibility of course.
> 
>  - R.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
