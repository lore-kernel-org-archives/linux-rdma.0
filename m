From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] replace (long*)(long) casting with transportable data
 type (uintptr_t)
Date: Tue, 30 Nov 2010 20:57:54 +0200
Message-ID: <20101130185754.GY11898@me>
References: <7C00F472050C412BABCB4F2A59CFBD63@amr.corp.intel.com>
 <20101130175555.GX11898@me>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B89244EC@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B89244EC-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10:22 Tue 30 Nov     , Hefty, Sean wrote:
> > Wouldn't it be better to remove those additional castings at all?
> > Like below?
> > 
> ..
> > 	p_query_req_copy = (osmv_query_req_t *) p_req_madw->context.ni_context.node_guid;
> 
> I think the Windows compiler will complain about data loss on a 32-bit system.

p_req_madw->context.ni_context.node_guid has 64 bits type.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
