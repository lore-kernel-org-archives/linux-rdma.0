From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 1/2] iw_cxgb4: call dev_put() on l2t allocation failure
Date: Fri, 2 Sep 2016 09:24:17 -0500
Message-ID: <1a5401d20525$b0a52ef0$11ef8cd0$@opengridcomputing.com>
References: <c1b639ca7d71ee034e334b4400ff0bae3ba58c47.1472241953.git.swise@opengridcomputing.com> <01bf01d2022b$0fc39190$2f4ab4b0$@opengridcomputing.com> <05141088-7c92-daba-1e0b-da1bc5656a75@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <05141088-7c92-daba-1e0b-da1bc5656a75-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On 8/29/2016 3:25 PM, Steve Wise wrote:
> > Hey Doug, I was hoping these two could make 4.8-rc.  Particularly patch
> 2/2.
> >
> > Steve.
> >
> >
> 
> Hi Steve,
> 
> You've submitted these both individually and as part of a larger nvme
> patchset.  You should know that I generally ignore nvme patch sets (I
> have enough stuff to review), I just happened to catch it this time.
> Submitting these both ways is likely to cause problems down the road,
> including getting me yelled at by Linus when the same patches come from
> two different places.  Please try to avoid that.
> 
> Now, in regards to these two patches, how are you wanting to proceed?
> 

Sorry about that.  My screw up.   I should have just CCed linux-rdma and you
on the original nvme series as it progressed, instead of posting the
iw_cxgb4 patches to linux-rdma separately.  In v4 of the nvme series, which
CCed you and linux-rdma,  I propose that Sagi merge these through the
nvme-fabrics.  I haven't heard back from him on that yet.   So I want to
wait until we hear from him before proceeding.  

Thanks,

Steve

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
