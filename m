From: Christoph Hellwig <hch@lst.de>
Subject: Re: generic RDMA READ/WRITE API V6
Date: Tue, 3 May 2016 10:40:13 +0200
Message-ID: <20160503084013.GA18906@lst.de>
References: <1460410360-13104-1-git-send-email-hch@lst.de> <571AA5C8.4080502@sandisk.com> <20160502151535.GA520@lst.de> <5727A5C7.1090009@sandisk.com> <5727D14A.8040600@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5727D14A.8040600@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, "dledford@redhat.com" <dledford@redhat.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "sagi@grimberg.me" <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 02, 2016 at 03:14:34PM -0700, Bart Van Assche wrote:
> I just noticed that ib_comp_wq is created as follows:
>
> 	ib_comp_wq = alloc_workqueue("ib-comp-wq",
> 			WQ_UNBOUND | WQ_HIGHPRI | WQ_MEM_RECLAIM,
> 			WQ_UNBOUND_MAX_ACTIVE);
>
> I think this breaks the locking guarantees for completion handlers. A quote 
> from Documentation/infiniband/core_locking.txt: "The driver must guarantee 
> that only one CQ event handler for a given CQ is running at a time." The 
> ib_srpt driver assumes that completion handler invocations are serialized 
> such that no locking is needed to access wait_list from inside a completion 
> handler.

This should still be the case - the max_active argument to alloc_workqueue
just specified the amount of work_structs that may be exectured on the
workqueue concurrently, but each individual work_struct can only be
excuted once at a time.  See the following paragraph in
Documentation/workqueue.txt:

"Note that the flag WQ_NON_REENTRANT no longer exists as all workqueues
 are now non-reentrant - any work item is guaranteed to be executed by
 at most one worker system-wide at any given time."
