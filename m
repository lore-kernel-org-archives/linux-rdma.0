From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: Poll CQ syncing problem
Date: Wed, 1 Mar 2017 15:51:24 +0100
Message-ID: <20170301145124.GA12121@lst.de>
References: <b4355d22-fc79-c860-de8a-5a4d468c884d@mellanox.com> <3ba1baab-e2ac-358d-3b3b-ff4a27405c93@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3ba1baab-e2ac-358d-3b3b-ff4a27405c93-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 01, 2017 at 04:30:26PM +0200, Noa Osherovich wrote:
> Analysis:
> Since ib_comp_wq isn't single threaded, two works can run in parallel for the same CQ,
> executing __ib_process_cq.

They shouldn't.  Each CQ has a single work_struct, and any given work_struct
should only be executing at once:

"Note that the flag ``WQ_NON_REENTRANT`` no longer exists as all
workqueues are now non-reentrant - any work item is guaranteed to be
executed by at most one worker system-wide at any given time."

> Since this function isn't thread safe and the wc array is shared, it causes a data corruption
> which eventually crashes in the MAD layer due to a double list_del of the same element.

This should not be the case.  What kernel version are you testing and does
it contain any patches touching core kernel code?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
