From: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH/RFC] RDMA/nes: Rewrite expression to avoid undefined
 semantics
Date: Wed, 14 Jul 2010 13:51:34 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E90492A204C3@azsmsx506.amr.corp.intel.com>
References: <ada630hx0ut.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada630hx0ut.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> -----Original Message-----
> From: Roland Dreier [mailto:rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org]
> Sent: Wednesday, July 14, 2010 3:31 PM
> To: Latif, Faisal; Tung, Chien Tin; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH/RFC] RDMA/nes: Rewrite expression to avoid undefined
> semantics
> 
> Change code like
> 
> 	x = expr(++x)
> 
> that assigns to x twice without a sequence point in between to the
> intended (and well-defined)
> 
> 	x = expr(x + 1)
> 
> Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> ---
> I'll queue this for 2.6.36 unless someone objects.


This is fine.

Thanks
Faisal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
