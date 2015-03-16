From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/9] IB/ipoib: factor out ah flushing
Date: Mon, 16 Mar 2015 18:51:49 +0200
Message-ID: <55070A25.6020107@dev.mellanox.co.il>
References: <cover.1424562072.git.dledford@redhat.com> <b06eb720c2f654f5ecdb72c66f4e89149d1c24ec.1424562072.git.dledford@redhat.com> <54EF1F67.4000001@dev.mellanox.co.il> <1424968046.2543.18.camel@redhat.com> <54F2B61C.9080308@dev.mellanox.co.il> <1425308967.2354.19.camel@redhat.com> <54F585E9.7070704@dev.mellanox.co.il> <CAJ3xEMgxxHu5BQdADaRe-Grtf4rm1LMfsCRiDyF6ToPdV_62OA@mail.gmail.com> <3A0A417D-BFE4-475C-BAB3-C3FB1D313022@redhat.com> <5506F5B2.1080900@dev.mellanox.co.il> <ADC46FD9-3179-4182-949D-1884C9D31757@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ADC46FD9-3179-4182-949D-1884C9D31757-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/16/2015 6:06 PM, Doug Ledford wrote:
>> On Mar 16, 2015, at 8:24 AM, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org=
> wrote:
>>
>> On 3/15/2015 8:42 PM, Doug Ledford wrote:
>>>> Doug, ten days and no response from you... lets finalize the revie=
w on
>>>> this series so we have it safely done for 4.1 -- on top of it Erez
>>>> prepares a set of IPoIB fixes from our internal tree and we want t=
hat
>>>> for 4.1 too. Please address.
>>> I didn=E2=80=99t have much to say here.  I said that mthca can have=
 card resources freed by this call, which is backed up by this code in =
mthca_ah.c
>>>
>>> int mthca_destroy_ah(struct mthca_dev *dev, struct mthca_ah *ah)
>>> {
>>>          switch (ah->type) {
>>>          case MTHCA_AH_ON_HCA:
>>>                  mthca_free(&dev->av_table.alloc,
>>>                             (ah->avdma - dev->av_table.ddr_av_base)=
 /
>>>                             MTHCA_AV_SIZE);
>>>                  break;
>>>
>>>
>>> I=E2=80=99m not entirely sure how Erez missed that, but it=E2=80=99=
s there and it=E2=80=99s what gets called when we destroy an ah (depend=
ing on the card of course).  So, that represents one case where freeing=
 the resources in a non-lazy fashion has a direct benefit.  And there i=
s no cited drawback to freeing the resources in a non-lazy fashion on a=
 net event, so I don=E2=80=99t see what there is to discuss further on =
the issue.
>> sorry, but i still don't see the connection to the device type.
>> It will be deleted/freed with the regular flow, like it does in the =
rest of the life cycle cases of the ah (in neigh_dtor, path_free, etc.)=
, so why here it should be directly after the event?
> Because it=E2=80=99s the right thing to do.  The only reason to do la=
zy deletion is when there is a performance benefit to batching.  There =
is no performance benefit to batching here.  And because on certain har=
dware the action frees resources on the card, which are limited, doing =
non-lazy deletion can be beneficial.  Given that there is no downside t=
o doing the deletions in a non-lazy fashion, and that there can be an u=
pside depending on hardware, there is no reason to stick with the lazy =
deletions.
OK, i understand your point, not sure why it is not always with the ah=20
deletion, anyway it is harmless here.

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
