From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V2] svcrdma: Fence LOCAL_INV work requests
Date: Thu, 5 Jun 2014 11:21:47 -0500
Message-ID: <007301cf80da$3f5b07f0$be1117d0$@opengridcomputing.com>
References: <20140605145429.14347.22150.stgit@build.ogc.int> <20140605161353.GH8362@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140605161353.GH8362-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'J. Bruce Fields'" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: J. Bruce Fields [mailto:bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org]
> Sent: Thursday, June 05, 2014 11:14 AM
> To: Steve Wise
> Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
> Subject: Re: [PATCH V2] svcrdma: Fence LOCAL_INV work requests
> 
> On Thu, Jun 05, 2014 at 09:54:31AM -0500, Steve Wise wrote:
> > This applies on top of:
> >
> > 	commit e5a070216356dbcb03607cb264cc3104e17339b3
> > 	Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > 	Date:   Wed May 28 15:12:01 2014 -0500
> >
> > 	    svcrdma: refactor marshalling logic
> 
> Sorry, I lost track--was there another revision of that patch coming
> too?
> 

No. 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
