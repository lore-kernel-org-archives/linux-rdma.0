From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Size of Infiniband packets
Date: Thu, 5 Dec 2013 16:53:34 -0700
Message-ID: <20131205235334.GC20137@obsidianresearch.com>
References: <CADPSxAgSdWTkNBF=XEptKU0oVmqiXRVtd-m-c+ntnQyxMzDFNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CADPSxAgSdWTkNBF=XEptKU0oVmqiXRVtd-m-c+ntnQyxMzDFNA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 05, 2013 at 06:22:57PM -0500, Anuj Kalia wrote:

> I'm trying to do a back-of-the-hand calculation of the number of
> packets per second that can be transmitted over 40Gbps Infiniband. I
> need some information about the packet size to do this calculation.
> 
> Suppose I do an 8 byte RDMA write over RC transport. What is the
> packet size that is  transmitted on the wire? This should include
> Infiniband headers and the work request.

See page 257 (Figure 76) of IB Spec volume 1.

A RDMA write will contain:
 LRH 8
 BTH 12
 RETH 16
 data 8 
 ICRC 4 
 VCRC 2

Plus 2 bytes of framing is 52 bytes. IB is defined to sustain
continuous back-to-back packets, so
  3200MB/sec / 52 bytes/packet = 615 million pkts/sec

-- 
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>        (780)4406067x832
Chief Technology Officer, Obsidian Research Corp         Edmonton, Canada
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
