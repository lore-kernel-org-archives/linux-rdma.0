From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC v2 0/3] connect reject event helpers
Date: Mon, 24 Oct 2016 12:44:31 -0500
Message-ID: <01aa01d22e1e$46b0bc90$d41235b0$@opengridcomputing.com>
References: <cover.1477003235.git.swise@opengridcomputing.com> <a46f48f3-01b3-fd9b-b642-c20555759107@grimberg.me> <001701d22be6$4854b8b0$d8fe2a10$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <001701d22be6$4854b8b0$d8fe2a10$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> >
> > > While reviewing:
> > >
> > >
> http://lists.infradead.org/pipermail/linux-nvme/2016-October/006681.html
> > >
> > > I decided to propose transport-agnostic helper functions to better
> > > handle connection reject event information.  I've included a nvme_rdma
> > > patch to utilize the new helpers.
> > >
> > > Thoughts?
> >
> > Hey Steve,
> >
> > This looks nice and useful. Would be great if you can
> > also help other ULPs that use this (e.g. srp/srpt)
> 
> can-do!

Actually, srp uses the ib_cm directly.  Further it already has logic to do
various actions based on the IB_CM Reject status.  It really doesn't need these
helpers.  The only one would be ibcm_reject_msg().  Looking at the iser
initiator, it logs nothing on a reject event. And nfsrdma doesn't log any
details about the reject reason also.  

I could add a dev_warn() or something for iser and nfsrdma.  

Steve.





--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
