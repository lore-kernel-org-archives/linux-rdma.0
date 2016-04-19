From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
Date: Tue, 19 Apr 2016 15:26:37 -0500
Message-ID: <01e001d19a79$c6349470$529dbd50$@opengridcomputing.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de> <1460410360-13104-3-git-send-email-hch@lst.de> <20160419031425.GB27515@rhel.amr.corp.intel.com> <20160419173032.GD20844@obsidianresearch.com> <57167D9F.9060808@grimberg.me> <20160419192430.GB27028@obsidianresearch.com> <01a901d19a73$82ad7f60$88087e20$@opengridcomputing.com> <20160419200555.GA2561@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160419200555.GA2561-jcswGhMUV9g@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Ira Weiny' <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: 'Christoph Hellwig' [mailto:hch-jcswGhMUV9g@public.gmane.org]
> Sent: Tuesday, April 19, 2016 3:06 PM
> To: Steve Wise
> Cc: 'Jason Gunthorpe'; 'Sagi Grimberg'; 'Ira Weiny'; 'Christoph Hellwig';
> dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 02/12] IB/cma: pass the port number to ib_create_qp
> 
> I can offer a trade:  once this series is accepted I'll clean
> up all the port_num arguments in the protocol checks over the whole
> tree :)

I will help as needed.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
