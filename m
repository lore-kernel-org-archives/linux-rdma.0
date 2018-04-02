From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Mon, 2 Apr 2018 09:01:37 -0400
Message-ID: <43a8a11b-50fd-1382-30e3-e9c0a20087b6@codeaurora.org>
References: <CA+55aFxULkhZGhg-tTBBxBBvXbL7QV7f6zvwW7U2wHFijqGEqw@mail.gmail.com>
 <b02cc752d90c5e5ae2cc8cc4f67429a7@codeaurora.org>
 <1522249996.21446.25.camel@kernel.crashing.org>
 <20180328.115509.481837809903086401.davem@davemloft.net>
 <29fe17e0-9978-dc43-d02c-de8fabdc66c2@codeaurora.org>
 <1522374027.21446.64.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1522374027.21446.64.camel@kernel.crashing.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, alexander.duyck@gmail.com, will.deacon@arm.com, arnd@arndb.de, jgg@ziepe.ca, David.Laight@aculab.com, oohall@gmail.com, linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org, alexander.h.duyck@redhat.com, paulmck@linux.vnet.ibm.com, netdev@vger.kernel.org, linus971@gmail.com
List-Id: linux-rdma@vger.kernel.org

On 3/29/2018 9:40 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2018-03-29 at 09:56 -0400, Sinan Kaya wrote:
>> On 3/28/2018 11:55 AM, David Miller wrote:
>>> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>> Date: Thu, 29 Mar 2018 02:13:16 +1100
>>>
>>>> Let's fix all archs, it's way easier than fixing all drivers. Half of
>>>> the archs are unused or dead anyway.
>>>
>>> Agreed.
>>>
>>
>> I pinged most of the maintainers yesterday.
>> Which arches do we care about these days?
>> I have not been paying attention any other architecture besides arm64.
> 
> Thanks for going through that exercise !
> 
> Once sparc, s390, microblaze and mips reply, I think we'll have a good
> coverage, maybe riscv is to put in that lot too.


I posted the following two patches for supporting microblaze and unicore32. 

[PATCH v2 1/2] io: prevent compiler reordering on the default writeX() implementation
[PATCH v2 2/2] io: prevent compiler reordering on the default readX() implementation

The rest of the arches except mips and alpha seem OK.
I sent a question email on Friday to mips and alpha mailing lists. I'll follow up with
an actual patch today.


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
