From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [pull request][PATCH 0/7] i40iw: Fixes for i40iw
Date: Tue, 8 Aug 2017 09:30:22 -0500
Message-ID: <20170808143022.GA35328@horosco-MOBL2.amr.corp.intel.com>
References: <20170807213203.30588-1-henry.orosco@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170807213203.30588-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Please do not pull in my last pull request. Unfortunately
I sent out a patch which was not ready. The patch in
question is the following (2nd one in the series):

commit 4762fd90de15af911a608a70c2964bd9c660cdc1
Date:   Wed Jul 5 10:40:11 2017 -0500
i40iw: Ignore first SQ wqe_index if it shows up as a CQE

I will respin another pull request without this patch.

-Henry

On Mon, Aug 07, 2017 at 04:31:56PM -0500, Henry Orosco wrote:
> The following patch series has fixes for the i40iw driver.
> 
> --------------------------------------------------------
> 
> Git Repo to pull from:
>         https://github.com/horosco/linux.git
> tag:
>         for-v4.13-rc-08-07-17
> 
> Commits of interest:
> 
> commit 9a36a7047ca56c0cbb8b320c645e2b75297bf5c1
> Date:   Mon Jul 3 15:45:32 2017 -0500
> i40iw: Fix parsing of query/commit FPM buffers
> 
> to
> 
> commit fb916eaade1a03dded8e7d502035360144abb291
> Date:   Wed Jul 5 13:33:54 2017 -0500
> i40iw: Fix potential fcn_id_array out of bounds
> 
> --------------------------------------------------------
> 
> Chien Tin Tung (1):
>   i40iw: Fix parsing of query/commit FPM buffers
> 
> Christopher N Bednarz (3):
>   i40iw: Ignore first SQ wqe_index if it shows up as a CQE
>   i40iw: Use correct alignment for CQ0 memory
>   i40iw: Fix potential fcn_id_array out of bounds
> 
> Mustafa Ismail (2):
>   i40iw: Correct variable names
>   i40iw: Fix typecast of tcp_seq_num
> 
> Shiraz Saleem (1):
>   i40iw: Improve CQP timeout logic
> 
>  drivers/infiniband/hw/i40iw/i40iw_ctrl.c   | 136 ++++++++++++++++++++---------
>  drivers/infiniband/hw/i40iw/i40iw_d.h      |   4 +-
>  drivers/infiniband/hw/i40iw/i40iw_p.h      |  14 +--
>  drivers/infiniband/hw/i40iw/i40iw_puda.c   |   2 +-
>  drivers/infiniband/hw/i40iw/i40iw_status.h |   2 +-
>  drivers/infiniband/hw/i40iw/i40iw_type.h   |   5 ++
>  drivers/infiniband/hw/i40iw/i40iw_uk.c     |  21 ++++-
>  drivers/infiniband/hw/i40iw/i40iw_user.h   |   2 +
>  drivers/infiniband/hw/i40iw/i40iw_utils.c  |  22 +++--
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c  |   1 +
>  10 files changed, 147 insertions(+), 62 deletions(-)
> 
> -- 
> 2.8.3
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
