From: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rdma/nes: set assume_alligned_header bit
Date: Fri, 19 Feb 2010 14:23:39 -0700
Message-ID: <B6AF6A496EB3F84096209458E19C94EE7941D19E@azsmsx501.amr.corp.intel.com>
References: <20100219210635.GA59096@flatif-MOBL>
 <ada3a0w7wmi.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada3a0w7wmi.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

That will be fine.

Thanks
Faisal


>-----Original Message-----
>From: Roland Dreier [mailto:rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org]
>Sent: Friday, February 19, 2010 3:18 PM
>To: Latif, Faisal
>Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: Re: [PATCH] rdma/nes: set assume_alligned_header bit
>
> >  			nesqp->nesqp_context->ird_ord_sizes =
>cpu_to_le32(NES_QPCONTEXT_ORDIRD_ALSMM |
> >  					((((u32)nesadapter->max_irrq_wr) <<
> >  					NES_QPCONTEXT_ORDIRD_IRDSIZE_SHIFT) &
>NES_QPCONTEXT_ORDIRD_IRDSIZE_MASK));
> > +			nesqp->nesqp_context->ird_ord_sizes |=
>cpu_to_le32(NES_QPCONTEXT_ORDIRD_AAH);
>
>I think I would just combine this into the existing assignment (which
>could also probably be formatted better but I'm not worrying about
>this), and write the whole thing as:
>
> 			nesqp->nesqp_context->ird_ord_sizes =
>cpu_to_le32(NES_QPCONTEXT_ORDIRD_ALSMM |
>					NES_QPCONTEXT_ORDIRD_AAH |
> 					((((u32)nesadapter->max_irrq_wr) <<
> 					NES_QPCONTEXT_ORDIRD_IRDSIZE_SHIFT) &
>NES_QPCONTEXT_ORDIRD_IRDSIZE_MASK));
>
>--
>Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
>For corporate legal information go to:
>http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
