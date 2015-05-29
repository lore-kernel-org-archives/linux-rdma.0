From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] Add const to various core functions
Date: Fri, 29 May 2015 11:32:32 -0400
Message-ID: <20150529153231.GA10432@phlsvsds.ph.intel.com>
References: <1432240824-3277-1-git-send-email-ira.weiny@intel.com> <20150529041313.GA1603@phlsvsds.ph.intel.com> <1432904099.114391.61.camel@redhat.com> <20150529151735.GA5372@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150529151735.GA5372-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > 
> > Double check that they stand on their own.  If they do, I'll review them
> > separately.
> 
> They do stand on their own and they are improvements even without the OPA code.

After responding to this email I found a 0-day build email which shows a
build warnings on this patch building ehca on PPC:

IB/core: Add const to device process_mad

I'm not sure why but sometimes my 0-day build results are delayed for quite
some time?  I'm guessing the servers prioritize kernel.org over github
accounts???  Or I'm just doing something wrong...  :-/

Sorry,
Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
