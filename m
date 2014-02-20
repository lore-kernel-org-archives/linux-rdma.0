From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v2 00/12] T10-DIF Initial support for iSER target
Date: Thu, 20 Feb 2014 14:51:19 +0200
Message-ID: <5305FA47.8040106@dev.mellanox.co.il>
References: <1392825025-29943-1-git-send-email-sagig@mellanox.com> <1392851690.22195.7.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1392851690.22195.7.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, roland@kernel.org, linux-rdma@vger.kernel.org, oren@mellanox.com, martin.petersen@oracle.com
List-Id: linux-rdma@vger.kernel.org

On 2/20/2014 1:14 AM, Nicholas A. Bellinger wrote:
> On Wed, 2014-02-19 at 17:50 +0200, Sagi Grimberg wrote:
>> Hey Nic,
>>
>> I addressed your comments in the this set. I'll try to send the
>> initiator code for review in the next couple of days.
>>
>> This patchset introduces target side T10-PI offload support over
>> RDMA. Currently the implementation is for iSER transport but can
>> be easily extended to SRP (or FCoE in the future).
>>
>> Should mention that this patchset depends on RDMA signature
>> verbs making it for inclusion which will hopefully happen in
>> near future.
>>
>> This code was tested against iSER legacy initiator, and also
>> initiator that uses T10-PI offload as well. I'll clean up the
>> initiator code in the following days and submit that as well.
>>
>> This code works under medium loads using backstores:
>> - FileIO with DIF emulation.
>> - RD with DIF emulation.
>> - iBLOCK (scsi_debug with DIF support).
>>
>> Chnages from v1:
>> - Rebased rdma_dif (3.14-rc2)
>> - Target core:
>>    - Pass zero_flag=3Dtrue to alloc_sgl for protection buffers
>>    - Removed Unneeded inline function rwprotect
>>    - Pass is_write bool to sbc_set_prot_op_checks
>>    - Send failure response for absence of protection buffers
>>      when needed.
>> - iSER:
>>    - Removed unneeded assignments in isert_set_sig_attrs
>>
>> Chnages from v0:
>> - Rebased from for-next
>> - Target core:
>>    - Don't minor fixes for check_prot - to support transports
>>      that doesn't use submit_map_sgls.
>>    - file  format - use escape values.
>>    - Removed redundant prot_handover.
>>    - Added protection checks and operation set.
>> - iSER:
>>    - Added preperation routines for mapping/unmapping buffers
>>      to ease the amount of code in isert_reg_rdma.
>>    - Fixed print of DIF error (sector instead of offset).
>>    - Fix RDMA length for protection on wire domain.
>>    - Refactored reg_sig_mr to use helper routines.
>>
> Hey Sagi,
>
> FYI, this series did not compile:
>
> drivers/infiniband/ulp/isert/ib_isert.c: In function =E2=80=98isert_r=
eg_sig_mr=E2=80=99:
> drivers/infiniband/ulp/isert/ib_isert.c:2531:2: error: expected =E2=80=
=98;=E2=80=99 before =E2=80=98ret=E2=80=99
> drivers/infiniband/ulp/isert/ib_isert.c: In function =E2=80=98isert_r=
eg_rdma=E2=80=99:
> drivers/infiniband/ulp/isert/ib_isert.c:2611:24: warning: comparison =
between =E2=80=98enum target_prot_type=E2=80=99 and =E2=80=98enum targe=
t_prot_op=E2=80=99 [-Wenum-compare]
> drivers/infiniband/ulp/isert/ib_isert.c:2625:24: warning: comparison =
between =E2=80=98enum target_prot_type=E2=80=99 and =E2=80=98enum targe=
t_prot_op=E2=80=99 [-Wenum-compare]
> drivers/infiniband/ulp/isert/ib_isert.c:2667:43: warning: comparison =
between =E2=80=98enum target_prot_type=E2=80=99 and =E2=80=98enum targe=
t_prot_op=E2=80=99 [-Wenum-compare]
> drivers/infiniband/ulp/isert/ib_isert.c: In function =E2=80=98isert_p=
ut_datain=E2=80=99:
> drivers/infiniband/ulp/isert/ib_isert.c:2711:24: warning: comparison =
between =E2=80=98enum target_prot_type=E2=80=99 and =E2=80=98enum targe=
t_prot_op=E2=80=99 [-Wenum-compare]
> drivers/infiniband/ulp/isert/ib_isert.c:2732:24: warning: comparison =
between =E2=80=98enum target_prot_type=E2=80=99 and =E2=80=98enum targe=
t_prot_op=E2=80=99 [-Wenum-compare]
> drivers/infiniband/ulp/isert/ib_isert.c: At top level:
> drivers/infiniband/ulp/isert/ib_isert.c:2468:1: warning: =E2=80=98ise=
rt_set_sig_attrs=E2=80=99 defined but not used [-Wunused-function]
> drivers/target/target_core_transport.c: In function =E2=80=98transpor=
t_generic_new_cmd=E2=80=99:
> drivers/target/target_core_transport.c:2221:22: warning: comparison b=
etween =E2=80=98enum target_prot_type=E2=80=99 and =E2=80=98enum target=
_prot_op=E2=80=99 [-Wenum-compare]
>
> Squashing the following patch(es) into your original series, and appl=
ied
> to target-pending/rdma-dif.

Ohhh, last second cosmetics...

Thanks for fixing it, won't happen again...

> Thank you,

Thank you...

> --nab
>
