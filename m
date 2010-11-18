From: Ido Shamai <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: building RDMA perftests with g++
Date: Thu, 18 Nov 2010 12:31:59 +0200
Message-ID: <4CE5009F.90001@dev.mellanox.co.il>
References: <20101117202015.rs5zkzhbkskwsw4s@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101117202015.rs5zkzhbkskwsw4s-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ib-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Ed ,

I'm Ido , perftest maintainer , I will check the issue now , and report you back.

In general , every c program can be compiled with g++ ?

Ido

On 11/18/2010 5:20 AM, ib-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org wrote:
> I have what is probably a silly question....
>
> If I compile the rdma_bw example from perftests with g++, it doesn't work... granted I have to make a few changes wrt structure initialization, but I would think it should behave as when built with gcc...  I am getting an error message in pp_client_init/pp_server_init that ai_family SOCK_STREAM is not support for the port.  If I use cma I get an unrecognized event on the client side... Am I missing something?  I am trying to develop some C++ classes with RDMA/verbs.
> Thanks,
> Ed
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
