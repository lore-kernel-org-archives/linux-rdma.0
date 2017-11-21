From: Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH rdma-rc 1/2] IB/core: Only enforce security for InfiniBand
Date: Tue, 21 Nov 2017 13:16:43 -0500
Message-ID: <fa4b7d56-5617-2b9f-65dc-386ab69c4e8f@redhat.com>
References: <20171121102618.31216-2-leon@kernel.org>
 <4f5268b5-e5b6-a7d9-2096-70b4ae8facaf@mellanox.com>
 <20171121132215.GU18825@mtr-leonro.local>
 <9bb92ec4-d29f-55b7-d3ba-33bfe451ea6c@mellanox.com>
 <20171121151409.GA29826@mellanox.com>
 <3eff140b-8f0f-1c4f-07b7-9dec46090a1e@mellanox.com>
 <410e7b54-02f5-849c-e3ad-56cc61f66647@mellanox.com>
 <20171121160442.GB18272@ziepe.ca> <20171121163454.GW18825@mtr-leonro.local>
 <20171121163648.GC18272@ziepe.ca> <20171121164802.GY18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171121164802.GY18825@mtr-leonro.local>
Sender: stable-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Daniel Jurgens <danielj@mellanox.com>, Mark Bloch <markb@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Paul Moore <paul@paul-moore.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 11/21/2017 11:48 AM, Leon Romanovsky wrote:
> On Tue, Nov 21, 2017 at 09:36:48AM -0700, Jason Gunthorpe wrote:
>> On Tue, Nov 21, 2017 at 06:34:54PM +0200, Leon Romanovsky wrote:
>>> On Tue, Nov 21, 2017 at 09:04:42AM -0700, Jason Gunthorpe wrote:
>>>> On Tue, Nov 21, 2017 at 09:37:27AM -0600, Daniel Jurgens wrote:
>>>>
>>>>> The only warning that would make sense is if the mixed ports aren't
>>>>> all IB or RoCE. As you note, CX-3 can mix those two, we don't want to
>>>>> see warnings about that.
>>>>
>>>> I would really like to see cx3 be changed to not do that, then we
>>>> could finalize this issue upstream: All device ports must be the same
>>>> protocol.
>>>
>>> I don't see the point of such artificial limitation, the users who
>>> brought CX-3 have option to work in mixed mode and IMHO it is not right
>>> to deprecate such ability just because it is hard for us to code for it.
>>
>> I don't really think it is really too user visible.. Only the device
>> and port number change, but only if running in mixed mode.
>
> Ahh, correct me if I'm wrong, you are proposing to split mlx4_ib devices
> to two devices once it is configured in mixed mode, so everyone will
> have one port only. Did I understand you correctly?
>
Which would require splitting resources that are shared now? other splitting issue(s)?

>>
>> It is not just 'hard for us' it is impossible to reconcile the
>> differences between ports when enforcing device level things.
>>
>> This keeps coming up again and again..
>>
>> Jason
