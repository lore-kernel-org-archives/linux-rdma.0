From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv8 04/11] ib_core: IBoE CMA device binding
Date: Thu, 13 May 2010 10:24:20 +0300
Message-ID: <20100513072420.GB16073@mtldesk030.lab.mtl.com>
References: <20100218172403.GE12286@mtls03>
	<ada1vdgvqe9.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ada1vdgvqe9.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 12, 2010 at 01:03:42PM -0700, Roland Dreier wrote:
>  >  int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
>  > -			 struct ib_sa_path_rec *rec, struct ib_ah_attr *ah_attr)
>  > +			 struct ib_sa_path_rec *rec, struct ib_ah_attr *ah_attr,
>  > +			 int force_grh)
> 
> Rather than this change in API, could we just have this function look at
> the link layer, and if it's ethernet, then always set the GRH flag?
> Seems simpler than requiring the upper layers to do this and then pass
> the result in?

I guess that would keep the function more versatile but changing the
implenetation to check the port's link layer seems OK to me.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
