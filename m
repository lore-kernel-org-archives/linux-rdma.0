From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] IB/core: correctly handle rdma_rw_init_mrs() failure
Date: Thu, 29 Sep 2016 09:41:31 -0500
Message-ID: <004501d21a5f$91caad80$b5600880$@opengridcomputing.com>
References: <20160929143217.F2C8DE0BD1@smtp.ogc.us> <0a65038a-f708-1e0b-fbd0-018ccb6af03f@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0a65038a-f708-1e0b-fbd0-018ccb6af03f-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Bart Van Assche [mailto:bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org]
> Sent: Thursday, September 29, 2016 9:40 AM
> To: Steve Wise; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Christoph Hellwig
> Subject: Re: [PATCH] IB/core: correctly handle rdma_rw_init_mrs() failure
> 
> On 09/29/16 07:32, Steve Wise wrote:
> > Fixes: 632bc3f65081 ("IB/core, RDMA RW API: Do not exceed QP SGE send limit")
> 
> This is not correct. I think the "qp = ERR_PTR(ret)" code was introduced
> by commit a060b5629ab06 ("IB/core: generic RDMA READ/WRITE API").
> 
> Bart.

It was, but at that time, the only thing that happened next was: 

return qp;

With 632bc3f65081, qp is dereferenced causing the crash...

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
