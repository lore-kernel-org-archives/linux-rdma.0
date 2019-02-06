From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH] mlx4_ib: Increase the timeout for CM cache
Date: Wed, 6 Feb 2019 09:50:56 +0100
Message-ID: <13750147-482A-4F90-976A-033C52DCF85E@oracle.com>
References: <20190131170951.178676-1-haakon.bugge@oracle.com>
 <20190205223608.GA23110@ziepe.ca>
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190205223608.GA23110@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: netdev@vger.kernel.org, OFED mailing list <linux-rdma@vger.kernel.org>, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Jack Morgenstein <jackm@dev.mellanox.co.il>
List-Id: linux-rdma@vger.kernel.org



> On 5 Feb 2019, at 23:36, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> On Thu, Jan 31, 2019 at 06:09:51PM +0100, H=C3=A5kon Bugge wrote:
>> Using CX-3 virtual functions, either from a bare-metal machine or
>> pass-through from a VM, MAD packets are proxied through the PF =
driver.
>>=20
>> Since the VMs have separate name spaces for MAD Transaction Ids
>> (TIDs), the PF driver has to re-map the TIDs and keep the book =
keeping
>> in a cache.
>>=20
>> Following the RDMA CM protocol, it is clear when an entry has to
>> evicted form the cache. But life is not perfect, remote peers may die
>> or be rebooted. Hence, it's a timeout to wipe out a cache entry, when
>> the PF driver assumes the remote peer has gone.
>>=20
>> We have experienced excessive amount of DREQ retries during fail-over
>> testing, when running with eight VMs per database server.
>>=20
>> The problem has been reproduced in a bare-metal system using one VM
>> per physical node. In this environment, running 256 processes in each
>> VM, each process uses RDMA CM to create an RC QP between himself and
>> all (256) remote processes. All in all 16K QPs.
>>=20
>> When tearing down these 16K QPs, excessive DREQ retries (and
>> duplicates) are observed. With some cat/paste/awk wizardry on the
>> infiniband_cm sysfs, we observe:
>>=20
>>      dreq:       5007
>> cm_rx_msgs:
>>      drep:       3838
>>      dreq:      13018
>>       rep:       8128
>>       req:       8256
>>       rtu:       8256
>> cm_tx_msgs:
>>      drep:       8011
>>      dreq:      68856
>>       rep:       8256
>>       req:       8128
>>       rtu:       8128
>> cm_tx_retries:
>>      dreq:      60483
>>=20
>> Note that the active/passive side is distributed.
>>=20
>> Enabling pr_debug in cm.c gives tons of:
>>=20
>> [171778.814239] <mlx4_ib> mlx4_ib_multiplex_cm_handler: id{slave:
>> 1,sl_cm_id: 0xd393089f} is NULL!
>>=20
>> By increasing the CM_CLEANUP_CACHE_TIMEOUT from 5 to 30 seconds, the
>> tear-down phase of the application is reduced from 113 to 67
>> seconds. Retries/duplicates are also significantly reduced:
>>=20
>> cm_rx_duplicates:
>>      dreq:       7726
>> []
>> cm_tx_retries:
>>      drep:          1
>>      dreq:       7779
>>=20
>> Increasing the timeout further didn't help, as these duplicates and
>> retries stem from a too short CMA timeout, which was 20 (~4 seconds)
>> on the systems. By increasing the CMA timeout to 22 (~17 seconds), =
the
>> numbers fell down to about one hundred for both of them.
>>=20
>> Adjustment of the CMA timeout is _not_ part of this commit.
>>=20
>> Signed-off-by: H=C3=A5kon Bugge <haakon.bugge@oracle.com>
>> ---
>> drivers/infiniband/hw/mlx4/cm.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Jack? What do you think?

I am tempted to send a v2 making this a sysctl tuneable. This because, =
full-rack testing using 8 servers, each with 8 VMs, only showed 33% =
reduction in the occurrences of "mlx4_ib_multiplex_cm_handler: =
id{slave:1,sl_cm_id: 0xd393089f} is NULL" with this commit.

But sure, Jack's opinion matters.


Thxs, H=C3=A5kon

>=20
>> diff --git a/drivers/infiniband/hw/mlx4/cm.c =
b/drivers/infiniband/hw/mlx4/cm.c
>> index fedaf8260105..8c79a480f2b7 100644
>> --- a/drivers/infiniband/hw/mlx4/cm.c
>> +++ b/drivers/infiniband/hw/mlx4/cm.c
>> @@ -39,7 +39,7 @@
>>=20
>> #include "mlx4_ib.h"
>>=20
>> -#define CM_CLEANUP_CACHE_TIMEOUT  (5 * HZ)
>> +#define CM_CLEANUP_CACHE_TIMEOUT  (30 * HZ)
>>=20
>> struct id_map_entry {
>> 	struct rb_node node;
>> --=20
>> 2.20.1
