From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [infiniband-hw-i40iw] question about identical code for
 different branches
Date: Thu, 18 May 2017 10:03:17 -0500
Message-ID: <20170518150317.GA10396@ctung-MOBL3.amr.corp.intel.com>
References: <20170517170654.Horde.cfktFjC4G4wPJvJ8X1ZyUvW@gator4166.hostgator.com>
 <20170518050029.GY3616@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170518050029.GY3616-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 Thu, May 18, 2017 at 08:00:29AM +0300, Leon Romanovsky wrote:
> On Wed, May 17, 2017 at 05:06:54PM -0500, Gustavo A. R. Silva wrote:
> >
> > Hello everybody,
> >
> > While looking into Coverity ID 1362263 I ran into the following piece of
> > code at drivers/infiniband/hw/i40iw/i40iw_virtchnl.c:445:
> >
> > 445        if (vchnl_msg->iw_op_code == I40IW_VCHNL_OP_GET_VER) {
> > 446                if (vchnl_msg->iw_op_ver != I40IW_VCHNL_OP_GET_VER_V0)
> > 447                        vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
> > 448                else
> > 449                        vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
> > 450                return I40IW_SUCCESS;
> > 451        }
> >
> > The issue is that lines of code 447 and 449 are identical for different
> > branches.
> >
> > My question here is if one of the branches should be modified, or the entire
> > _if_ statement replaced?
> >
> > Maybe a patch like the following could be applied:
> 
> It looks like that you can replace I40IW_VCHNL_OP_GET_VER_V0 with
> I40IW_VCHNL_OP_GET_VER and get rid of all places with
> I40IW_VCHNL_OP_GET_VER_V0.

No. I40IW_VCHNL_OP_GET_VER is iw_op_code and I40IW_VCHNL_OP_GET_VER_V0 is
iw_op_ver two different things.

Chien
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
