From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH mlx5-next v1 2/8] net/mlx5: Add support for flow table
 destination number
Date: Fri, 13 Jul 2018 00:51:10 +0300
Message-ID: <CAJ3xEMg-cfRwZTwK2Eu2cdH1YuSF5rJy88YWYrbyWywKun5hPg@mail.gmail.com>
References: <20180711111045.6282-1-leon@kernel.org> <20180711111045.6282-3-leon@kernel.org>
 <CAJ3xEMgFknMqJq=BY9SxWpPJDrm1BYBVfQWzyhYk5cdELsaoRQ@mail.gmail.com> <20180712212618.GS30390@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180712212618.GS30390@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 13, 2018 at 12:26 AM, Jason Gunthorpe <jgg@mellanox.com> wrote:
> On Fri, Jul 13, 2018 at 12:00:41AM +0300, Or Gerlitz wrote:
>> On Wed, Jul 11, 2018 at 2:10 PM, Leon Romanovsky <leon@kernel.org> wrote:
>> > From: Yishai Hadas <yishaih@mellanox.com>
>> >
>> > Add support to set a destination from a flow table number.
>> > This functionality will be used in downstream patches from this
>> > series by the DEVX stuff.
>>
>> Reading your cover letter, I still don't understand what is missing
>> in the current mlx5 fs core API for your needs. After all, you do
>> create flow tables from the IB driver through fs core calls, right?
>> so @ the end of the day, you have the FT pointer to provide the
>> core, why you need the FT number?
>
> Via the devx API userspace can create flow tables directly without
> going to the driver's flow steering core.

so why you change the core?
