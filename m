From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core 00/14] Revise the DMA barrier macros in ibverbs
Date: Tue, 28 Feb 2017 16:38:09 +0000
Message-ID: <C6384D48-FC47-4046-8025-462E1CB02A34@mellanox.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>,<1488297611.86943.215.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488297611.86943.215.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 28, 2017, at 6:00 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>=20
>> On Thu, 2017-02-16 at 12:22 -0700, Jason Gunthorpe wrote:
>> Now that the header is private to the library we can change it.
>>=20
>> We have never had a clear definition for what our wmb() or wc_wmb()
>> even do,
>> and they don't match the same macros in the kernel. This causes
>> problems for
>> non x86 arches as they have no idea what to put in their versions of
>> the macros
>> and often just put the strongest thing.
>>=20
>> This also causes problems for the driver authors who have no idea how
>> to use
>> these barriers properly, there are several instances of that :(
>>=20
>> My approach here is to introduce a selection of macros that have
>> narrow and
>> clearly defined purposes. The selection is based on things the set of
>> drivers
>> actually do, which turns out to be fairly narrowly defined.
>>=20
>> Then I went through all the drivers and adjusted them to various
>> degrees to
>> use the new macro names. In a few drivers I added more/stronger
>> barriers.
>> Overall this tries hard not to break anything by weaking existing
>> barriers.
>>=20
>> A future project for someone would be to see if the CPU ASM makes
>> sense..
>>=20
>> https://github.com/linux-rdma/rdma-core/pull/79
>>=20
>> Jason Gunthorpe (14):
>>   mlx5: Use stdatomic for the in_use barrier
>>   Provide new names for the CPU barriers related to DMA
>>   cxgb3: Update to use new udma write barriers
>>   cxgb4: Update to use new udma write barriers
>>   hns: Update to use new udma write barriers
>>   i40iw: Get rid of unique barrier macros
>>   mlx4: Update to use new udma write barriers
>>   mlx5: Update to use new udma write barriers
>>   nes: Update to use new udma write barriers
>>   mthca: Update to use new mmio write barriers
>>   ocrdma: Update to use new udma write barriers
>>   qedr: Update to use new udma write barriers
>>   vmw_pvrdma: Update to use new udma write barriers
>>   Remove the old barrier macros
>>=20
>>  providers/cxgb3/cq.c             |   2 +
>>  providers/cxgb3/cxio_wr.h        |   2 +-
>>  providers/cxgb4/qp.c             |  20 +++-
>>  providers/cxgb4/t4.h             |  48 ++++++--
>>  providers/cxgb4/verbs.c          |   2 +
>>  providers/hns/hns_roce_u_hw_v1.c |  13 +-
>>  providers/i40iw/i40iw_osdep.h    |  14 ---
>>  providers/i40iw/i40iw_uk.c       |  26 ++--
>>  providers/mlx4/cq.c              |   6 +-
>>  providers/mlx4/qp.c              |  19 +--
>>  providers/mlx4/srq.c             |   2 +-
>>  providers/mlx5/cq.c              |   8 +-
>>  providers/mlx5/mlx5.h            |   7 +-
>>  providers/mlx5/qp.c              |  18 +--
>>  providers/mlx5/srq.c             |   2 +-
>>  providers/mthca/cq.c             |  10 +-
>>  providers/mthca/doorbell.h       |   2 +-
>>  providers/mthca/qp.c             |  20 ++--
>>  providers/mthca/srq.c            |   6 +-
>>  providers/nes/nes_uverbs.c       |  16 +--
>>  providers/ocrdma/ocrdma_verbs.c  |  16 ++-
>>  providers/qedr/qelr_verbs.c      |  32 +++--
>>  providers/vmw_pvrdma/cq.c        |   6 +-
>>  providers/vmw_pvrdma/qp.c        |   8 +-
>>  util/udma_barrier.h              | 250 +++++++++++++++++++++++++++
>> ------------
>>  25 files changed, 354 insertions(+), 201 deletions(-)
>=20
> Thanks, series merged.
Hi Doug,

This is a very sensitive series that we haven't Acked yet.
It might have performance and functional/correctness implications.
Also, as you can see we still have open discussions with Jason.

We would really appreciate a heads up before merging topics that have on go=
ing discussions and give us a chance to Ack.

Thanks
>=20
> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>   =20
> Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
