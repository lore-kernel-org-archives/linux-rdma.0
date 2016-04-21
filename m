From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/rdmavt,hfi1,qib: Fix memory leak
Date: Thu, 21 Apr 2016 08:22:17 -0400
Message-ID: <20160421122216.GA13471@phlsvsds.ph.intel.com>
References: <20160420125205.28231.86818.stgit@scvm10.sc.intel.com> <20160420130523.28231.90454.stgit@scvm10.sc.intel.com> <20160421093827.GA26951@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160421093827.GA26951-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 21, 2016 at 12:38:27PM +0300, Leon Romanovsky wrote:
>On Wed, Apr 20, 2016 at 06:05:24AM -0700, Dennis Dalessandro wrote:
>> From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> 
>> rdi->ports has memory allocated in rvt_alloc_device(), but does not get
>> freed because the hfi1 and qib drivers drivers call ib_dealloc_device()
>> directly instead of going through rdmavt. Add a rvt_dealloc_device()
>> that frees rdi->ports and then calls ib_dealloc_device(). Switch hfi1
>> and qib drivers to calling rvt_dealloc_device() instead of
>> ib_dealloc_device() directly.
>> 
>> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
>Dennis,
>You posted Fixes line in two other patches, please do in this one two.
>It is needed for proper tracking.
>
>Except this,
>Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Leon, I don't think that a fixes line is warranted in this case. There 
isn't a single commit that causes this issue. It is a missed code path being 
moved to rdmavt.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
