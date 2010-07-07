From: Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] change thread-unsafe readdir to thread-safe readdir_r
 calls
Date: Wed, 07 Jul 2010 12:17:16 -0700
Message-ID: <4C34D2BC.60101@redhat.com>
References: <1278527821-14804-1-git-send-email-sdake@redhat.com> <adatyobyvg7.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adatyobyvg7.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Dake <sdake-AqqL/iNfm4CbU/LNMs03Rw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/07/2010 11:54 AM, Roland Dreier wrote:
>   >  The readdir POSIX api is not thread safe.  This presents problems in
>   >  multithreaded programs that use the libibverbs APIs.  This patch has been
>   >  tested with a libibverbs application (http://www.corosync.org) on
>   >  Mellanox MT26428 cards.
>
> This is a bit vague.  Is the problem that other threads may do readdir()
> while libibverbs initializes?
>
>   >   #include "ibverbs.h"
>   >
>   >  +
>   >   HIDDEN int abi_ver;
>
> whitespace damage here.
>

thanks I'll fix

>   >  +	buf = (struct dirent *)malloc(offsetof(struct dirent, d_name) + NAME_MAX + 1);
>
> cast of void* is not needed.  Also it seems this could be alloca() and
> simplify things (avoid error checking and freeing).
>

yes..  I can change if you like.  Never been fond of alloca because of 
its limitation on error checking with stack overflow which is unlikely 
in this call path.

Regards
-steve

> Thanks,
>    Roland
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
