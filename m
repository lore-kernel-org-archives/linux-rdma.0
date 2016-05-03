From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: generic RDMA READ/WRITE API V6
Date: Tue, 3 May 2016 09:10:11 -0700
Message-ID: <5728CD63.2090100@sandisk.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <571AA5C8.4080502@sandisk.com> <20160502151535.GA520@lst.de>
 <5727A5C7.1090009@sandisk.com> <5727D14A.8040600@sandisk.com>
 <20160503084013.GA18906@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160503084013.GA18906@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "sagi@grimberg.me" <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 05/03/2016 01:40 AM, Christoph Hellwig wrote:
> This should still be the case - the max_active argument to alloc_workqueue
> just specified the amount of work_structs that may be executed on the
> workqueue concurrently, but each individual work_struct can only be
> executed once at a time.  See the following paragraph in
> Documentation/workqueue.txt:
>
> "Note that the flag WQ_NON_REENTRANT no longer exists as all workqueues
>   are now non-reentrant - any work item is guaranteed to be executed by
>   at most one worker system-wide at any given time."

Thanks for the feedback. I had overlooked the 
find_worker_executing_work() call in __queue_work() in 
kernel/workqueue.c when I reviewed that code yesterday.

Bart.
