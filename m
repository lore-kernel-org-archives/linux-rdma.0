From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 0/3] Fix request completion holes
Date: Thu, 2 Nov 2017 11:53:44 -0500
Message-ID: <026401d353fb$24d56d60$6e804820$@opengridcomputing.com>
References: <1509440122-1190-1-git-send-email-sagi@grimberg.me> <8abcde91-9150-2982-3900-078619bcdac0@mellanox.com> <a950a671-22a1-432c-555e-8309c8a64a88@grimberg.me> <d9dcdb05-d001-53d8-7ed7-5fafc1709f4a@mellanox.com> <20171101165036.GD1030@ziepe.ca> <5f3955d2-9116-5f18-2299-cc697947d599@grimberg.me> <20171101175819.GG1030@ziepe.ca> <5810bb05-fffd-a0f2-3509-9d9b89a2ef32@grimberg.me> <20171102151254.GE18874@ziepe.ca> <022e01d353f6$3fcbafd0$bf630f70$@opengridcomputing.com> <20171102163614.GK18874@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102163614.GK18874-uk2M96/98Pc@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgg-uk2M96/98Pc@public.gmane.org>
Cc: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'idanb' <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Max Gurtovoy' <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> > iWARP spec too.   This is in regard to completion ordering though.  The
local
> > invalidate send WR must have the IB_SEND_FENCE flag set if you want it to
only
> > be executed after all prior send WRs are executed.
> 
> Oh right, yes, you need to have local invalidate fence to guarentee
> that, but usually a local operation will not refer to a RKEY, so
> execution ordering wont matter.
> 
> But this is a good general point, doesn't a ULP need to set FENCE on
> SEND, eg:
> 
>  RDMA READ (rkey)
>  RDMA READ (rkey)
>  SEND w/ FENCE (tell remote to invalidate rkey)
> 
> Otherwise IBA Table 79 says RDMA READ can pass SEND and we have a
> situation where the rkey has become invalidated when the remote is
> still trying to use it.
> 
> IBA actually explicitly calls this out (pg 538):
> 
>  RDMA Read operations may be executed at the target after subse-
>  quent Send and Invalidate operation already performed the invalida-
>  tion at the target. That may cause the RDMA Read operation to fail.
>  Setting the Fence Indicator on the subsequent operations guarantees
>  that the RDMA Read will fully complete before the invalidation takes
>  place.
> 
> None of our ULPs use IB_SEND_FENCE - so this is a bug!
> 

I think the nvmf target doesn't post the SEND_W_INVALIDATE (NVMF CQE) until the
RDMA READ(s) (and back end BIO submission) complete. 

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
