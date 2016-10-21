From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC v2 0/3] connect reject event helpers
Date: Fri, 21 Oct 2016 16:58:40 -0500
Message-ID: <001601d22be6$484e7720$d8eb6560$@opengridcomputing.com>
References: <cover.1477003235.git.swise@opengridcomputing.com> <a46f48f3-01b3-fd9b-b642-c20555759107@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a46f48f3-01b3-fd9b-b642-c20555759107-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> 
> > While reviewing:
> >
> > http://lists.infradead.org/pipermail/linux-nvme/2016-October/006681.html
> >
> > I decided to propose transport-agnostic helper functions to better
> > handle connection reject event information.  I've included a nvme_rdma
> > patch to utilize the new helpers.
> >
> > Thoughts?
> 
> Hey Steve,
> 
> This looks nice and useful. Would be great if you can
> also help other ULPs that use this (e.g. srp/srpt)

can-do!


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
