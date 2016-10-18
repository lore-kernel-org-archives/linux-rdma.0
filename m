From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: SQ overflow seen running isert traffic
Date: Tue, 18 Oct 2016 16:17:53 +0300
Message-ID: <ed7ebb39-be81-00b3-ef23-3f4c0e3afbb1@grimberg.me>
References: <20160927070157.GA13140@chelsio.com>
 <672d8b05-5537-d45a-ba3f-cdd5f054a4ab@grimberg.me>
 <20161017111655.GA21245@chelsio.com>
 <021001d228a4$6cd6a6c0$4683f440$@opengridcomputing.com>
 <c4ee3313-9e67-f30a-3679-4c9afab79ac9@grimberg.me>
 <20161018112801.GA3117@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20161018112801.GA3117@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Potnuri Bharat Teja <bharat@chelsio.com>
Cc: Steve Wise <swise@opengridcomputing.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


> I tried out this change and it works fine with iwarp. I dont see SQ
> overflow. Apparently we have increased the sq too big to overflow. I am going
> to let it run with higher workloads for longer time, to see if it holds good.

Actually on second thought, this patch is an overkill. Effectively we
now set:

MAX_CMD=266
and max_rdma_ctx=128 so together we take 394 which seems to too much.

If we go by the scheme of 1 rdma + 1 send for each IO we need:
- 128 sends
- 128 rdmas
- 10 miscs

so this gives 266.

Perhaps this is due to the fact that iWARP needs to register memory for
rdma reads as well? (and also rdma writes > 128k for chelsio HW right?)

What is the workload you are running? with immediatedata enabled you
should issue reg+rdma_read+send only for writes > 8k.

Does this happen when you run only reads for example?

I guess its time to get the sq accounting into shape...
