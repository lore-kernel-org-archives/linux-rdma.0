From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/5] i40iw: more updates for 4.16
Date: Tue, 16 Jan 2018 20:50:20 -0700
Message-ID: <20180117035020.GA30206@ziepe.ca>
References: <20180112001054.15572-1-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180112001054.15572-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 11, 2018 at 06:10:49PM -0600, Shiraz Saleem wrote:
> Hi Doug & Jason,
> 
> This patch set includes a few bug fixes and clean-up for i40iw.
> Please consider it for 4.16.
> 
> Shiraz
> 
> Mustafa Ismail (2):
>   i40iw: Remove setting of rem_addr.len
>   i40iw: Free IEQ resources
> 
> Shiraz Saleem (2):
>   i40iw: Remove extra call to i40iw_est_sd()
>   i40iw: Zero-out consumer key on allocate stag for FMR
> 
> Sindhu Devale (1):
>   i40iw: Remove limit on re-posting AEQ entries to HW

Applied to for-next, thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
