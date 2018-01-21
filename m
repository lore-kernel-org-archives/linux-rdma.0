From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] net/mlx4_en: ensure rx_desc updating reaches HW before
 prod db updating
Date: Sun, 21 Jan 2018 08:43:18 -0800
Message-ID: <1516552998.3478.5.camel@gmail.com>
References: <1515728542-3060-1-git-send-email-jianchao.w.wang@oracle.com>
         <339a7156-9ef1-1f3c-30b8-3cc3558d124e@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <339a7156-9ef1-1f3c-30b8-3cc3558d124e@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>, "jianchao.wang" <jianchao.w.wang@oracle.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: junxiao.bi@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2018-01-21 at 18:24 +0200, Tariq Toukan wrote:
> 
> On 21/01/2018 11:31 AM, Tariq Toukan wrote:
> > 
> > 
> > On 19/01/2018 5:49 PM, Eric Dumazet wrote:
> > > On Fri, 2018-01-19 at 23:16 +0800, jianchao.wang wrote:
> > > > Hi Tariq
> > > > 
> > > > Very sad that the crash was reproduced again after applied the patch.
> 
> Memory barriers vary for different Archs, can you please share more 
> details regarding arch and repro steps?

Yeah, mlx4 NICs in Google fleet receive trillions of packets per
second, and we never noticed an issue.

Although we are using a slightly different driver, using order-0 pages
and fast pages recycling.
