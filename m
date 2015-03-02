From: Vaishali Thakkar <vthakkar1994-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/ipatch: Use setup_timer and mod_timer
Date: Mon, 2 Mar 2015 22:29:31 +0530
Message-ID: <CAK-LDbKQ9vUEyT0uzFC8H=EOE7Vq-e0q7xLh71YtQtwZTBGYUQ@mail.gmail.com>
References: <20150301194637.GA3441@vaishali-Ideapad-Z570>
	<1425314856.3069.12.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425314856.3069.12.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 2, 2015 at 10:17 PM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> w=
rote:
> Le lundi 02 mars 2015 =C3=A0 01:16 +0530, Vaishali Thakkar a =C3=A9cr=
it :
>> Use timer API functions setup_timer and mod_timer instead
>> of structure assignments as they are standard way to set
>> the timer and to update the expire field of an active timer
>> respectively.
>>
>> This is done using Coccinelle and semantic patch used for
>> this is as follows:
>>
>> // <smpl>
>> @@
>> expression x,y,z,a,b;
>> @@
>>
>> -init_timer (&x);
>> +setup_timer (&x, y, z);
>> +mod_timer (&a, b);
>> -x.function =3D y;
>> -x.data =3D z;
>> -x.expires =3D b;
>> -add_timer(&a);
>> // </smpl>
>>
>> Signed-off-by: Vaishali Thakkar <vthakkar1994-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/ipath/ipath_driver.c    |  9 +++------
>>  drivers/infiniband/hw/ipath/ipath_init_chip.c | 10 +++-------
>>  drivers/infiniband/hw/ipath/ipath_verbs.c     |  7 ++-----
>>  3 files changed, 8 insertions(+), 18 deletions(-)
>>
> [...]
>> diff --git a/drivers/infiniband/hw/ipath/ipath_init_chip.c b/drivers=
/infiniband/hw/ipath/ipath_init_chip.c
>> index be2a60e..34ffb43 100644
>> --- a/drivers/infiniband/hw/ipath/ipath_init_chip.c
>> +++ b/drivers/infiniband/hw/ipath/ipath_init_chip.c
>> @@ -950,13 +950,9 @@ int ipath_init_chip(struct ipath_devdata *dd, i=
nt reinit)
>>                * set up stats retrieval timer, even if we had errors
>>                * in last portion of setup
>>                */
>> -             init_timer(&dd->ipath_stats_timer);
>> -             dd->ipath_stats_timer.function =3D ipath_get_faststats=
;
>> -             dd->ipath_stats_timer.data =3D (unsigned long) dd;
>> -             /* every 5 seconds; */
>> -             dd->ipath_stats_timer.expires =3D jiffies + 5 * HZ;
>> -             /* takes ~16 seconds to overflow at full IB 4x bandwdi=
th */
>> -             add_timer(&dd->ipath_stats_timer);
>> +             setup_timer(&dd->ipath_stats_timer, ipath_get_faststat=
s,
>> +                         (unsigned long)dd);
>> +             mod_timer(&dd->ipath_stats_timer, jiffies + 5 * HZ);
>
> The code seems correct, but you remove the comments, loosing some use=
ful
> information.

Yes. I guess I missed that. Ok. I will send v2 with keeping these
comments in a code.

Thank You

> Regards.
>
> --
> Yann Droneaud
> OPTEYA
>
>



--=20
Vaishali
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
