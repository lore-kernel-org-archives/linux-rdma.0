From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/23] Update driver to 0.9-294
Date: Wed, 21 Oct 2015 09:36:17 +0300
Message-ID: <CAG9sBKObS=wajYiKArcjjOCVWN7FqvnKRDoeDAo5rNqba48CjQ@mail.gmail.com>
References: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
	<20151019165408.GA30921@kroah.com>
	<2807E5FD2F6FDA4886F6618EAC48510E1CBCA641@CRSMSX101.amr.corp.intel.com>
	<CAG9sBKM+hidZi8i+1=dZowT5Pw+bYq21LHvPPZMqpmxPFNSRug@mail.gmail.com>
	<20151020162910.GA13340@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151020162910.GA13340-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Understood, however, unlike SoftRoCE, qib and hfi currently share a lot of code
> to drive the hardware.
>
> The underlying reason for the TODO item "Remove software processing of IB
> protocol..." is because we have a large amount of duplicated code between these
> drivers.  _Some_ of which, at a high level, is sharable with SoftRoCE.
>
After studying the qib driver (briefly I must admit) I found that it
has a lot in common with SoftRoCE driver and both can be redesigned to
share a fair amount of code.
> These patches (and more to follow), further differentiate the 2 drivers along
> hardware lines.  Accepting these patches will help us make sure that we don't
> create some common code between qib and hfi which, because of our testing we
> now know, needs to be separated out.
>
I'm sorry but I'm not sure that I understand the plan. What we had in
mind is that we start following the idea which was presented by Deny,
build a detailed design plan and implement it. All that can be done
without fixing bugs, adding functionality and improving performance
but I understand that you also need to move forward.
Us, in Mellanox are willing to contribute to the effort and take
responsibility over the Software Verbs Transport.
> This is a separate issue from the higher level code sharing which will be done
> with SoftRoCE.
I'm not sure I agree. Can you explain the plan to remove code sharing
between qib and hfi that is not part of the Software Verbs Transport
module?
>
> Ira
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
