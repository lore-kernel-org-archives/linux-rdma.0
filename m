From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/5] IB/core: Convert management helpers to core capability bits
Date: Tue, 12 May 2015 17:54:57 -0400
Message-ID: <20150512215456.GA13105@phlsvsds.ph.intel.com>
References: <1431395218-27693-1-git-send-email-ira.weiny@intel.com> <1431395218-27693-4-git-send-email-ira.weiny@intel.com> <1828884A29C6694DAF28B7E6B8A82373A8FCE4DE@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FCE4DE-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > +
> > +/* Protocol                             0xFFF00000 */
> > +#define RDMA_CORE_CAP_PROT_IB           0x00100000
> > +#define RDMA_CORE_CAP_PROT_IBOE         0x00200000
> 
> Use ROCE in place of IBOE for consistency with the definition below.

Done.

> 
> > +#define RDMA_CORE_CAP_PROT_IWARP        0x00400000
> > +
> > +#define RDMA_CORE_PORT_IBA_IB          (RDMA_CORE_CAP_PROT_IB  \
> > +					| RDMA_CORE_CAP_IB_MAD \
> > +					| RDMA_CORE_CAP_IB_SMI \
> > +					| RDMA_CORE_CAP_IB_CM  \
> > +					| RDMA_CORE_CAP_IB_SA  \
> > +					| RDMA_CORE_CAP_AF_IB)
> > +#define RDMA_CORE_PORT_IBA_ROCEE       (RDMA_CORE_CAP_PROT_IBOE \
> 
> Rename ROCEE to ROCE.

Done.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
