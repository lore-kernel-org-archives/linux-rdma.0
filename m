From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [for-next,1/2] i40iw: Use sqsize to initialize cqp_requests
 elements
Date: Tue, 12 Dec 2017 16:12:55 -0600
Message-ID: <20171212221255.GA17116@ssaleem-MOBL4.amr.corp.intel.com>
References: <1512765269-145929-2-git-send-email-henry.orosco@intel.com>
 <20171211234108.GH32020@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171211234108.GH32020-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "Orosco, Henry" <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 11, 2017 at 04:41:08PM -0700, Jason Gunthorpe wrote:
> On Fri, Dec 08, 2017 at 02:34:28PM -0600, Henry Orosco wrote:
> > From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Use sqsize instead of I40IW_CQP_SW_SQSIZE_2048 to initialize
> > cqp_requests elements in the for-loop as sqsize is used
> > to allocate memory for cqp_requests.
> > 
> > Signed-off-by: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >  drivers/infiniband/hw/i40iw/i40iw_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Applied to for-next, thanks
> 
> There was a 3rd patch about the 'bool' change that now cross depends
> with for-next and for-rc. I think you have to re-spin that one against
> for-rc as there is another usage of 'accelerated' added there?
> 

Hi Jason - I sent an updated ver. of this patch "i40iw: Change accelerated flag to bool"
against the for-rc branch.

Shiraz



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
