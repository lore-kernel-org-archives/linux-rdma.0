From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH] iser-target: Fix possible use-after-free in connection
 establishment error
Date: Tue, 9 Jan 2018 19:04:16 +0200
Message-ID: <e11259b7-5add-bf87-73d4-49483c90bf73@mellanox.com>
References: <20171126133104.22710-1-sagi@grimberg.me>
 <3676820c-544e-8ced-859a-ade8e6a0ef53@grimberg.me>
 <BN3PR07MB25782C93E50A7A0C55A110B4F83B0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <eda02d71-cf33-2333-223a-0d6eeabb8185@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <eda02d71-cf33-2333-223a-0d6eeabb8185@grimberg.me>
Content-Language: he
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, "Amrani, Ram" <Ram.Amrani@cavium.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

hi Guys,
did we forget taking this fix to mainline/stable or we found another 
solution ?

On 11/30/2017 12:46 AM, Sagi Grimberg wrote:
> 
>> If it's not already committed, can you add a "Fixes:" so stable 
>> maintainers will catch it?
> 
> I'm not sure at all that there is a clear cut commit that this fixes,
> both the target code and the rdma interface code changed a lot so I
> can't find any clear indication which broke this.
> 
> I can send a separate patch to stable from when we introduced
> ib_drain_qp though.
> -- 
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  
> https://emea01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fvger.kernel.org%2Fmajordomo-info.html&data=02%7C01%7Cmaxg%40mellanox.com%7C18cac1be99bb4d99661c08d5377b08c6%7Ca652971c7d2e4d9ba6a4d149256f461b%7C0%7C0%7C636475923920075321&sdata=WDJ6wr2o8jFyyGdHcLo06EhE18GTz9wUbF%2BezWzkGbc%3D&reserved=0 
> 

-Max.
