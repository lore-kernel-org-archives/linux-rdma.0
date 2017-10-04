From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 0/5] more i40iw fixes
Date: Wed, 04 Oct 2017 15:31:14 -0400
Message-ID: <1507145474.46071.5.camel@redhat.com>
References: <20171003161150.16172-1-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171003161150.16172-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-10-03 at 11:11 -0500, Shiraz Saleem wrote:
> Hi Doug,
> 
> This series includes a few more minor i40iw fixes.
> 
> If you deem the submission is too late for 4.14-rc, it is fine to
> push it to for-next.
> 
> v0->v1:
>         * change ack_rcvd flag to bool in Patch #1
>         * change first_sq_wq flag to bool in Patch #2

I took patches 4 and 5 into for-rc, and the rest into for-next. 
Thanks.


-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
