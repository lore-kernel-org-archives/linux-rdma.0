From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 for-4.14-rc] RDMA/core: Correct nlmsg_len after
 appending attributes
Date: Fri, 29 Sep 2017 11:32:01 -0400
Message-ID: <1506699121.2919.22.camel@redhat.com>
References: <20170929132501.15440-1-shiraz.saleem@intel.com>
         <20170929144117.GA2965@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170929144117.GA2965-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-09-29 at 17:41 +0300, Leon Romanovsky wrote:
> On Fri, Sep 29, 2017 at 08:25:01AM -0500, Shiraz Saleem wrote:
> > Commit 1a1c116f3dcf removes nlmsg_len calculation in
> > ibnl_put_attr causing netlink messages to be rejected due
> > to incorrect length.
> >
> > Add nlmsg_end after all attributes are appended to calculate
> > the nlmsg_len.
> >
> > Fixes: 1a1c116f3dcf ("RDMA/netlink: Simplify the put_msg and
> put_attr")
> > Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Except the fact that title is a little bit misleading and better to
> be
> "IB/iwpm: Properly mark end of netlink messages".
> 
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

I adjusted the subject as I applied this, thanks to both of you.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
