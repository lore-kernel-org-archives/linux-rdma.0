From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: fix incorrect fall-through on switch statement
Date: Fri, 22 Sep 2017 13:16:30 -0400
Message-ID: <1506100590.5172.6.camel@redhat.com>
References: <20170911160313.28240-1-colin.king@canonical.com>
         <20170913164917.GU3405@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170913164917.GU3405-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-09-13 at 19:49 +0300, Leon Romanovsky wrote:
> On Mon, Sep 11, 2017 at 05:03:13PM +0100, Colin King wrote:
> > From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> > 
> > In the case where mbox_status is OCRDMA_MBX_STATUS_FAILED and
> > add_status is OCRDMA_MBX_STATUS_FAILED err_num is assigned -EAGAIN
> > however the case OCRDMA_MBX_STATUS_FAILED is missing a break and
> > falls through to the default case which then re-assigns err_num
> > to -EFAULT.   Fix this so that err_num is assigned to -EAGAIN
> > for the add_status OCRDMA_MBX_STATUS_FAILED case and -EFAULT
> > otherwise.
> > 
> > Detected by CoverityScan CID#703125 ("Missing break in switch")
> > 
> > Fixes: fe2caefcdf58 ("RDMA/ocrdma: Add driver for Emulex OneConnect
> > IBoE RDMA adapter")
> > Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> 
> Except the wrong title: IB/core -> IB/ocrdma
> 
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, patch (with fixed subject) applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
