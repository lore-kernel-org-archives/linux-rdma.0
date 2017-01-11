From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: NFSoRDMA Fails for max_sge Less Than 18
Date: Wed, 11 Jan 2017 11:04:35 -0600
Message-ID: <027101d26c2c$c94467f0$5bcd37d0$@opengridcomputing.com>
References: <SN1PR07MB2207F28F05DC6E22B03CC516F8660@SN1PR07MB2207.namprd07.prod.outlook.com> <FE817A76-28A7-4AEC-AF1E-01DE15790E43@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <FE817A76-28A7-4AEC-AF1E-01DE15790E43-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "'Amrani, Ram'" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "'Elior, Ariel'" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "'Kalderon, Michal'" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Hariprasad S' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, 'Faisal Latif' <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Chuck,

> >
> > Browsing the code of other drivers it can be seen that this ability is
either
> hardcoded or is
> > learnt by the driver from the device.
> 
> In the latter case, there's no way for me to know what that
> capability is by looking at kernel code. There's also no way
> for me to know about out-of-tree drivers or pre-release devices.

But shouldn't NFS always limit its sge depths based on ib_device_attr->max_sge?
I don't think it is reasonable to assume any minimum value supported by all
devices...

> 
> It's not feasible for me to stock my lab with more than a
> couple of devices anyway.
> 
> For all these reasons, I rely on HCA vendors for smoke testing
> NFS/RDMA with their devices.
> 
> [1] was posted for review on public mailing lists for weeks. I
> received no review comments or reports of testing successes or
> failures from any vendor, until Broadcom's report in late
> December, three months after [1] appeared in a kernel release
> candidate.
> 
> This may sound like sour grapes, but this is a review and
> testing gap, and I think the community should have the ability
> to address it.
> 
> HCA vendors, especially, have to focus on kernel release
> candidate testing if functional ULPs are a critical release
> criterion for them.
>

You're absolutely right.  I'm querying Chelsio to see how this might have
slipped through the cracks.  Did this initial change land in linux-4.9?  

I have one nit though, your patch series are always very long and thus, to me,
tedious to review.  It would be nice to see 5-8 patches submitted for review vs
15+.

> 
> > If I'm not mistaken, this issue affects nes and
> > cxgb3/4 drivers, and perhaps others.
> 
> ocrdma and Oracle's HCA.
> 
> 
> > E.g., for cxgb4:
> >
> >        #define T4_MAX_RECV_SGE 4
> 
> Yet, without hard-coded max_sge values in kernel drivers, it's
> difficult to say whether 4 is truly the lower bound.
> 
> 
> >        static int c4iw_query_device(struct ib_device *ibdev, struct
ib_device_attr
> *props,
> >                                     struct ib_udata *uhw)
> >        {
> >                ...
> >                props->max_sge = T4_MAX_RECV_SGE;
> >
> > ***

FYI:  cxgb4 supports 4 max for recv wrs, and 17 max for send wrs.  Perhaps 17
avoided any problems for cxgb4 with the original code?

Note: the ib_device_attr only has a max_sge that pertains to both send and recv,
so cxgb4 sets it to the min value.  We should probably add a max_recv_sge and
max_send_sge to ib_device_attr...

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
