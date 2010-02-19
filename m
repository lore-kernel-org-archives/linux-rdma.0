From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] rdma/nes: set assume_alligned_header bit
Date: Fri, 19 Feb 2010 13:18:13 -0800
Message-ID: <ada3a0w7wmi.fsf@roland-alpha.cisco.com>
References: <20100219210635.GA59096@flatif-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100219210635.GA59096@flatif-MOBL> (Faisal Latif's message of
	"Fri, 19 Feb 2010 15:06:35 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 >  			nesqp->nesqp_context->ird_ord_sizes = cpu_to_le32(NES_QPCONTEXT_ORDIRD_ALSMM |
 >  					((((u32)nesadapter->max_irrq_wr) <<
 >  					NES_QPCONTEXT_ORDIRD_IRDSIZE_SHIFT) & NES_QPCONTEXT_ORDIRD_IRDSIZE_MASK));
 > +			nesqp->nesqp_context->ird_ord_sizes |= cpu_to_le32(NES_QPCONTEXT_ORDIRD_AAH);

I think I would just combine this into the existing assignment (which
could also probably be formatted better but I'm not worrying about
this), and write the whole thing as:

 			nesqp->nesqp_context->ird_ord_sizes = cpu_to_le32(NES_QPCONTEXT_ORDIRD_ALSMM |
					NES_QPCONTEXT_ORDIRD_AAH |
 					((((u32)nesadapter->max_irrq_wr) <<
 					NES_QPCONTEXT_ORDIRD_IRDSIZE_SHIFT) & NES_QPCONTEXT_ORDIRD_IRDSIZE_MASK));

-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
