From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/qib: Support creating qps with GFP_NOIO flag
Date: Mon, 11 Jan 2016 13:15:56 -0500
Message-ID: <D5AC124A-B1A1-4487-B781-751FE3612A50@oracle.com>
References: <20160111175725.743.92967.stgit@phlsvslse11.ph.intel.com> <20160111181354.GA19166@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160111181354.GA19166-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> On Jan 11, 2016, at 1:13 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> 
> On Mon, Jan 11, 2016 at 12:57:25PM -0500, Mike Marciniszyn wrote:
>> From: Vinit Agnihotri <vinit.abhay.agnihotri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> 
>> The current code is problematic when the QP creation and ipoib is used to
>> support NFS and NFS desires to do IO for paging purposes. In that case, the
>> GFP_KERNEL allocation in qib_qp.c causes a deadlock in tight memory
>> situations.
> 
> Are you trying to do swap over NFS? I didn't think that worked
> reliably, or has that changed?

Swap on NFS is officially supported. Mel Gorman put in some
work a while back to get it in shape.


> It doesn't make much sense for one driver to have a different GFP
> policy for some calls compared with other drivers. Are you sure the
> GFP agrument shouldn't be pushed up to the real caller?

--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
