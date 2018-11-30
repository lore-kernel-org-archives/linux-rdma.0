From: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Subject: Re: [PATCH mlx5-next 00/13] Mellanox, mlx5 core driver events API
Date: Thu, 29 Nov 2018 16:43:59 -0800
Message-ID: <CALzJLG9X-wn4LiNA8eACRe_FEszA41WgwC3tFE_L9foJtAayQA@mail.gmail.com>
References: <20181126223908.15988-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126223908.15988-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, Linux Netdev List <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 26, 2018 at 2:39 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> Hi,
>
> This patchset is for mlx5-next shared branch, and will be applied there
> once the review is done.
>
> The main idea of this change is to define a flexible scalable and
> simpler high level mlx5 core APIs to forward device and driver events
> to upper level interface drivers e.g mlx5_ib and mlx5e netdevice driver.
>
> Patch #1, Driver events notifier API:
>
> Use atomic notifier chain to fire events to mlx5 core driver
> consumers (mlx5e/mlx5_ib) and provide dynamic mlx5 register/unregister
> notifier API to replace the internal mlx5_interface->event and totally
> remove it.
>
> Patch #2, Forward port events via the new notifier chain.
> Patch #3, Use the mlx5 events API in mlx5e netdevice.
> Patch #4, Forward all device events sent via mlx5_core_event (old API)
> to the new notifier chain, this will allow seamless transition to the
> new AP.
> Patch #5, Use the new events API in mlx5_IB
> Patch #6, remove old interface callback, mlx5_interface->event
> Patch #7,8,9, mlx5_ib to handle raw FW events as is rather than the
> software version of them, this will remove any need for unnecessary
> processing of FW events in the low level mlx5_core driver.
> Patch #10, Remove unnecessary processing of FW events in the low level
> mlx5_core driver, all events are handled on demand by mlx5_ib and/or
> mlx5e netdevice.
>
> patch #11,12, forward QP and SRQ events via the new notifier chain,
> will be needed by mlx5_ib driver.
>
> Patch #13, Debug patch for mlx5 events.
>
> Thanks,
> Saeed.
>
> ---
>
> Saeed Mahameed (13):
>   net/mlx5: Driver events notifier API
>   net/mlx5: Allow port change event to be forwarded to driver notifiers
>     chain
>   net/mlx5e: Use the new mlx5 core notifier API
>   net/mlx5: Forward all mlx5 events to mlx5 notifiers chain
>   IB/mlx5: Use the new mlx5 core notifier API
>   net/mlx5: Remove unused events callback and logic
>   IB/mlx5: Handle raw port change event rather than the software version
>   net/mlx5: Allow forwarding event type general event as is
>   IB/mlx5: Handle raw delay drop general event
>   net/mlx5: Remove all deprecated software versions of FW events
>   net/mlx5: Forward QP/WorkQueues resource events
>   net/mlx5: Forward SRQ resource events
>   net/mlx5: Debug print for forwarded async events
>

Applied to mlx5-next.

Thanks,
Saeed.
