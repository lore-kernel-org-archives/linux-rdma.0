From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [rdma-core v5 0/8]  Broadcom User Space RoCE Driver
Date: Mon, 24 Apr 2017 23:47:05 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB1169E4@ORSMSX109.amr.corp.intel.com>
References: <1493059995-636-1-git-send-email-devesh.sharma@broadcom.com>
 <1493067443.3041.63.camel@redhat.com>
 <20170424215140.GA14907@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170424215140.GA14907-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> However, AFAIK, default pthread mutexes well known to be much slower
> than spinlocks for various cases. They have weird performance aspects
> from the fairness policy on unlock we may not really want.
> 
> Perahps this is why Sean open-coded locks using atomics in rdmacm and
> acm?

I went with open-coded locks based on v-tune (or whatever it's called now -- I should really know this) performance analysis and benchmarking data.  I don't recall the performance gains, but it was definitely measureable.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
