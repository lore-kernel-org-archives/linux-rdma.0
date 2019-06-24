From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] IB/hfi1: Avoid hardlockup with flushlist_lock
Date: Mon, 24 Jun 2019 16:17:24 -0400
Message-ID: <20190624201724.GA3881@sasha-vm>
References: <20190624161428.17461.31880.stgit@awfm-01.aw.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190624161428.17461.31880.stgit@awfm-01.aw.intel.com>
Sender: stable-owner@vger.kernel.org
To: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: stable@vger.kernel.org, linux-rdma@vger.kernel.org, stable-commits@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 24, 2019 at 12:14:29PM -0400, Mike Marciniszyn wrote:
>commit cf131a81967583ae737df6383a0893b9fee75b4e upstream.
>
>Heavy contention of the sde flushlist_lock can cause hard lockups at
>extreme scale when the flushing logic is under stress.
>
>Mitigate by replacing the item at a time copy to the local list with
>an O(1) list_splice_init() and using the high priority work queue to
>do the flushes.
>
>Ported to linux-4.14.y.

I've queued this one for 4.19 and 4.14, thank you.
