From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH for-next 08/10] iser-target: Support the remote
 invalidation exception
Date: Tue, 17 Nov 2015 12:16:45 +0200
Message-ID: <564AFE8D.5040209@dev.mellanox.co.il>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-9-git-send-email-sagig@mellanox.com>
 <564AE0C6.2030203@mellanox.com> <564AF857.5090701@dev.mellanox.co.il>
 <20151117101444.GA2569@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20151117101444.GA2569@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



On 17/11/2015 12:14, Christoph Hellwig wrote:
> On Tue, Nov 17, 2015 at 11:50:15AM +0200, Sagi Grimberg wrote:
>>
>>
>> On 17/11/2015 10:09, Or Gerlitz wrote:
>>> On 11/16/2015 6:37 PM, Sagi Grimberg wrote:
>>>> We'll use remote invalidate, according to negotiation result
>>>> during connection establishment. If the initiator declared that
>>>> it supports the remote invalidate exception then the target will
>>>> use IB_WR_SEND_WITH_INV with the correct rkey for the response.
>>>
>>> same comment as the one I posted for the initiator patch, check for
>>> IB_DEVICE_MEM_MGT_EXTENSIONS
>>
>> SEND_WITH_INV doesn't have anything to do with
>> IB_DEVICE_MEM_MGT_EXTENSIONS does it? What is the relations between
>> the device capability to do FRWR and invalidating a remote rkey?
>
> Both FRs and SEND_WITH_INV are part of the base memory management
> extensions and also required for iWarp.

Thanks for clarifying. I'll add the check.
