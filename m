From: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Subject: Re: [BUG?] OpenMPI with openib on SPARC64: Signal: Bus error (10)
Date: Tue, 22 Nov 2011 19:25:55 +0000 (GMT)
Message-ID: <1321989955.84323.YahooMailNeo@web24704.mail.ird.yahoo.com>
References: <1321926674.44951.YahooMailNeo@web24715.mail.ird.yahoo.com> <CAL1RGDVsj_cZ7qJZAmjAGAPd2a3wvs3-7jELtTN6Z1Vn88Z9OQ@mail.gmail.com>
Reply-To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVsj_cZ7qJZAmjAGAPd2a3wvs3-7jELtTN6Z1Vn88Z9OQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "devel-ygRj4skf0tpg9hUCZPvPmw@public.gmane.org" <devel-ygRj4skf0tpg9hUCZPvPmw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, TERRY DONTJE <terry.dontje-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
>
> On Mon, Nov 21, 2011 at 5:51 PM, Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org> wrote:
>> [cluster1:64027] Signal code: Invalid address alignment (1)
>> [cluster1:64027] Failing at address: 0xaa9053
>> [cluster1:64027] [ 0]
> /usr/mpi/gcc/openmpi-1.4.3/lib64/openmpi/mca_pml_ob1.so(+0x62f0)
> [0xfffff8010209e2f0]
>
> Seems like openmpi is doing a misaligned access somewhere...
>
> not sure how to turn this into a real location in the code, Open MPI guys??

Hello Roland,

one guy (Terry D. Dontje) already answered in the devel-ygRj4skf0tpg9hUCZPvPmw@public.gmane.org mailing list:
http://www.open-mpi.org/community/lists/devel/2011/11/10011.php

As I've understood him, he thinks the same. Now I'm trying to do what he wrote and answer soon...
Thanks for your estimation!

Best regards,
Lukas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
