From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] i40iw fixes
Date: Fri, 22 Sep 2017 13:45:30 -0400
Message-ID: <1506102330.5172.13.camel@redhat.com>
References: <20170919141913.10172-1-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170919141913.10172-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-09-19 at 09:19 -0500, Shiraz Saleem wrote:
> This series includes a few fixes for i40iw driver to be
> considered for 4.14-rc.
> 
> Mustafa Ismail (1):
>   i40iw: Add missing VLAN priority
> 
> Shiraz Saleem (4):
>   i40iw: Fail open if there are no available MSI-X vectors
>   i40iw: Prevent multiple netdev event notifier registrations
>   i40iw: Call i40iw_cm_disconn on modify QP to disconnect
>   i40iw: Add support for port reuse on active side connections
> 
>  drivers/infiniband/hw/i40iw/i40iw.h       |   1 -
>  drivers/infiniband/hw/i40iw/i40iw_cm.c    | 154 +++++++++++++++-----
> ----------
>  drivers/infiniband/hw/i40iw/i40iw_cm.h    |   5 +
>  drivers/infiniband/hw/i40iw/i40iw_main.c  |  39 ++++----
>  drivers/infiniband/hw/i40iw/i40iw_utils.c |   6 +-
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c |  12 +++
>  6 files changed, 120 insertions(+), 97 deletions(-)

The fifth patch was a bit large...if it weren't for the fact that it
fixes failed connects under load I would have skipped it.  But, I took
the entire series to -rc because it actually fixes an issue.  Thanks.


-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
