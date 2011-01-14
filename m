From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: mlx4 fix for 36-bit bus addresses on 32-bit arch (was: [PATCH
 1/1 (resend)] mthca: Modify to support embedded PowerPC platforms)
Date: Fri, 14 Jan 2011 15:09:03 +0200
Message-ID: <20110114130903.GA29706@mtldesk30>
References: <ig5vl1$j0$1@dough.gmane.org>
 <adafwt06puj.fsf@cisco.com>
 <4D2D5FAD.6030508@cadence.com>
 <adahbde57r7.fsf_-_@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adahbde57r7.fsf_-_-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 12, 2011 at 09:53:00AM -0800, Roland Dreier wrote:
>  
> -	ibdev->uar_map = ioremap(ibdev->priv_uar.pfn << PAGE_SHIFT, PAGE_SIZE);
> +	ibdev->uar_map = ioremap((phys_addr_t) ibdev->priv_uar.pfn << PAGE_SHIFT,
> +				 PAGE_SIZE);
>  	if (!ibdev->uar_map)
>  		goto err_uar;

CX devices are 64 bit devices with respect to the PCI bus. As far as I
know, a 64 bit PCI device memory space, could be placed anywhere in
that space regardless of the CPU architecture. So I think it would be
more appropriate to to use u64 casting. I know that ioremap accepts
phys_addr_t as its first argument but I wonder if ioremap shouldn't be
changed to accept u64 for that argument.

Regardless of whether what I say above is correct or not, wouldn't it
be nicer to to define pfn as either u64 or phys_addr_t and avoid the
casting?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
