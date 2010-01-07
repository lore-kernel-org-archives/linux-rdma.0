From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv7 4/9] ib_core: RoCEE CMA device binding
Date: Thu, 7 Jan 2010 17:19:12 +0200
Message-ID: <20100107151912.GB2892@mtls03>
References: <20100105103257.GF31480@mtls03>
 <4B45E977.70805@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B45E977.70805-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 07, 2010 at 04:02:31PM +0200, Or Gerlitz wrote:
> > +	route->path_rec->hop_limit = 2;
> 

The reason is that ib_init_ah_from_path() will not set IB_AH_GRH for
hop_limit smaller then 2, and since that GRH is required in RoCEE, and
since this is specific to RoCEE, I put 2 to make pass this.

> why? does this value has any specific meaning?
> 
> > +	route->path_rec->mtu_selector = 2;
> 
> all the xxx_selector usages in this code should be 
> transformed to be from the ib_sa.h selector enum.
No specific meaning. It is not interpreted since we don't use SM. I
will change that to IB_SA_EQ.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
