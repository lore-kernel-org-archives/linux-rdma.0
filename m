From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx: Expose max_fmr to ib_query_device
Date: Thu, 5 Nov 2015 13:07:49 +0200
Message-ID: <20151105110749.GA8115@yuval-lab>
References: <1446134879-20456-1-git-send-email-yuval.shaia@oracle.com>
 <563255A9.1050705@dev.mellanox.co.il>
 <20151105104844.GA7749@yuval-lab>
 <20151105105128.GA24381@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151105105128.GA24381-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 05, 2015 at 02:51:28AM -0800, Christoph Hellwig wrote:
> On Thu, Nov 05, 2015 at 12:48:45PM +0200, Yuval Shaia wrote:
> > On Thu, Oct 29, 2015 at 07:21:45PM +0200, Sagi Grimberg wrote:
> > > Hi Yuval,
> > > 
> > > The title prefix should be IB/mlx4:
> > > 
> > > >Expose max_fmr so it will be available to ULPs.
> > > >max_fmr is num_mpts minus reserved.
> 
> What do you plan to use it for?  We're aiming hard to get rid of FMRs
> from the whole kernel stack ASAP.
We have two drivers that are using FMR.
> 
> In doubt whatever you plan to use it for should be converted to FRs
> instead.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
