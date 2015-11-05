From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx: Expose max_fmr to ib_query_device
Date: Thu, 5 Nov 2015 14:12:30 +0200
Message-ID: <20151105121229.GC8115@yuval-lab>
References: <1446134879-20456-1-git-send-email-yuval.shaia@oracle.com>
 <563255A9.1050705@dev.mellanox.co.il>
 <20151105104844.GA7749@yuval-lab>
 <20151105105128.GA24381@infradead.org>
 <20151105110749.GA8115@yuval-lab>
 <20151105111035.GA25203@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151105111035.GA25203-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 05, 2015 at 03:10:35AM -0800, Christoph Hellwig wrote:
> On Thu, Nov 05, 2015 at 01:07:49PM +0200, Yuval Shaia wrote:
> > > What do you plan to use it for?  We're aiming hard to get rid of FMRs
> > > from the whole kernel stack ASAP.
> > We have two drivers that are using FMR.
> 
> I now RDS still has the totally silly separate code bases for IB vs
> iWrap and you need to move IB to use the IW code for memory
> registrations, but that's the second one?
Sorry, my mistake, only RDS.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
