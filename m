From: ib-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org
Subject: building RDMA perftests with g++
Date: Wed, 17 Nov 2010 20:20:15 -0700
Message-ID: <20101117202015.rs5zkzhbkskwsw4s@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I have what is probably a silly question....

If I compile the rdma_bw example from perftests with g++, it doesn't  
work... granted I have to make a few changes wrt structure  
initialization, but I would think it should behave as when built with  
gcc...  I am getting an error message in pp_client_init/pp_server_init  
that ai_family SOCK_STREAM is not support for the port.  If I use cma  
I get an unrecognized event on the client side... Am I missing  
something?  I am trying to develop some C++ classes with RDMA/verbs.
Thanks,
Ed


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
