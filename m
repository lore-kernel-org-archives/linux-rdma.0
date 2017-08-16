From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [pull request][PATCH v2 0/6] i40iw: Fixes for i40iw
Date: Wed, 16 Aug 2017 11:29:05 -0400
Message-ID: <1502897345.33760.9.camel@redhat.com>
References: <20170809013848.29080-1-henry.orosco@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170809013848.29080-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-08-08 at 20:38 -0500, Henry Orosco wrote:
> The following patch series has fixes for the i40iw driver.
> 
> V2 - Removed 1 patch from series
> 
> --------------------------------------------------------
> 
> Git Repo to pull from:
>         https://github.com/horosco/linux.git
> 
> tag:
>         for-v4.13-08-07-2017-v2
> 
> Commits of interest:
> 
> commit 08bc3c4ee4c759655b2250b59ddec80950772f6a
> Date:   Wed Jul 5 13:33:54 2017 -0500
> i40iw: Fix potential fcn_id_array out of bounds
> 
> to
> 
> commit a18153f9af05c1f03ee449cc881fd63e9f83d7fc
> Date:   Mon Jul 3 15:45:32 2017 -0500
> i40iw: Fix parsing of query/commit FPM buffers
> 
> --------------------------------------------------------
> 
> Chien Tin Tung (1):
>   i40iw: Fix parsing of query/commit FPM buffers
> 
> Christopher N Bednarz (2):
>   i40iw: Use correct alignment for CQ0 memory
>   i40iw: Fix potential fcn_id_array out of bounds
> 
> Mustafa Ismail (2):
>   i40iw: Correct variable names
>   i40iw: Fix typecast of tcp_seq_num
> 
> Shiraz Saleem (1):
>   i40iw: Improve CQP timeout logic

Hi Henry,

I took everything for -rc *Except* the Improve CQP timeout logic patch.
 That patch qualifies as new development and not really a bug fix, and
since we are at -rc5, new development needs to be in for-next instead.

> 
>  drivers/infiniband/hw/i40iw/i40iw_ctrl.c   | 134
> ++++++++++++++++++++---------
>  drivers/infiniband/hw/i40iw/i40iw_d.h      |   4 +-
>  drivers/infiniband/hw/i40iw/i40iw_p.h      |  14 +--
>  drivers/infiniband/hw/i40iw/i40iw_puda.c   |   2 +-
>  drivers/infiniband/hw/i40iw/i40iw_status.h |   2 +-
>  drivers/infiniband/hw/i40iw/i40iw_type.h   |   5 ++
>  drivers/infiniband/hw/i40iw/i40iw_uk.c     |   8 +-
>  drivers/infiniband/hw/i40iw/i40iw_utils.c  |  22 +++--
>  8 files changed, 129 insertions(+), 62 deletions(-)
> 
-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
