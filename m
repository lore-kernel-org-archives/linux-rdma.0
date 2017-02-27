From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: ibv_rc_pingpong, rping, and other tools hang with Linux 4.10.0
 and rdma-core 13
Date: Mon, 27 Feb 2017 20:38:32 +0000
Message-ID: <CC495762-698F-47FE-B977-35DE3CD04CDE@mellanox.com>
References: <CABQspYbv7j58pdLLbPegE8Bc3qhwb-3+4E8SQ2U9jObkeTbrzw@mail.gmail.com>
 <4e077022-5e5f-6ba8-530c-b86d2f09313e@mellanox.com>,<20170227162916.GC5891@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170227162916.GC5891-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, GAFBlizzard <gtschemer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Youngjae Lee <dhrkaeh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Beavers <josh.beavers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 27, 2017, at 7:09 PM, Jason Gunthorpe <jgunthorpe@obsidianresearch=
.com> wrote:
>=20
>> On Sun, Feb 26, 2017 at 06:09:34PM +0200, Yonatan Cohen wrote:
>>=20
>> I bisected the rdma-core library and figured out that the following comm=
it
>> introduced this regression:
>> 6b26a9e24739 Use C11 atomics instead of wmb/rmb macros for CPU-only atom=
ics
>>=20
>> I haven't debugged this yet and would appreciate Jason's input.
>=20
> Oops, I think I typo'd it here:
>=20
> --- a/providers/rxe/rxe_queue.h
> +++ b/providers/rxe/rxe_queue.h
> @@ -37,15 +37,16 @@
> #ifndef H_RXE_PCQ
> #define H_RXE_PCQ
>=20
> +#include <stdatomic.h>
> +
> /* MUST MATCH kernel struct rxe_pqc in rxe_queue.h */
> struct rxe_queue {
>        uint32_t                log2_elem_size;
>        uint32_t                index_mask;
>        uint32_t                pad_1[30];
> -       volatile uint32_t       producer_index;
> +       _Atomic(uint32_t)       producer_index;
>        uint32_t                pad_2[31];
> -       volatile uint32_t       consumer_index;
> -       uint32_t                pad_3[31];
> +       _Atomic(uint32_t)       consumer_index;
>=20
>=20
> Ie deleted pad_3[31] by mistake!
>=20
> My bad
Thanks Jason for looking into it.
Can you please submit this fix to rdma-core?
>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
