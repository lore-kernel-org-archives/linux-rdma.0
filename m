From: Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH 2/3] mlx4: Don't bother using skb_tx_hash in mlx4_en_select_queue
Date: Wed, 2 May 2018 13:20:30 -0700
Message-ID: <CAKgT0UfmWExqMA1tvrQeOE=25gK7Bw3kf1ROCwA=-VHoivyfUQ@mail.gmail.com>
References: <20180427180142.4883.96259.stgit@ahduyck-green-test.jf.intel.com>
 <20180427180640.4883.75746.stgit@ahduyck-green-test.jf.intel.com> <14063C7AD467DE4B82DEDB5C278E8663B2E40B6D@ORSMSX154.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <14063C7AD467DE4B82DEDB5C278E8663B2E40B6D@ORSMSX154.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
To: "Ruhl, Michael J" <michael.j.ruhl@intel.com>
Cc: "Duyck, Alexander H" <alexander.h.duyck@intel.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "Vishwanathapura, Niranjana" <niranjana.vishwanathapura@intel.com>, "tariqt@mellanox.com" <tariqt@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 2, 2018 at 11:09 AM, Ruhl, Michael J
<michael.j.ruhl@intel.com> wrote:
>>-----Original Message-----
>>From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
>>owner@vger.kernel.org] On Behalf Of Alexander Duyck
>>Sent: Friday, April 27, 2018 2:07 PM
>>To: netdev@vger.kernel.org; davem@davemloft.net
>>Cc: linux-rdma@vger.kernel.org; Dalessandro, Dennis
>><dennis.dalessandro@intel.com>; Vishwanathapura, Niranjana
>><niranjana.vishwanathapura@intel.com>; tariqt@mellanox.com
>>Subject: [PATCH 2/3] mlx4: Don't bother using skb_tx_hash in
>>mlx4_en_select_queue
>>
>>The code in the fallback path has supported XDP in conjunction with the Tx
>>traffic classification for TCs for over a year now. So instead of just
>>calling skb_tx_hash for every packet we are better off using the fallback
>>since that will record the Tx queue to the socket and then that can be used
>>instead of having to recompute the hash every time.
>>
>>Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
>>---
>> drivers/net/ethernet/mellanox/mlx4/en_tx.c |    2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>>diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>>b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>>index 6b68537..0227786 100644
>>--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>>+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>>@@ -694,7 +694,7 @@ u16 mlx4_en_select_queue(struct net_device *dev,
>>struct sk_buff *skb,
>>       u16 rings_p_up = priv->num_tx_rings_p_up;
>>
>>       if (netdev_get_num_tc(dev))
>>-              return skb_tx_hash(dev, skb);
>>+              return fallback(dev, skb);
>>
>>       return fallback(dev, skb) % rings_p_up;
>
> Hi Alexander,
>
> The final return fallback() call is doing a % rings_p_up.
>
> Do you need to do that for the new fallback() call?
>
> Maybe you can get rid of the netdev_get_num_tc() call altogether?
>
> Thanks,
>
> Mike

I contemplated that. The problem I suspect that piece of code is
solving is that there are cases where the number of queues the device
advertises and the number in use may not match. We have similar cases
in the ixgbe and i40e drivers for things like MACVLAN or FCoE offload
where certain queues are reserved for the offloaded traffic. For those
we are just setting up 1 TC in order to limit traffic to a given queue
set.

As time permits one thing I may look at doing is making it so that
this driver always has the number of TCs set to 1 or more. If we do
that then we could drop the modulo fallback case, likely improve the
performance as a result, and get rid of this ndo_select_queue call
entirely. I just don't currently have the time or resources to take on
the research and validation of such a change.

Thanks.

- Alex
