From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 0254/1285] Replace numeric parameter like 0444 with macro
Date: Tue, 2 Aug 2016 10:20:07 -0500
Message-ID: <00c701d1ecd1$5a4caef0$0ee60cd0$@opengridcomputing.com>
References: <20160802105341.30676-1-baolex.ni@intel.com> <006201d1ecc7$f6889bd0$e399d370$@opengridcomputing.com> <20160802150832.GA26697@home.goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160802150832.GA26697-UXXpqIVMmUvGOoBxVeW/qg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Steven Rostedt' <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: 'Baole Ni' <baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, airlied-cv59FeDIM0c@public.gmane.org, kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, dougthompson-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chuansheng.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> On Tue, Aug 02, 2016 at 09:12:54AM -0500, Steve Wise wrote:
> > Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> >
> 
> I have to ask, why did you ack all these? There's several things wrong with
> this patch series, but even the point of the patch is mistaken. It makes
> readable code much less readable. When you chmod a file, do you type
> 
>   chmod 0444 file
> 
> or do you write
> 
>   chmod S_IRUSR|S_IRGRP|S_IROTH file
> 
> ?
> 
> Which of the above is easier to figure what is being changed?
>

I assumed this was some global "fix up".   
 
> Not to mention, because the subject is the same for all 1285 patches, and you
> deleted the content of the patch in your ack, there's no way to know what
> exactly this ack is for (I haven't received the original patch yet because
> it's probably being ratelimited by some mail server).
> 

I acked just the single patches that hit cxgb3/cxgb4.  But if this is really
garbage, then ignore my ACKs...

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
