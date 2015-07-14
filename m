From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: Kernel fast memory registration API proposal [RFC]
Date: Tue, 14 Jul 2015 09:42:25 -0500
Message-ID: <001401d0be43$4cf5ae40$e6e10ac0$@opengridcomputing.com>
References: <559F8BD1.9080308@dev.mellanox.co.il> <20150713163015.GA23832@obsidianresearch.com> <55A4CABC.5050807@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55A4CABC.5050807-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Oren Duer' <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>, 'Liran Liss' <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Sagi Grimberg [mailto:sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> Sent: Tuesday, July 14, 2015 3:39 AM
> To: Jason Gunthorpe
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Christoph Hellwig; Steve Wise; Or Gerlitz; Oren Duer; Chuck Lever; Bart Van Assche; Liran Liss;
Hefty,
> Sean; Doug Ledford; Tom Talpey
> Subject: Re: Kernel fast memory registration API proposal [RFC]
> 
> On 7/13/2015 7:30 PM, Jason Gunthorpe wrote:
> > On Fri, Jul 10, 2015 at 12:09:37PM +0300, Sagi Grimberg wrote:
> >> Given the last discussions on our in-kernel memory registration API I
> >> thought I'd propose another approach to address this.
> >
> > I assume you can put your new indirect registrations under this API
> > without changing the callers?
> 
> Correct, it's a bonus. The main idea here is to simplify the API for
> ULPs.
> 
> >
> >>           /*
> >>            * Set the SG list in the MR, fail if the sg
> >> 	  * list is not well aligned (caller should handle
> >> 	  * it) or mr does not have enough room to fit the sg.
> >>            */
> >>           rc = ib_mr_set_sg(mr, sg, sg_nents);
> >> 	 if (rc)
> >> 		/* HW does not support - Need to handle it */
> >
> > I think this call should also do the post.
> >
> > There seems to be nothing the ULP can customize about the post step
> > that needs to be exposed.. and bundling the post allows more
> > flexability to implement different schemes without impacting the ULPs.
> 
> This is exactly what I don't want to do. I don't think that implicit
> posting is a good idea for reasons that I mentioned earlier:
> 
> "This is where I have a problem. Providing an API that may or may not
> post a work request on my QP is confusing, and I don't understand its
> semantics at all. Do I need to reserve slots on my QP? should I ask for
> a completion? If we suppress the completion will I see an error
> completion? What should I expect to find in the wr_id?"
> 
> We're much better off with keeping the post interface in place but
> have it much simpler.
> 
> Sagi.

I agree...I don't like the idea of WR posting done under the covers.  


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
