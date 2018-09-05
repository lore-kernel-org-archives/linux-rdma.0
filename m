From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH mlx5-next v1 05/15] net/mlx5: Break encap/decap into two
 separated flow table creation flags
Date: Thu, 6 Sep 2018 00:37:17 +0300
Message-ID: <CAJ3xEMjrrhjCRmnGyD4SYit+pgJpakXLSrF6i35qaZiDfGsAxw@mail.gmail.com>
References: <20180828111854.14367-1-leon@kernel.org> <20180828111854.14367-6-leon@kernel.org>
 <20180904220242.GA3895@ziepe.ca> <20180905051025.GC2977@mtr-leonro.mtl.com>
 <20180905163800.GA21028@ziepe.ca> <20180905181140.GV2977@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180905181140.GV2977@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 5, 2018 at 9:11 PM, Leon Romanovsky  wrote:
> On Wed, Sep 05, 2018 at 10:38:00AM -0600, Jason Gunthorpe wrote:
>> On Wed, Sep 05, 2018 at 08:10:25AM +0300, Leon Romanovsky wrote:
>> > > > -       int en_encap_decap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN);
>> > > > +       int en_encap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN_ENCAP);
>> > > > +       int en_decap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
>> > >
>> > > Yuk, please don't use !!.
>> > >
>> > >   bool en_decap = flags & MLX5_FLOW_TABLE_TUNNEL_EN_DECAP;
>> >
>> > We need to provide en_encap and en_decap as an input to MLX5_SET(...)
>> > which is passed to FW as 0 or 1.
>> >
>> > Boolean type is declared in C as int and treated as zero for false
>> > and any other value for true,
>>
>> No, that isn't right, the kernel uses C99's _Bool intrinsic type, which
>> is guaranteed to only hold 0 or 1 by the compiler.
>>
>> See types.h:
>>
>> typedef _Bool                   bool;
>
> Exciting, it took me a while to find C99 standard and relevant 6.3.1.2.
> Anyway, this patch didn't change previous functionality, which used "!!"
> convention.

so? if we didn't do things properly prior to the patch, why not fixing it along
with the patch? lets fix
