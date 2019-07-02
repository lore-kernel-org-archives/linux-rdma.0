From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [for-next V2 10/10] RDMA/core: Provide RDMA DIM support for ULPs
Date: Mon, 1 Jul 2019 22:36:41 -0700
Message-ID: <9d26c90c-8e0b-656f-341f-a67251549126@grimberg.me>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-11-saeedm@mellanox.com>
 <adb3687a-6db3-b1a4-cd32-8b4889550c81@grimberg.me>
 <AM5PR0501MB248327B260F97EF97CD5B80EC5E20@AM5PR0501MB2483.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <AM5PR0501MB248327B260F97EF97CD5B80EC5E20@AM5PR0501MB2483.eurprd05.prod.outlook.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Idan Burstein <idanb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Tal Gilboa <talgi@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yamin Friedman <yaminf@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hey Idan,

> " Please don't. This is a bad choice to opt it in by default."
> 
> I disagree here. I'd prefer Linux to have good out of the box experience (e.g. reach 100G in 4K NVMeOF on Intel servers) with the default parameters. Especially since Yamin have shown it is beneficial / not hurting in terms of performance for variety of use cases. The whole concept of DIM is that it adapts to the workload requirements in terms of bandwidth and latency.

Well, its a Mellanox device driver after all.

But do note that by far, the vast majority of users are not saturating
100G of 4K I/O. The absolute vast majority of users are primarily
sensitive to synchronous QD=1 I/O latency, and when the workload
is much more dynamic than the synthetic 100%/50%/0% read mix.

As much as I'm a fan (IIRC I was the one giving a first pass at this),
the dim default opt-in is not only not beneficial, but potentially
harmful to the majority of users out-of-the-box experience.

Given that this is a fresh code with almost no exposure, and that was
not tested outside of Yamin running limited performance testing, I think
it would be a mistake to add it as a default opt-in, that can come as an
incremental stage.

Obviously, I cannot tell what Mellanox should/shouldn't do in its own
device driver of course, but I just wanted to emphasize that I think
this is a mistake.

> Moreover, net-dim is enabled by default, I don't see why RDMA is different.

Very different animals.
