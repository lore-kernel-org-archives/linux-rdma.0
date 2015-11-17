From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH for-next 02/10] IB/iser: Default to fastreg instead of fmr
Date: Tue, 17 Nov 2015 12:09:26 +0200
Message-ID: <564AFCD6.309@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-3-git-send-email-sagig@mellanox.com>
 <564ADA1C.4090905@mellanox.com> <564AF4CB.9060302@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <564AF4CB.9060302@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

On 11/17/2015 11:35 AM, Sagi Grimberg wrote:
>> On 11/16/2015 6:37 PM, Sagi Grimberg wrote:
>>> This is a pre-step before adding remote invalidate support.
>>
>> Wouldn't that introduce performance regression on ConnectX3 devices?
>
> With remote invalidate it shouldn't make much of a difference. 

Why? the invalidate is just one part of the story, we are doing a 
mapping on IO submission
and CX3 has strong ordering on FRWRs, right?

> Plus, I'd really like us to start phasing out from FMRs... 

We should make sure not to introduce performance regression for HW which 
has
such a big existing install base and is well selling in 2015/16
