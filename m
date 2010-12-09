From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] replace (long*)(long) casting with transportable data
 type (uintptr_t)
Date: Thu, 9 Dec 2010 18:04:12 +0200
Message-ID: <20101209160412.GD11898@me>
References: <3D555CA8351C471B84CD9D6432AFC6D0@amr.corp.intel.com>
 <4CFE8A53.6030906@dev.mellanox.co.il>
 <3F6F638B8D880340AB536D29CD4C1E1925B9CBC236@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E1925B9CBC236-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Sasha Khapyorsky' <sashakvolt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 15:18 Tue 07 Dec     , Smith, Stan wrote:
> 
> We should return to my original patch submission.
> remove the (long*) (long) and replace with (uintptr_t)
> 
> >> -        (osmv_query_req_t *) (long *)(long)(p_madw->context.ni_context.
> >> -                                            node_guid);
> >> +        (osmv_query_req_t *) (uintptr_t) p_madw->context.ni_context.node_guid;
> 
> Sasha, can you take care of this?

Done. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
