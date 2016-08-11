From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 libmlx5] fix err return values to match ibv_post_send
 expectations
Date: Thu, 11 Aug 2016 00:05:39 -0400
Message-ID: <20160811040539.GI29760@redhat.com>
References: <20160808173333.GA26622@obsidianresearch.com>
 <1470679455-28911-1-git-send-email-jarod@redhat.com>
 <b3afb94e-529f-38c4-6cdc-071f8ca3301b@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b3afb94e-529f-38c4-6cdc-071f8ca3301b-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 10, 2016 at 02:53:45PM +0300, Yishai Hadas wrote:
> On 8/8/2016 9:04 PM, Jarod Wilson wrote:
> >The man page for ibv_post_send says:
> >
> >   RETURN VALUE
> >
> >       ibv_post_send() returns 0 on success, or the value of errno on failure
> >       (which indicates the failure reason).
> >
> >QEMU looks for the return value, and in the ENOMEM case, waits and
> >retries, but with mlx5, it ends up dropping requests and hanging, because
> >of the unexpected -1 return instead of ENOMEM.
> >
> >The fix is simple: set err = E<whatever> instead of -1, and eliminate use
> >of errno = in _mlx5_post_send, just have mlx5_post_send return the err from
> >_mlx5_post_send instead. This fix has been confirmed to resolves the issues
> >seen with QEMU.
> >
> >While we're at it, fix the MW_DEBUG code paths to no muck with errno either.
> >
> >v2: per discussion with Jason Gunthorpe, don't set errno in mlx5_post_send
> 
> Your patch missed few other flows that should be fixed as part of
> mlx5_post_send. (e.g. set_data_inl_seg which returns -1, set_bind_wr
> which touches errno, etc).
> 
> Just fixed that with some other minor typos/changes to the commit
> log, will send it shortly as V3, left you as the Author to give you
> the credit for.
> 
> In addition,
> Both mlx5_post_recv and mlx5_post_srq_recv should be fixed in the
> same manner, prepared another patch as some candidate fix will send
> it shortly as well.
> 
> Once the new candidate patches will pass our regression testing will
> take them officially into libmlx5.

Works for me, thanks much.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
