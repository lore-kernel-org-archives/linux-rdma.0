From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/2] IB/core: Only enforce security for InfiniBand
Date: Tue, 21 Nov 2017 09:37:27 -0600
Message-ID: <410e7b54-02f5-849c-e3ad-56cc61f66647@mellanox.com>
References: <20171121102618.31216-1-leon@kernel.org>
 <20171121102618.31216-2-leon@kernel.org>
 <4f5268b5-e5b6-a7d9-2096-70b4ae8facaf@mellanox.com>
 <20171121132215.GU18825@mtr-leonro.local>
 <9bb92ec4-d29f-55b7-d3ba-33bfe451ea6c@mellanox.com>
 <20171121151409.GA29826@mellanox.com>
 <3eff140b-8f0f-1c4f-07b7-9dec46090a1e@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3eff140b-8f0f-1c4f-07b7-9dec46090a1e-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/21/2017 9:33 AM, Mark Bloch wrote:
>
> On 21/11/2017 17:14, Jason Gunthorpe wrote:
>> On Tue, Nov 21, 2017 at 03:56:19PM +0200, Mark Bloch wrote:
>>
>>> I just gave mlx4 as an example, but I was talking more about the ability of the RDMA
>>> subsystem to support mixed port types, so in this case, if in the future a vendor
>>> will come with an ib_device with 2 ports, one is IB and one is iWARP bad things will happen.
>> That will never be allowed.
>>
> You say never be allowed, I say code talks, and in the code we don't have this restriction.
> maybe we should add something?
>
> LSM security enforcement should only take place on IB devices, Daniel's comment even says that:
>
>> +	/* If this isn't an IB device don't create the security context */
>> +	if (!is_ib)
>> +		return 0;
> but how do we define an ib device with different port types?
> also while today we only deal with pkeys (if I remember currently) in the future
> we might add other bits, and those bits might not play nicely in the that configuration.
>
> Maybe we should make sure all the ports are IB, and if not, flag it to the user (dmesg?)

The only warning that would make sense is if the mixed ports aren't all IB or RoCE. As you note, CX-3 can mix those two, we don't want to see warnings about that.

>
>> Even mixing roce and IB on the same device should be banned, IMHO.
>> If APM does not work between the ports then they do not belong on the
>> same device.
>>
>> Jason
>>
> Mark.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
