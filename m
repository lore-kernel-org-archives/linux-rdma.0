From: Noa Osherovich <noaos@mellanox.com>
Subject: Re: Poll CQ syncing problem
Date: Wed, 1 Mar 2017 17:28:41 +0200
Message-ID: <67049755-56c9-d2ba-c7c1-4a1593a5706f@mellanox.com>
References: <b4355d22-fc79-c860-de8a-5a4d468c884d@mellanox.com>
 <3ba1baab-e2ac-358d-3b3b-ff4a27405c93@mellanox.com>
 <20170301145124.GA12121@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170301145124.GA12121@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: sagi@grimberg.me, linux-rdma@vger.kernel.org, Majd Dibbiny <majd@mellanox.com>, tj@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 3/1/2017 4:51 PM, Christoph Hellwig wrote:

> On Wed, Mar 01, 2017 at 04:30:26PM +0200, Noa Osherovich wrote:
>> Analysis:
>> Since ib_comp_wq isn't single threaded, two works can run in parallel for the same CQ,
>> executing __ib_process_cq.
> They shouldn't.  Each CQ has a single work_struct, and any given work_struct
> should only be executing at once:
>
> "Note that the flag ``WQ_NON_REENTRANT`` no longer exists as all
> workqueues are now non-reentrant - any work item is guaranteed to be
> executed by at most one worker system-wide at any given time."
>
>> Since this function isn't thread safe and the wc array is shared, it causes a data corruption
>> which eventually crashes in the MAD layer due to a double list_del of the same element.
> This should not be the case.  What kernel version are you testing and does
> it contain any patches touching core kernel code?

Thanks Christoph for the quick response.

Currently we see this only in old kernels. I'll investigate this more and update.
