From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 04/17] IB/core: Add umem function to read data from user-space
Date: Thu, 11 Dec 2014 15:09:01 +0200
Message-ID: <CAJ3xEMh-=wLD_FLxNaiDYofA4mOf+woep2PPmKDbY2-k9XBS+g@mail.gmail.com>
References: <1415723783-2138-1-git-send-email-haggaie@mellanox.com>
	<1415723783-2138-5-git-send-email-haggaie@mellanox.com>
	<1418228521.11111.50.camel@opteya.com>
	<54897B84.9000708@mellanox.com>
	<1418301590.11111.95.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418301590.11111.95.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 11, 2014 at 2:39 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> w=
rote:
> Le jeudi 11 d=C3=A9cembre 2014 =C3=A0 13:09 +0200, Haggai Eran a =C3=A9=
crit :
>> On 10/12/2014 18:22, Yann Droneaud wrote:
>> > Hi,
>> >
>> > Le mardi 11 novembre 2014 =C3=A0 18:36 +0200, Haggai Eran a =C3=A9=
crit :
>> >> In some drivers there's a need to read data from a user space are=
a that
>> >> was pinned using ib_umem, when running from a different process c=
ontext.
>> >>
>> >> The ib_umem_copy_from function allows reading data from the physi=
cal pages
>> >> pinned in the ib_umem struct.
>> >>
>> >> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> >> ---
>> >>  drivers/infiniband/core/umem.c | 26 ++++++++++++++++++++++++++
>> >>  include/rdma/ib_umem.h         |  2 ++
>> >>  2 files changed, 28 insertions(+)
>> >>
>> >> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/=
core/umem.c
>> >> index e0f883292374..77bec75963e7 100644
>> >> --- a/drivers/infiniband/core/umem.c
>> >> +++ b/drivers/infiniband/core/umem.c
>> >> @@ -292,3 +292,29 @@ int ib_umem_page_count(struct ib_umem *umem)
>> >>    return n;
>> >>  }
>> >>  EXPORT_SYMBOL(ib_umem_page_count);
>> >> +
>> >> +/*
>> >> + * Copy from the given ib_umem's pages to the given buffer.
>> >> + *
>> >> + * umem - the umem to copy from
>> >> + * offset - offset to start copying from
>> >> + * dst - destination buffer
>> >> + * length - buffer length
>> >> + *
>> >> + * Returns the number of copied bytes, or an error code.
>> >> + */
>> >> +int ib_umem_copy_from(struct ib_umem *umem, size_t offset, void =
*dst,
>> >> +                size_t length)
>> >
>> > I would prefer the arguments in the same order as ib_copy_from_uda=
ta()
>> >
>> > int ib_umem_copy_from(void *dst,
>> >                       struct ib_umem *umem, size_t umem_offset,
>> >                       size_t length);
>>
>> No problem.
>>
>> >> +{
>> >> +  size_t end =3D offset + length;
>> >> +
>> >> +  if (offset > umem->length || end > umem->length || end < offse=
t) {
>> >> +          pr_err("ib_umem_copy_from not in range. offset: %zd um=
em length: %zd end: %zd\n",
>> >> +                 offset, umem->length, end);
>> >> +          return -EINVAL;
>> >> +  }
>> >> +
>
> I think the test could be rewritten as:
>
>         if (offset > umem->length || length > umem->length - offset)
>
> That's one operation less.
>
>
>> >> +  return sg_pcopy_to_buffer(umem->sg_head.sgl, umem->nmap, dst, =
length,
>> >> +                  offset + ib_umem_offset(umem));
>> >> +}
>> >> +EXPORT_SYMBOL(ib_umem_copy_from);
>> >
>> > As the function return a "int", no more than INT_MAX bytes (likely=
 2^31
>> > - 1) can be copied. Perhaps changing the return type to to ssize_t=
 would
>> > be better (and a check to enfore ssize_t maximum value). Or change=
 the
>> > function could return 0 in case of success or a error code, just l=
ike
>> > ib_copy_from_udata().
>> >
>>
>> Okay. I'll change it to match ib_copy_from_udata. We're checking the
>> umem size in the call site of this function anyway, and the only rea=
son
>> I see sg_pcopy_to_buffer would return less than *length* bytes is wh=
en
>> reaching the end of the scatterlist.
>>
>
> As the length is compared against umem->length (+ offset), this would
> mean umem->length is not "synchronized" with the length of the data
> described by the scatter/gather list ?

> BTW, ib_copy_from_udata() is defined as an inline function. Would it =
be
> better to have ib_umem_copy_from() being an inline function too ?
> (In such case, I would remove the error message to not duplicate it
>  across all modules using the function)

Yann, Lets leave your 2nd comment to be addressed as future
cleanup/improvement. Really, these patches
are on the list for 7-8 moths and we were asking for feedback over all
this time, jumping now with inlining comments and such when the merge
window is just across the door isn't appropriate.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
