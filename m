From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [rdma-core v5 0/8]  Broadcom User Space RoCE Driver
Date: Tue, 25 Apr 2017 09:28:43 -0600
Message-ID: <20170425152843.GA17680@obsidianresearch.com>
References: <1493059995-636-1-git-send-email-devesh.sharma@broadcom.com>
 <1493067443.3041.63.camel@redhat.com>
 <20170424215140.GA14907@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB1169E4@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB1169E4-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 24, 2017 at 11:47:05PM +0000, Hefty, Sean wrote:
> > However, AFAIK, default pthread mutexes well known to be much slower
> > than spinlocks for various cases. They have weird performance aspects
> > from the fairness policy on unlock we may not really want.
> > 
> > Perahps this is why Sean open-coded locks using atomics in rdmacm and
> > acm?
> 
> I went with open-coded locks based on v-tune (or whatever it's
> called now -- I should really know this) performance analysis and
> benchmarking data.  I don't recall the performance gains, but it was
> definitely measureable.

But libfabric uses pthreads?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
