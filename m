From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-rc] RDMA/restrack: don't use uaccess_kernel()
Date: Tue, 13 Feb 2018 09:10:11 -0600
Message-ID: <00e001d3a4dc$be3cc390$3ab64ab0$@opengridcomputing.com>
References: <eac01039be8c0518e37928e5b003a911c32e53a7.1518468700.git.swise@opengridcomputing.com> <20180213090122.GT2197@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213090122.GT2197-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> On Thu, Feb 08, 2018 at 12:09:43PM -0800, Steve Wise wrote:
> > uaccess_kernel() isn't sufficient to determine if an rdma resource is
> > user-mode or not.  For example, resources allocated in the add_one()
> > function of an ib_client get falsely labeled as user mode, when they
> > are kernel mode allocations.  EG: mad qps.
> 
> I found the reason.
> 
> It is due to the difference between code compiled as
> a module (=m) or compiled in as monolith (=y). The "add_one()" runs in
user
> space contexts in first scenario and as kernel space context in second
> scenario. I'm not using modules so it worked for me.
> 
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Good to know. Thanks!

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
