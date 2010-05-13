From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv8 08/11] mlx4: Allow interfaces to correspond to each
	other
Date: Thu, 13 May 2010 14:13:12 +0300
Message-ID: <20100513111312.GG16073@mtldesk030.lab.mtl.com>
References: <20100218172430.GI12286@mtls03>
	<adafx1wuald.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adafx1wuald.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 12, 2010 at 01:30:22PM -0700, Roland Dreier wrote:
>  > +void *mlx4_get_prot_dev(struct mlx4_dev *dev, enum mlx4_prot proto, int port)
>  > +{
>  > +	return mlx4_find_get_prot_dev(dev, proto, port);
>  > +}
>  > +EXPORT_SYMBOL(mlx4_get_prot_dev);
> 
> Not sure I understand why you have a wrapper to call another function
> with exactly the same parameters?  Can't we get rid of this and just
> rename mlx4_find_get_prot_dev() to mlx4_get_prot_dev()?

Sure, let's change that.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
