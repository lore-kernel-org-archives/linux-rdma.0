From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V6 8/9] isert: Use local_dma_lkey whenever possible.
Date: Fri, 24 Jul 2015 13:41:32 -0500
Message-ID: <00cc01d0c640$5c4c3850$14e4a8f0$@opengridcomputing.com>
References: <20150724161331.25617.8475.stgit@build2.ogc.int> <20150724161859.25617.17286.stgit@build2.ogc.int> <20150724164909.GB25480@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150724164909.GB25480-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Friday, July 24, 2015 11:49 AM
> To: Steve Wise
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
> Subject: Re: [PATCH V6 8/9] isert: Use local_dma_lkey whenever possible.
> 
> On Fri, Jul 24, 2015 at 11:18:59AM -0500, Steve Wise wrote:
> > No need to allocate a dma_mr if the device provides a local_dma_lkey.
> 
> It is probably safe to put your series on top of mine, which
> incorporates this patch already.
> 
> https://github.com/jgunthorpe/linux/commits/remove-ib_get_dma_mr
> 
> Jason

I will rebase on this. 

 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
