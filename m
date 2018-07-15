From: Yishai Hadas <yishaih@dev.mellanox.co.il>
Subject: Re: [PATCH mlx5-next v1 1/8] net/mlx5: Add forward compatible support
 for the FTE match data
Date: Sun, 15 Jul 2018 11:26:52 +0300
Message-ID: <85cb3c37-a9e3-97cf-eb21-faab8f04c334@dev.mellanox.co.il>
References: <20180711111045.6282-1-leon@kernel.org>
 <20180711111045.6282-2-leon@kernel.org>
 <CAJ3xEMipJhe0PdsmR7kshrG-dXSqaLJ5xorwbMZyBvdXy0jA0A@mail.gmail.com>
 <84e6a046-881d-65ce-ab58-2ed9691cc864@dev.mellanox.co.il>
 <CAJ3xEMhO_89Fxj3=2=pas_R_9M6sPXOPu0V3saBaqeJ3j+-hkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMhO_89Fxj3=2=pas_R_9M6sPXOPu0V3saBaqeJ3j+-hkw@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 7/15/2018 11:03 AM, Or Gerlitz wrote:
> On Sun, Jul 15, 2018 at 10:26 AM, Yishai Hadas
> <yishaih@dev.mellanox.co.il> wrote:
>> On 7/12/2018 11:53 PM, Or Gerlitz wrote:
>>> On Wed, Jul 11, 2018 at 2:10 PM, Leon Romanovsky <leon@kernel.org> wrote:
>>>> From: Yishai Hadas <yishaih@mellanox.com>
> 
>>>> Use the PRM size including the reserved when working with the FTE
>>>> match data.
> 

> -- we need a clear memo as part of your change-logs and/or cover-letter/s that
> explains the overall approach/design for
> doing-things-without-changing-the-kernel,
> does this exist? 

Yes, the DEVX series that was previously accepted clearly stated that 
this is its target as part of its cover-letter [1]. This motivation 
appears also as part of this specific commit log.

 From the cover letter:
"The main purpose here is to make the user space driver as independent 
as possible from the kernel so that future device functionality and 
commands can be activated with minimal to none kernel changes.

[1]
https://patchwork.ozlabs.org/cover/930449/
