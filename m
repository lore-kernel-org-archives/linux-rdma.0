From: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] IB/i40iw: use setup_timer
Date: Tue, 2 May 2017 22:51:41 +0800
Message-ID: <20170502145141.2fo25uzgkqerjkg4@ThinkPad>
References: <d2a4d5220abf014f8e5629a7217eaa71262199fd.1493188028.git.geliangtang@gmail.com>
 <1bf32409-ac2a-0b14-19db-896e146db23f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1bf32409-ac2a-0b14-19db-896e146db23f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Apr 29, 2017 at 09:45:27AM -0400, Doug Ledford wrote:
> On 4/28/2017 9:37 PM, Geliang Tang wrote:
> > Use setup_timer() instead of init_timer() to simplify the code.
> > 
> > Signed-off-by: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> > Changes in v2:
> >  - use setup_timer() in i40iw_terminate_start_timer().
> 
> I already applied your previous patch and did the fixup to add
> i40iw_terminate_start_timer() into the patch myself.  Thanks.
> 
> 
> -- 
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
> 

Thank you, Doug.

-Geliang

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
