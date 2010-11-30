From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] replace (long*)(long) casting with transportable data
 type (uintptr_t)
Date: Tue, 30 Nov 2010 11:08:24 -0800
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1925B9B714E4@orsmsx501.amr.corp.intel.com>
References: <7C00F472050C412BABCB4F2A59CFBD63@amr.corp.intel.com>
 <20101130175555.GX11898@me>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B89244EC@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B89244EC-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean wrote:
>> Wouldn't it be better to remove those additional castings at all?
>> Like below?
>>
> ..
>>      p_query_req_copy = (osmv_query_req_t *)
>> p_req_madw->context.ni_context.node_guid;
>
> I think the Windows compiler will complain about data loss on a
> 32-bit system.

Only the case @ line 433 compiler wise, requires the (uintptr_t) to eliminate the x86 compiler warning: conversion from ptr to ib_net64_t is sign-extended which may result in unexpected runtime behaviors.
Otherwise, x64 & x86 compilers digest the single cast approach.
The real question becomes, are the runtime truncations observed by Mellanox still present with the single cast?

> @@ -433,7 +433,7 @@ __osmv_send_sa_req(IN osmv_sa_bind_info_t * p_bind,
>       }
>       *p_query_req_copy = *p_query_req;
>       p_madw->context.ni_context.node_guid =
> -         (ib_net64_t) (long)p_query_req_copy;
> +         (ib_net64_t) (uintptr_t)p_query_req_copy;

        p_madw->context.ni_context.node_guid = (ib_net64_t) p_query_req_copy;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
