From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] libibverbs: Add support for XRC QPs
Date: Thu, 16 Jun 2011 16:03:52 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373021813@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237302124E@ORSMSX101.amr.corp.intel.com>
 <4DFA1BB8.9000305@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DFA1BB8.9000305-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >  enum ibv_qp_type {
> >  	IBV_QPT_RC = 2,
> >  	IBV_QPT_UC,
> > -	IBV_QPT_UD
> > +	IBV_QPT_UD,
> > +	IBV_QPT_XRC_SEND,
> > +	IBV_QPT_XRC_RECV
> >  };
> 
> Sean,
> 
> The upstream kernel (below) uses already the values 5 and 6 for
> the IB RAW qp types
> 
> > enum ib_qp_type {
> >         IB_QPT_SMI,
> >         IB_QPT_GSI,
> >         IB_QPT_RC,
> >         IB_QPT_UC,
> >         IB_QPT_UD,
> >         IB_QPT_RAW_IPV6,
> >         IB_QPT_RAW_ETHERTYPE
> > };
> 
> 
> ofed (below) uses 5 for XRC, 6/7 for IB raw qp types
> and 8 for the new "eth packet qp", XRC and the packet QP
> are used from user space with code which is out...
> so if possible can we at least keep the packet qp type value
> unchanged, as for XRC its different API...
> 
> > enum ib_qp_type {
> >         IB_QPT_SMI,
> >         IB_QPT_GSI,
> >         IB_QPT_RC,
> >         IB_QPT_UC,
> >         IB_QPT_UD,
> >         IB_QPT_XRC,
> >         IB_QPT_RAW_IPV6,
> >         IB_QPT_RAW_ETHERTYPE,
> >         IB_QPT_RAW_PACKET

I don't know if user space can allocate raw qps, but to be safe, I'll add XRC INI and TGT QP types after IB_QPT_RAW_ETHERTYPE (values 7 and 8) and adjust ibverbs to make the mapping simple.  What I was trying to suggest in my other email is for OFA to do something like this going forward:

enum ib_qp_type {
	upstream values... ,
	IB_QPT_OFA_SPECIFIC = 2 << 24,
	IB_QPT_OFA_XRC,
	IB_QPT_OFA_RAW_PACKET
};

So, we don't end up with conflicting types, and OFA can treat OFA_XRC differently if the accepted XRC patches end up being different.  (Of course, it's too late to fix OFA XRC this way, but maybe it's possible for OFA to support existing apps with only a recompile?)

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
