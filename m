From: Mark Bloch <markb@mellanox.com>
Subject: Re: [PATCH rdma-rc 1/2] IB/core: Only enforce security for InfiniBand
Date: Tue, 21 Nov 2017 17:33:04 +0200
Message-ID: <3eff140b-8f0f-1c4f-07b7-9dec46090a1e@mellanox.com>
References: <20171121102618.31216-1-leon@kernel.org>
 <20171121102618.31216-2-leon@kernel.org>
 <4f5268b5-e5b6-a7d9-2096-70b4ae8facaf@mellanox.com>
 <20171121132215.GU18825@mtr-leonro.local>
 <9bb92ec4-d29f-55b7-d3ba-33bfe451ea6c@mellanox.com>
 <20171121151409.GA29826@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171121151409.GA29826@mellanox.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Daniel Jurgens <danielj@mellanox.com>, Paul Moore <paul@paul-moore.com>, Don Dutile <ddutile@redhat.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 21/11/2017 17:14, Jason Gunthorpe wrote:
> On Tue, Nov 21, 2017 at 03:56:19PM +0200, Mark Bloch wrote:
> 
>> I just gave mlx4 as an example, but I was talking more about the ability of the RDMA
>> subsystem to support mixed port types, so in this case, if in the future a vendor
>> will come with an ib_device with 2 ports, one is IB and one is iWARP bad things will happen.
> 
> That will never be allowed.
> 

You say never be allowed, I say code talks, and in the code we don't have this restriction.
maybe we should add something?

LSM security enforcement should only take place on IB devices, Daniel's comment even says that:

> +	/* If this isn't an IB device don't create the security context */
> +	if (!is_ib)
> +		return 0;

but how do we define an ib device with different port types?
also while today we only deal with pkeys (if I remember currently) in the future
we might add other bits, and those bits might not play nicely in the that configuration.

Maybe we should make sure all the ports are IB, and if not, flag it to the user (dmesg?)

> Even mixing roce and IB on the same device should be banned, IMHO.

> If APM does not work between the ports then they do not belong on the
> same device.
> 
> Jason
> 

Mark.
