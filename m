From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [infiniband-hw-i40iw] question about identical code for
 different branches
Date: Thu, 18 May 2017 09:00:39 +0300
Message-ID: <20170518060038.GB6326@yuval-lap>
References: <20170517170654.Horde.cfktFjC4G4wPJvJ8X1ZyUvW@gator4166.hostgator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170517170654.Horde.cfktFjC4G4wPJvJ8X1ZyUvW-fU+oOHjIBR1LoJgMfuPDHBfZZeVsHd8q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 17, 2017 at 05:06:54PM -0500, Gustavo A. R. Silva wrote:
> 
> Hello everybody,
> 
> While looking into Coverity ID 1362263 I ran into the following piece of
> code at drivers/infiniband/hw/i40iw/i40iw_virtchnl.c:445:
> 
> 445        if (vchnl_msg->iw_op_code == I40IW_VCHNL_OP_GET_VER) {
> 446                if (vchnl_msg->iw_op_ver != I40IW_VCHNL_OP_GET_VER_V0)
> 447                        vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
> 448                else
> 449                        vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
> 450                return I40IW_SUCCESS;
> 451        }
> 
> The issue is that lines of code 447 and 449 are identical for different
> branches.
> 
> My question here is if one of the branches should be modified, or the entire
> _if_ statement replaced?
> 
> Maybe a patch like the following could be applied:
> 
> index f4d1368..48fd327 100644
> --- a/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
> +++ b/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
> @@ -443,10 +443,7 @@ enum i40iw_status_code i40iw_vchnl_recv_pf(struct
> i40iw_sc_dev *dev,
>         if (!dev->vchnl_up)
>                 return I40IW_ERR_NOT_READY;
>         if (vchnl_msg->iw_op_code == I40IW_VCHNL_OP_GET_VER) {
> -               if (vchnl_msg->iw_op_ver != I40IW_VCHNL_OP_GET_VER_V0)
> -                       vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
> -               else
> -                       vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
> +               vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
>                 return I40IW_SUCCESS;
>         }
>         for (iw_vf_idx = 0; iw_vf_idx < I40IW_MAX_PE_ENABLED_VF_COUNT;
> iw_vf_idx++) {
> 
> What do you think?

This looks like a nice catch!

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> 
> I'd really appreciate any comment on this.
> 
> Thank you!
> --
> Gustavo A. R. Silva
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
