From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH for-next 10/10] IB/iser: Support the remote invalidation
 exception
Date: Tue, 17 Nov 2015 11:53:45 +0200
Message-ID: <564AF929.60209@dev.mellanox.co.il>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-11-git-send-email-sagig@mellanox.com>
 <564ADFCC.4030109@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <564ADFCC.4030109@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



On 17/11/2015 10:05, Or Gerlitz wrote:
> On 11/16/2015 6:37 PM, Sagi Grimberg wrote:
>> +            if (iser_task->dir[ISER_DIR_IN])
>> +                reg = &iser_task->rdma_reg[ISER_DIR_IN];
>> +            else
>> +                reg = &iser_task->rdma_reg[ISER_DIR_OUT];
>
> and what happens with bidirectional commands?!

It won't work, iSER lacks support for bidirectional commands for as
long as I'm involved with it and until we either decide that we care
enough to implement it both in the target and initiator sides or some
array with iser bidi support shows up I don't know how much its worth
our attention.

Thoughts?
