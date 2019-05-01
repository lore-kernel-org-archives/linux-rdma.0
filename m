From: Qian Cai <cai@lca.pw>
Subject: Re: mlx5_core failed to load with 5.1.0-rc7-next-20190430+
Date: Wed, 01 May 2019 10:24:35 -0400
Message-ID: <1556720675.6132.15.camel@lca.pw>
References: <bab2ed8b-70dc-4a00-6c68-06a2df6ccb62@lca.pw>
         <CALzJLG-TgHP8tgv_1eqYmWjpO4nRD3=7QRdyGXGp1x_qQdKErg@mail.gmail.com>
         <CALzJLG-5ZXeOrOa3rsVEF0nHrfkxJ=65nEH2H7Sfa9pYyDpmRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALzJLG-5ZXeOrOa3rsVEF0nHrfkxJ=65nEH2H7Sfa9pYyDpmRg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Cc: kliteyn@mellanox.com, ozsh@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Linux Netdev List <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, linux kernel <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2019-04-30 at 20:26 -0700, Saeed Mahameed wrote:
> On Tue, Apr 30, 2019 at 8:00 PM Saeed Mahameed
> <saeedm@dev.mellanox.co.il> wrote:
> > 
> > On Tue, Apr 30, 2019 at 6:23 PM Qian Cai <cai@lca.pw> wrote:
> > > 
> > > Reverted the commit b169e64a2444 ("net/mlx5: Geneve, Add flow table
> > > capabilities
> > > for Geneve decap with TLV options") fixed the problem below during boot
> > > ends up
> > > without networking.
> > > 
> > 
> > Hi Qian, thanks for the report, i clearly see where the issue is,
> > mlx5_ifc_cmd_hca_cap_bits offsets are all off ! due to cited patch,
> > will fix ASAP.
> > 
> 
> Hi Qian, can you please try the following commit :
> 
> [mlx5-next] net/mlx5: Fix broken hca cap offset1093551diffmboxseries
> https://patchwork.ozlabs.org/patch/1093551/
> 
> $ curl -s https://patchwork.ozlabs.org/patch/1093551//mbox/ | git am

Yes, it works great!
