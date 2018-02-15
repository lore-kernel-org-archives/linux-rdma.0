From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-rc 00/15] RDMA fixes for v4.16
Date: Thu, 15 Feb 2018 15:26:43 -0700
Message-ID: <20180215222643.GA30721@ziepe.ca>
References: <20180213101841.20101-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180213101841.20101-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 13, 2018 at 12:18:26PM +0200, Leon Romanovsky wrote:
> Hi,
> 
> This is mostly fixes for uverbs layers with two extra patches: one from
> Alaa, who removed annoying warning prints in IPoIB and another from Leon
> who removed unimplented part of restrack code.
> 
> Thanks
> 
> Alaa Hleihel (1):
>   IB/ipoib: Do not warn if IPoIB debugfs doesn't exist
> 
> Jason Gunthorpe (7):
>   IB/uverbs: Use inline data transfer for UHW_IN
>   IB/uverbs: Use u64_to_user_ptr() not a union
>   IB/uverbs: Use __aligned_u64 for uapi headers
>   IB/uverbs: Hold the uobj write lock after allocate
>   IB/uverbs: Tidy lockdep_check
>   IB/uverbs: Tidy uverbs_uobject_add
>   IB/uverbs: Fix unbalanced unlock on error path for
>     rdma_explicit_destroy
> 
> Leon Romanovsky (3):
>   RDMA/restrack: Remove unimplemented XRCD object
>   RDMA/uverbs: Protect from races between lookup and destroy of uobjects
>   RDMA/uverbs: Protect from command mask overflow
> 
> Matan Barak (4):
>   IB/uverbs: Always the attribute size provided by the user
>   IB/uverbs: Fix method merging in uverbs_ioctl_merge
>   IB/uverbs: Add ioctl support for 32bit processes
>   IB/uverbs: Fix possible oops with duplicate ioctl attributes

I applied all of these to for-rc, with some modifications to the
commit messages. Thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
