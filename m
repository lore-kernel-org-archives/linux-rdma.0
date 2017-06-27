From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Tue, 27 Jun 2017 10:16:34 +0300
Message-ID: <16585005-1e1c-0090-6cf7-bc647e892541@grimberg.me>
References: <9465cd0c-83db-b058-7615-5626ef60dbb0@grimberg.me>
 <20170515143632.GH3616@mtr-leonro.local>
 <20170515145952.GA7871@infradead.org>
 <20170515170506.GK3616@mtr-leonro.local>
 <779753075.36035391.1495025796237.JavaMail.zimbra@kalray.eu>
 <20170518133439.GD3616@mtr-leonro.local>
 <CAANLjFrCLpX3nb3q7LpFPpLJKciU+1Hvmt_hxyTovQJM2-zQmg@mail.gmail.com>
 <6073e553-e8c2-6d14-ba5d-c2bd5aff15eb@grimberg.me>
 <20170620074639.GP17846@mtr-leonro.local>
 <1c706958-992e-b104-6bae-4a6616c0a9f9@grimberg.me>
 <20170620083309.GQ17846@mtr-leonro.local>
 <bd0b986f-9bed-3dfa-7454-0661559a527b@grimberg.me>
 <78b2c1db-6ece-0274-c4c9-5ee1f7c88469@mellanox.com>
 <CAANLjFrzsTFZP536L2G2CHy=JmDb3W+ePB_mOLHm2qp2Bb2iaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAANLjFrzsTFZP536L2G2CHy=JmDb3W+ePB_mOLHm2qp2Bb2iaw@mail.gmail.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>, Max Gurtovoy <maxg@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>, Marta Rybczynska <mrybczyn@kalray.eu>, Christoph Hellwig <hch@infradead.org>, "Gruher, Joseph R" <joseph.r.gruher@intel.com>, "shahar.salzman" <shahar.salzman@gmail.com>, Laurence Oberman <loberman@redhat.com>, "Riches Jr, Robert M" <robert.m.riches.jr@intel.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-nvme@lists.infradead.org, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Liran Liss <liranl@mellanox.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


> I still get the local protection errors with this patch. I am seeing a
> ping timeout on the initiator when I reboot the target.
> [Tue Jun 20 16:41:21 2017]  connection7:0: detected conn error (1011)
> [Tue Jun 20 16:41:26 2017]  session7: session recovery timed out after 5 secs
> 

Not a big surprise as its not really addressing the issue...

> Since I'm gracefully shutting down the targets in this case, shouldn't
> the connection be closed gracefully by the target instead of the
> initiator having to wait for ping to fail?

Not really, even in orderly shutdown, the device driver (mlx5 in
this case) shutdown sequence is triggered before ib_isert and
fires DEVICE_REMOVAL events to all its upper layer users (ib_isert
being one of them), which forces resource teardown (no disconnect).

We could resgister a shutdown handler in ib_isert, but its not really
its responsibility as a transport driver..

It would be nice if we had targetcli daemon'ised as a service
and register a shutdown notification, orderly remove and save the
existing configuration before the kernel even sees it. But its
a different scope really...

CC'ing target-devel
