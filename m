From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: message size, was Re: merge struct ib_device_attr into struct	ib_device
Date: Tue, 22 Sep 2015 17:15:15 -0500
Message-ID: <014101d0f584$286573d0$79305b70$@opengridcomputing.com>
References: <1442869187-5556-1-git-send-email-hch@lst.de> <1442918846.4412.0.camel@opteya.com> <20150922203217.GA10825@lst.de> <013f01d0f57a$85b12a20$91137e60$@opengridcomputing.com> <20150922215514.GA13252@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150922215514.GA13252-jcswGhMUV9g@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, postmaster-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of 'Christoph Hellwig'
> Sent: Tuesday, September 22, 2015 4:55 PM
> To: Steve Wise; postmaster-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: message size, was Re: merge struct ib_device_attr into struct ib_device
> 
> On Tue, Sep 22, 2015 at 04:06:17PM -0500, Steve Wise wrote:
> > Can you create a series of smaller patches that will fit on the list?
> > That would make it easier for everyone to review/comment.
> 
> I don't see how that is possible, as it's a flag day change.
> 
> But maybe we really need to bump up the message size limits for linux-rdma,
> I'm pretty sure linux-kernel and linux-scsi handle attachments of this
> size just fine.

An alternative, I guess, is to have the patch broken logically into a series by: core changes, driver changes, and ulp changes.  And
then ask Doug to squash it at merge time, as part of the cover letter.    But perhaps that isn't standard operating procedure...

How do we change the message size limits?   Reviewing w/o it being inline is painful for the (many) reviewers...

Steve

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
