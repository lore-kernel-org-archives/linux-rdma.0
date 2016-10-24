From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC v2 0/3] connect reject event helpers
Date: Mon, 24 Oct 2016 12:57:13 -0500
Message-ID: <01ac01d22e20$0c8e9df0$25abd9d0$@opengridcomputing.com>
References: <cover.1477003235.git.swise@opengridcomputing.com> <a46f48f3-01b3-fd9b-b642-c20555759107@grimberg.me> <001701d22be6$4854b8b0$d8fe2a10$@opengridcomputing.com> <01aa01d22e1e$46b0bc90$d41235b0$@opengridcomputing.com> <2F5E122E-0B50-4264-8E44-3D484B0282F0@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2F5E122E-0B50-4264-8E44-3D484B0282F0-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'List Linux RDMA Mailing' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> >>> Hey Steve,
> >>>
> >>> This looks nice and useful. Would be great if you can
> >>> also help other ULPs that use this (e.g. srp/srpt)
> >>
> >> can-do!
> >
> > Actually, srp uses the ib_cm directly.  Further it already has logic to do
> > various actions based on the IB_CM Reject status.  It really doesn't need
these
> > helpers.  The only one would be ibcm_reject_msg().  Looking at the iser
> > initiator, it logs nothing on a reject event. And nfsrdma doesn't log any
> > details about the reject reason also.
> >
> > I could add a dev_warn() or something for iser and nfsrdma.
> 
> I'm fixing an issue in this area. I'd like to take care of
> the xprtrdma connection upcall myself once you've got these
> new APIs introduced.

Sure, not a problem!  



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
