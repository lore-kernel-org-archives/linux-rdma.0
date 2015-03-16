From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/9] IB/ipoib: factor out ah flushing
Date: Mon, 16 Mar 2015 17:24:34 +0200
Message-ID: <5506F5B2.1080900@dev.mellanox.co.il>
References: <cover.1424562072.git.dledford@redhat.com> <b06eb720c2f654f5ecdb72c66f4e89149d1c24ec.1424562072.git.dledford@redhat.com> <54EF1F67.4000001@dev.mellanox.co.il> <1424968046.2543.18.camel@redhat.com> <54F2B61C.9080308@dev.mellanox.co.il> <1425308967.2354.19.camel@redhat.com> <54F585E9.7070704@dev.mellanox.co.il> <CAJ3xEMgxxHu5BQdADaRe-Grtf4rm1LMfsCRiDyF6ToPdV_62OA@mail.gmail.com> <3A0A417D-BFE4-475C-BAB3-C3FB1D313022@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3A0A417D-BFE4-475C-BAB3-C3FB1D313022-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/15/2015 8:42 PM, Doug Ledford wrote:
>> On Mar 13, 2015, at 1:39 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
>>
>> On Tue, Mar 3, 2015 at 11:59 AM, Erez Shitrit <erezsh-LDSdmyG8hGXFtvusC2JeyQ@public.gmane.org=
o.il> wrote:
>>> On 3/2/2015 5:09 PM, Doug Ledford wrote:
>>>> On Sun, 2015-03-01 at 08:47 +0200, Erez Shitrit wrote:
>>>>> On 2/26/2015 6:27 PM, Doug Ledford wrote:
>>>>>>>> @@ -1037,6 +1038,7 @@ static void __ipoib_ib_dev_flush(struct
>>>>>>>> ipoib_dev_priv *priv,
>>>>>>>>         if (level =3D=3D IPOIB_FLUSH_LIGHT) {
>>>>>>>>                 ipoib_mark_paths_invalid(dev);
>>>>>>>>                 ipoib_mcast_dev_flush(dev);
>>>>>>>> +               ipoib_flush_ah(dev, 0);
>>>>>>> Why do you need to call the flush function here?
>>>>>> To remove all of the ah's that were reduced to a 0 refcount by t=
he
>>>>>> previous two functions prior to restarting operations.  When we =
remove
>>>>>> an ah, it calls ib_destroy_ah which calls all the way down into =
the low
>>>>>> level driver.  This was to make sure that old, stale data was re=
moved
>>>>>> all the way down to the card level before we started new queries=
 for
>>>>>> paths and ahs.
>>>>> Yes. but it is not needed.
>>>> That depends on the card.  For the modern cards (mlx4, mlx5, qib),=
 it
>>>> isn't needed but doesn't hurt either.  For older cards (in particu=
lar,
>>>> mthca), the driver actually frees up card resources at the time of=
 the
>>>> call.
>>>
>>> Can you please elaborate more here, I took a look in the mthca and =
didn't
>>> see that.
>>> anyway, what i don't understand is why you need to do that now, the=
 ah is
>>> already in the dead_ah_list so, in at the most 1 sec will be cleare=
d and if
>>> the driver goes down your other hunk fixed that.
>> Doug, ten days and no response from you... lets finalize the review =
on
>> this series so we have it safely done for 4.1 -- on top of it Erez
>> prepares a set of IPoIB fixes from our internal tree and we want tha=
t
>> for 4.1 too. Please address.
> I didn=E2=80=99t have much to say here.  I said that mthca can have c=
ard resources freed by this call, which is backed up by this code in mt=
hca_ah.c
>
> int mthca_destroy_ah(struct mthca_dev *dev, struct mthca_ah *ah)
> {
>          switch (ah->type) {
>          case MTHCA_AH_ON_HCA:
>                  mthca_free(&dev->av_table.alloc,
>                             (ah->avdma - dev->av_table.ddr_av_base) /
>                             MTHCA_AV_SIZE);
>                  break;
>
>
> I=E2=80=99m not entirely sure how Erez missed that, but it=E2=80=99s =
there and it=E2=80=99s what gets called when we destroy an ah (dependin=
g on the card of course).  So, that represents one case where freeing t=
he resources in a non-lazy fashion has a direct benefit.  And there is =
no cited drawback to freeing the resources in a non-lazy fashion on a n=
et event, so I don=E2=80=99t see what there is to discuss further on th=
e issue.
sorry, but i still don't see the connection to the device type.
It will be deleted/freed with the regular flow, like it does in the res=
t=20
of the life cycle cases of the ah (in neigh_dtor, path_free, etc.), so=20
why here it should be directly after the event?

> =E2=80=94
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 	GPG Key ID: 0E572FDD
>
>
>
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
