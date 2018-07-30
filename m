From: Mark Bloch <markb@mellanox.com>
Subject: Re: [PATCH rdma-next 00/27] Flow actions to mutate packets
Date: Mon, 30 Jul 2018 17:37:05 +0000
Message-ID: <AM0PR05MB44033B0E72CC4FF5B4EE27F0D22F0@AM0PR05MB4403.eurprd05.prod.outlook.com>
References: <20180729125905.31989-1-leon@kernel.org>
 <20180730170958.GK15118@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, "Guy Levi(SW)" <guyle@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 7/30/2018 10:10 AM, Jason Gunthorpe wrote:=0A=
> On Sun, Jul 29, 2018 at 03:58:38PM +0300, Leon Romanovsky wrote:=0A=
>> From: Leon Romanovsky <leonro@mellanox.com>=0A=
>>=0A=
>> Hi,=0A=
>>=0A=
>> This is PATCH variant of RFC posted in previous week to the ML.=0A=
>> https://patchwork.ozlabs.org/cover/944184/=0A=
>>=0A=
>> Changelog:=0A=
>>  RFC -> v0:=0A=
>>   * Patch 1 a new patch which refactors the logic=0A=
>>     when getting a flow namespace.=0A=
>>   * Patch 2 was split into two.=0A=
>>   * Patch 3: Fixed a typo in commit message=0A=
>>   * Patch 5: Updated commit message=0A=
>>   * Patch 7: Updated commit message=0A=
>>     Renamed:=0A=
>>       - MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT_ID to=0A=
>>         MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT=0A=
>>       - packet_reformat_id to reformat_id in struct mlx5_flow_act=0A=
>>       - packet_reformat_id to encap_id in struct mlx5_esw_flow_attr=0A=
>>       - packet_reformat_id to encap_id in struct mlx5e_encap_entry=0A=
>>       - PACKET_REFORMAT to REFORMAT when printing trace points=0A=
>>   * Patch 9: Updated commit message=0A=
>>     Updated function declaration in mlx5_core.h, could of lead=0A=
>>     to compile error on bisection.=0A=
>>   * Patch 11: Disallow egress rules insertion when in switchdev mode=0A=
>>   * Patch 12: A new patch to deal with passing enum values using=0A=
>>     the IOCTL infrastructure.=0A=
>>   * Patch 13: Use new enum value attribute when passing enum=0A=
>>     mlx5_ib_uapi_flow_table_type=0A=
>>   * Patch 15: Don't set encap flags on flow tables if in switchdev mode=
=0A=
>>   * Patch 17: Use new enum value attribute when passing enum=0A=
>>     mlx5_ib_uapi_flow_table_type and enum=0A=
>>     mlx5_ib_uapi_flow_action_packet_reformat_type=0A=
>>   * Patch 19: Allow creation of both=0A=
>>     MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L2_TO_L3_TUNNEL=0A=
>>     and MLX5_IB_UAPI_FLOW_ACTION_PACKET_REFORMAT_TYPE_L3_TUNNEL_TO_L2 pa=
cket=0A=
>>     reformat actions.=0A=
>>   * Patch 20: A new patch which allows attaching packet reformat=0A=
>>     actions to flow tables on NIC RX.=0A=
>>=0A=
>> Thanks=0A=
>>=0A=
>> From Mark:=0A=
>> This series exposes the ability to create flow actions which can=0A=
>> mutate packet headers. We do that by exposing two new verbs:=0A=
>>  * modify header - can change existing packet headers. packet=0A=
>>  * reformat - can encapsulate or decapsulate a packet.=0A=
>>               Once created a flow action must be attached to a steering=
=0A=
>>               rule for it to take effect.=0A=
> =0A=
> Mark, this got a bit big in terms of patch count, however most of the=0A=
> patches fit on one screen and the overall line count isn't too bad.=0A=
=0A=
Yes, there is a lot of code refactoring inside mlx5 drivers but overall=0A=
the code is very simple. The difference from the RFC is mainly renames=0A=
and commit messages and the last 6 patches which add support for flow actio=
n=0A=
to mlx5 create flow, that wasn't posted with the RFC as the mlx5 create flo=
w=0A=
code wasn't merged yet.=0A=
=0A=
> =0A=
> Can this be split somehow?=0A=
> =0A=
=0A=
It can be split into 3 series like this:=0A=
=0A=
Refactoring mlx5_core + rename + creation of flow actions:=0A=
patch [01/27]: net/mlx5: Cleanup flow namespace getter switch logic=0A=
patch [02/27]: net/mlx5: Add proper NIC TX steering flow tables support=0A=
patch [03/27]: net/mlx5: Export modify header alloc/dealloc functions=0A=
patch [04/27]: net/mlx5: Add support for more namespaces when allocating mo=
dify header=0A=
patch [05/27]: net/mlx5: Break encap/decap into two separated flow table cr=
eation flags=0A=
patch [06/27]: net/mlx5: Move header encap type to IFC header file=0A=
patch [07/27]: {net, RDMA}/mlx5: Rename encap to reformat packet=0A=
patch [08/27]: net/mlx5: Expose new packet reformat capabilities=0A=
patch [09/27]: net/mlx5: Pass a namespace for packet reformat ID allocation=
=0A=
patch [10/27]: net/mlx5: Export packet reformat alloc/dealloc functions=0A=
patch [12/27]: RDMA/uverbs: Add UVERBS_ATTR_CONST_IN to the specs language=
=0A=
patch [13/27]: RDMA/mlx5: Add a new flow action verb, modify header=0A=
patch [16/27]: RDMA/uverbs: Add generic function to fill in flow action obj=
ect=0A=
patch [17/27]: RDMA/mlx5: Add new flow action verb, packet reformat=0A=
patch [19/27]: RDMA/mlx5: Extend packet reformat verbs=0A=
=0A=
Enable attaching modify header and packet reformat flow actions via verbs c=
reate flow: =0A=
patch [11/27]: RDMA/mlx5: Add NIC TX steering support=0A=
patch [14/27]: RDMA/mlx5: Enable attaching modify header to steering flows=
=0A=
patch [15/27]: RDMA/mlx5: Enable decap and packet reformat on flow tables=
=0A=
patch [18/27]: RDMA/mlx5: Enable attaching DECAP action to steering flows=
=0A=
patch [20/27]: RDMA/mlx5: Enable reformat on NIC RX if supported=0A=
patch [21/27]: RDMA/mlx5: Enable attaching packet reformat action to steeri=
ng flows=0A=
 =0A=
Enable attaching modify header and packet reformat flow actions via mlx5 cr=
eate flow: =0A=
patch [22/27]: IB/uverbs: Add IDRs array attribute type to ioctl() interfac=
e=0A=
patch [23/27]: RDMA/mlx5: Refactor flow action parsing to be more generic=
=0A=
patch [24/27]: RDMA/mlx5: Refactor DEVX flow creation=0A=
patch [25/27]: RDMA/mlx5: Add flow actions support to DEVX create flow=0A=
patch [26/27]: RDMA/mlx5: Add NIC TX namespace when getting a flow table=0A=
patch [27/27]: RDMA/mlx5: Allow creating a matcher for a NIC TX flow table=
=0A=
=0A=
> Thanks,=0A=
> Jason=0A=
> =0A=
=0A=
Mark=0A=
