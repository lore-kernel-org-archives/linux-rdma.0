From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] svcrdma: Fence LOCAL_INV work requests
Date: Thu, 5 Jun 2014 08:55:31 -0500
Message-ID: <002901cf80c5$d0b577e0$722067a0$@opengridcomputing.com>
References: <20140602171433.31076.5634.stgit@build.ogc.int> <53901ADB.9020405@acm.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53901ADB.9020405-HInyCGIudOg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Bart Van Assche [mailto:bvanassche-HInyCGIudOg@public.gmane.org]
> Sent: Thursday, June 05, 2014 2:23 AM
> To: Steve Wise; bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
> Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
> Subject: Re: [PATCH] svcrdma: Fence LOCAL_INV work requests
> 
> On 06/02/14 19:14, Steve Wise wrote:
> > Fencing forces the invalidate to only happen after all subsequent send
> > work requests have been completed.
> 
> Shouldn't that read "prior" instead of "subsequent" ?
>

Yes.  
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
