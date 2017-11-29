From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [PATCH/RFC] RDMA/iwpm: Fix uninitialized error code in iwpm_send_mapinfo()
Date: Wed, 29 Nov 2017 09:10:25 +0100
Message-ID: <CAMuHMdUEcHMFML71E-8AOSpCrjComvJiij+dM9H=j7atnBsiZw@mail.gmail.com>
References: <1510827964-11100-1-git-send-email-geert@linux-m68k.org> <20171128230834.GH21325@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171128230834.GH21325-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

On Wed, Nov 29, 2017 at 12:08 AM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
> On Thu, Nov 16, 2017 at 11:26:04AM +0100, Geert Uytterhoeven wrote:
>> With gcc-4.1.2:
>>
>>     drivers/infiniband/core/iwpm_util.c: In function =E2=80=98iwpm_send_=
mapinfo=E2=80=99:
>>     drivers/infiniband/core/iwpm_util.c:647: warning: =E2=80=98ret=E2=80=
=99 may be used uninitialized in this function
>>
>> Indeed, if nl_client is not found in any of the scanned has buckets, ret
>> will be used uninitialized.
>>
>> Preinitialize ret to zero to fix this.
>
> Did we come to a conclusion if we should apply this to the RMDA tree? The
> patch was marked RFC..

So far no one commented on what's the correct behavior in case of failure,
which was the actual reason for the RFC.

>> Fixes: 30dc5e63d6a5ad24 ("RDMA/core: Add support for iWARP Port Mapper u=
ser space service")
>> Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
>> RFC as I have no idea if this can ever happen, and if yes, what's the
>> correct behavior to handle it:
>>   - return 0,
>>   - return an error code,
>>   - don't send anything,
>>   - anything else?
>>  drivers/infiniband/core/iwpm_util.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/co=
re/iwpm_util.c
>> index 3c4faadb8cddd7fd..eb000b540495acd1 100644
>> +++ b/drivers/infiniband/core/iwpm_util.c
>> @@ -644,7 +644,7 @@ int iwpm_send_mapinfo(u8 nl_client, int iwpm_pid)
>>       int i =3D 0, nlmsg_bytes =3D 0;
>>       unsigned long flags;
>>       const char *err_str =3D "";
>> -     int ret;
>> +     int ret =3D 0;
>>
>>       skb =3D dev_alloc_skb(NLMSG_GOODSIZE);
>>       if (!skb) {

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
