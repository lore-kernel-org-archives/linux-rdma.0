From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH mlx5-next v1 05/15] net/mlx5: Break encap/decap into two
 separated flow table creation flags
Date: Thu, 6 Sep 2018 19:13:56 +0300
Message-ID: <CAJ3xEMjyT_wkAXesdaU2Z_SJbYr8AjrSOir8bVtZ1WxS9+RLUw@mail.gmail.com>
References: <20180828111854.14367-1-leon@kernel.org> <20180828111854.14367-6-leon@kernel.org>
 <20180904220242.GA3895@ziepe.ca> <20180905051025.GC2977@mtr-leonro.mtl.com>
 <20180905163800.GA21028@ziepe.ca> <20180905181140.GV2977@mtr-leonro.mtl.com>
 <CAJ3xEMjrrhjCRmnGyD4SYit+pgJpakXLSrF6i35qaZiDfGsAxw@mail.gmail.com> <20180906040950.GX2977@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180906040950.GX2977@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 6, 2018 at 7:09 AM, Leon Romanovsky <leonro@mellanox.com> wrote:
> On Thu, Sep 06, 2018 at 12:37:17AM +0300, Or Gerlitz wrote:
>> On Wed, Sep 5, 2018 at 9:11 PM, Leon Romanovsky  wrote:
>> > On Wed, Sep 05, 2018 at 10:38:00AM -0600, Jason Gunthorpe wrote:
>> >> On Wed, Sep 05, 2018 at 08:10:25AM +0300, Leon Romanovsky wrote:
>> >> > > > -       int en_encap_decap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN);
>> >> > > > +       int en_encap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN_ENCAP);
>> >> > > > +       int en_decap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
>> >> > >
>> >> > > Yuk, please don't use !!.
>> >> > >
>> >> > >   bool en_decap = flags & MLX5_FLOW_TABLE_TUNNEL_EN_DECAP;
>> >> >
>> >> > We need to provide en_encap and en_decap as an input to MLX5_SET(...)
>> >> > which is passed to FW as 0 or 1.
>> >> >
>> >> > Boolean type is declared in C as int and treated as zero for false
>> >> > and any other value for true,
>> >>
>> >> No, that isn't right, the kernel uses C99's _Bool intrinsic type, which
>> >> is guaranteed to only hold 0 or 1 by the compiler.
>> >>
>> >> See types.h:
>> >>
>> >> typedef _Bool                   bool;
>> >
>> > Exciting, it took me a while to find C99 standard and relevant 6.3.1.2.
>> > Anyway, this patch didn't change previous functionality, which used "!!"
>> > convention.
>>
>> so? if we didn't do things properly prior to the patch, why not fixing it along
>> with the patch? lets fix
>
> Or,
>
> What exactly "to fix"? Both code lines:
> 1. Have correct syntax
> 2. Implement proper C99
> 3. Give same compiler code
> 4. Have same readability
>
> There is nothing to fix.
>
> And this patch is already merged, so if you truly care about this,
> please go ahead and prepare patch for whole driver, or better for
> whole kernel.

slow down, I was just supporting Jason's suggestion and said there's
no reason not to follow it.

If you don't agree with Jason, argue with him.

>  kernel git:(rdma-next) git grep "\!\!" |wc -l
> 8125
