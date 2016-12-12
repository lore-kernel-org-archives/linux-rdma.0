From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [bug report] IB/mlx5: Support IB_WR_REG_SIG_MR
Date: Mon, 12 Dec 2016 12:33:55 +0300
Message-ID: <20161212090910.GS8244@mwanda>
References: <20161209092044.GA4640@elgon.mountain>
 <20161211092326.GA4479@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161211092326.GA4479-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 11, 2016 at 11:23:26AM +0200, Leon Romanovsky wrote:
> >   3624          case IB_SIG_TYPE_T10_DIF:
> >   3625                  psv_seg->transient_sig = cpu_to_be32(domain->sig.dif.bg << 16 |
> >   3626                                                       domain->sig.dif.app_tag);
> >   3627                  psv_seg->ref_tag = cpu_to_be32(domain->sig.dif.ref_tag);
> >   3628                  break;
> >   3629          default:
> >   3630                  pr_err("Bad signature type given.\n");
> >   3631                  return 1;
> >
> > Why do we return 1 here instead of a negative error code?
> 
> Yes, probably better to return something like EINVAL, instead of 1.
> do you want us to handle it?
> 

Yes, please.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
