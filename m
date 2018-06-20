From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: cx4 sriov problem in stable 4.14.47
Date: Wed, 20 Jun 2018 20:06:08 +0300
Message-ID: <c74ce55f-e793-1bb2-fe4d-bbd815be4ab2@grimberg.me>
References: <1ae538be-2699-e0cc-adef-2235489472ab@grimberg.me>
 <CAJ3xEMhBueWttc8d_yi+rBCXgrsVUJQci9wEB-KP=OJ6ixur0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMhBueWttc8d_yi+rBCXgrsVUJQci9wEB-KP=OJ6ixur0Q@mail.gmail.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Stable <stable@vger.kernel.org>, Roy Shterman <roys@lightbitslabs.com>
List-Id: linux-rdma@vger.kernel.org


>> Hey folks,
>>
>> Seems that CX4 (Ethernet) sriov ports probe with link down in the latest
>> stable 4.14 kernel. I upgrated firmware but with no luck :(
>>
>> Has anyone seen this issue as well?
>>
>> Kernel: stable 4.14.47
>> Firmware: 12.22.1002
>> psid: MT_2140110033
>>
>> sysfs port state is DOWN and
> 
> do you mean ip link on the pf shows link state down for the vf?

the PF is fine, the VF is down.

>> phys port state is Disabled.
> 
> where do you see it is disabled and what happens if you take the PF
> netdev link up?

Nothing happens if I take it up, the carrier is off. I see the port
phys state via infiniband sysfs (which exposes it from the hca vport
context).

> We had a bug fix there recently [1] -- but it was for the switchdev
> mode not the legacy mode,

It was backported to 4,14 stable...

> are you using the switchdev mode? (if not, I recommend going there, the legacy
> mode is not going to last long)

No, I wasn't sure if it was mature enough in 4.14. And stable backports
don't always propagate immediately...

I'll try switchdev mode.

> Also, FWIW the whole ethernet sriov upstreaming is done in netdev, not rdma
I know, it should have went to netdev... Next time (which I hope won't 
come too soon ;))
