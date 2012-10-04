From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 1/7] libibverbs: Infrastructure to support verbs extensions
Date: Thu, 4 Oct 2012 07:55:17 +0200
Message-ID: <506D24C5.40405@mellanox.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A981A0@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A981A0-Q3cL8pyY+6ukrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 29/09/2012 00:53, Hefty, Sean wrote:
> [...] Infrastructure to support extended verbs capabilities in a forward/backward
> manner. [...]

Sean,

Just two nits re the patch set...

1. it would be easier to eventually pick these patches if the library 
name would be part of the text in brackets, e.g could you use libibverbs 
and libmlx4 with git format-patch --subject-prefix="PATCH LIBNAME" e.g 
--subject-prefix="PATCH libibverbs"

2. patch 0 (cover-letter) for both sub-series (libmlx4/libibverbs) 
stating the changes along the series versions will help to follow on the 
progress

thanks,

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
