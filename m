From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: RFC: CQ pools and implicit CQ resource allocation
Date: Mon, 12 Sep 2016 09:42:41 -0500
Message-ID: <00e001d20d03$ea891100$bf9b3300$@opengridcomputing.com>
References: <1473424587-13818-1-git-send-email-hch@lst.de> <d0c645eb-3674-2841-bdb7-8b9e6fd46473@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d0c645eb-3674-2841-bdb7-8b9e6fd46473-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> > This series adds support to the RDMA core to implicitly allocate the
required
> > CQEs when creating a QP.  The primary driver for that was to implement a
> > common scheme for CQ pooling, which helps with better resource usage for
> > server / target style drivers that have many outstanding connections.  In
> > fact the first version of this code from Sagi did just that: add a CQ pool
> > API, and convert drivers that were using some form of pooling (iSER
initiator
> > & target, NVMe target) to that API.  But looking at the API I felt that
> > there was still way too much logic in the individual ULPs, and looked into a
> > way to make that boilerplate code go away.  It turns out that we can simply
> > create CQs underneath if we know the poll context that the ULP requires, so
> > this series shows an approach that makes CQs mostly invisible to ULPs.
> 
> One other note that I wanted to raise for the folks interested in this
> is that with the RDMA core owning the completion queue pools, different
> ULPs can easily share the same completion queue (given that it uses
> the same poll context). For example, nvme-rdma host, iser and srp
> initiators can end up using the same completion queues (if running
> simultaneously on the same machine).
> 
> Up until now, I couldn't think of anything that can introduce a problem
> with that but maybe someone else will...

It would be useful to provide details on how many CQs get created and of what
size for an uber iSER/NVMF/SRP initiator/host and target.   

One concern I have is that cxgb4 CQs require contiguous memory,  So a scheme
like CQ pooling might cause resource problems on large core systems.   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
