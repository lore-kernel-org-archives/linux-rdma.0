From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ib-diags: compatability issue with ibstat
Date: Fri, 23 Sep 2011 10:57:58 -0600
Message-ID: <20110923165758.GM28454@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E66F5B@ORSMSX101.amr.corp.intel.com>
 <20110921151349.140d95f6.weiny2@llnl.gov>
 <1828884A29C6694DAF28B7E6B8A8237316E6723E@ORSMSX101.amr.corp.intel.com>
 <20110921153254.06c77ebc.weiny2@llnl.gov>
 <20110921223546.GI28454@obsidianresearch.com>
 <CAKzyTsw8TKFNPS8QFgjag7XZ77cu=OzofAuAKTr_DQmkPTsogw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKzyTsw8TKFNPS8QFgjag7XZ77cu=OzofAuAKTr_DQmkPTsogw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 23, 2011 at 08:57:12AM -0400, Hal Rosenstock wrote:

> > Technically umad already needs to use verbs on Linux because that is
> > the only way to get the subnet timeout value that is needed to compute
> > the MAD RPC timeout. Currently umad ignores this part of IBA ...
> 
> Determining the MAD timeout is more complicated than this. Subnet
> timeout is insufficient (so you would need more than just this from
> verbs - things that would not be part of verbs) if this mechanism were
> to be made compliant rather than a configurable timeout as it is now.

I didn't have any problem with this in python-rdma. The only wonky bit
was that verbs was needed for subnet timeout because it isn't in
sysfs. Everything else went according to the spec.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
