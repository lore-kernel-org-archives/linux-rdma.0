From: Yishai Hadas <yishaih@dev.mellanox.co.il>
Subject: Re: [PATCH mlx5-next v1 1/8] net/mlx5: Add forward compatible support
 for the FTE match data
Date: Sun, 15 Jul 2018 10:26:53 +0300
Message-ID: <84e6a046-881d-65ce-ab58-2ed9691cc864@dev.mellanox.co.il>
References: <20180711111045.6282-1-leon@kernel.org>
 <20180711111045.6282-2-leon@kernel.org>
 <CAJ3xEMipJhe0PdsmR7kshrG-dXSqaLJ5xorwbMZyBvdXy0jA0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMipJhe0PdsmR7kshrG-dXSqaLJ5xorwbMZyBvdXy0jA0A@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 7/12/2018 11:53 PM, Or Gerlitz wrote:
> On Wed, Jul 11, 2018 at 2:10 PM, Leon Romanovsky <leon@kernel.org> wrote:
>> From: Yishai Hadas <yishaih@mellanox.com>
>>
>> Use the PRM size including the reserved when working with the FTE
>> match data.
> 
> is this actually a bug fix?

No, it's some requirement from the new API to enable forward compatible 
support without changing the kernel code.


>> Also drop some driver checks around the match criteria leaving the work
>> for firmware to enable forward compatibility for future bits there.
> 
> not following,
> 

Same as for the 'reserved' field but also for extending the 'match 
criteria' field with new bits without changing the kernel.


> OTOH, suppose today we check that one of four bits is set and now one
> added bit #5 and the
> kernel doesn't check it, what removing the existing four checks buys you?

The idea was to have one place for those checking (i.e. firmware) 
instead of splitting between legacy to new bits. (i.e. driver vs firmware).
