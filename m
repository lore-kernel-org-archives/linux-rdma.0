From: Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/2] IB/core: Only enforce security for InfiniBand
Date: Tue, 21 Nov 2017 13:15:31 -0500
Message-ID: <f60834d5-1a48-55f2-271d-de5b34966233@redhat.com>
References: <20171121102618.31216-1-leon@kernel.org>
 <20171121102618.31216-2-leon@kernel.org>
 <4f5268b5-e5b6-a7d9-2096-70b4ae8facaf@mellanox.com>
 <20171121132215.GU18825@mtr-leonro.local>
 <9bb92ec4-d29f-55b7-d3ba-33bfe451ea6c@mellanox.com>
 <20171121151409.GA29826@mellanox.com>
 <3eff140b-8f0f-1c4f-07b7-9dec46090a1e@mellanox.com>
 <410e7b54-02f5-849c-e3ad-56cc61f66647@mellanox.com>
 <20171121160442.GB18272@ziepe.ca> <20171121163454.GW18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121163454.GW18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/21/2017 11:34 AM, Leon Romanovsky wrote:
> On Tue, Nov 21, 2017 at 09:04:42AM -0700, Jason Gunthorpe wrote:
>> On Tue, Nov 21, 2017 at 09:37:27AM -0600, Daniel Jurgens wrote:
>>
>>> The only warning that would make sense is if the mixed ports aren't
>>> all IB or RoCE. As you note, CX-3 can mix those two, we don't want to
>>> see warnings about that.
>>
>> I would really like to see cx3 be changed to not do that, then we
>> could finalize this issue upstream: All device ports must be the same
>> protocol.
>
> I don't see the point of such artificial limitation, the users who
> brought CX-3 have option to work in mixed mode and IMHO it is not right
> to deprecate such ability just because it is hard for us to code for it.
>
We use cx-3 (& cx-4 & cx-5) in mixed mode all over our RDMA cluster.
Loosing that feature is not an option.

> Thanks
>
>>
>> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
