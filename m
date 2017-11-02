From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 0/3] Fix request completion holes
Date: Thu, 2 Nov 2017 12:55:22 -0500
Message-ID: <02eb01d35403$c155ff30$4401fd90$@opengridcomputing.com>
References: <1509440122-1190-1-git-send-email-sagi@grimberg.me> <8abcde91-9150-2982-3900-078619bcdac0@mellanox.com> <a950a671-22a1-432c-555e-8309c8a64a88@grimberg.me> <d9dcdb05-d001-53d8-7ed7-5fafc1709f4a@mellanox.com> <ae5a6be3-f9c3-9926-ab0d-48b0a99cdb35@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ae5a6be3-f9c3-9926-ab0d-48b0a99cdb35-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'idanb' <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Max Gurtovoy' <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> What about latency effects? Any noticeable change?
> 
> > I understand that (1), (2) and (3) are invalid, the performance
> > reduction induce by mode (4) need to motivate us to enable cqe/event
> > moderation as soon as possible.
> 
> Well good, it means you can help test my adaptive coalescing code :)
> 
> May I ask what moderation parameters did you use? it will be useful
> to pin down the profile levels the adaptive moderator would bounce
> between.
> 

Hey Sagi, I can help too on testing this with iw_cxgb4.  Where is your current
WIP?

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
