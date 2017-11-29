From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH/RFC] RDMA/iwpm: Fix uninitialized error code in iwpm_send_mapinfo()
Date: Wed, 29 Nov 2017 09:20:02 +0100
Message-ID: <CAK8P3a2chJ_kSAX1R=mBoLCbo+4d60_y6wW-pdzxwxv=rCuC9A@mail.gmail.com>
References: <1510827964-11100-1-git-send-email-geert@linux-m68k.org>
 <20171128230834.GH21325@ziepe.ca> <CAMuHMdUEcHMFML71E-8AOSpCrjComvJiij+dM9H=j7atnBsiZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMuHMdUEcHMFML71E-8AOSpCrjComvJiij+dM9H=j7atnBsiZw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 29, 2017 at 9:10 AM, Geert Uytterhoeven
<geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org> wrote:
> Hi Jason,
>
> On Wed, Nov 29, 2017 at 12:08 AM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
>> On Thu, Nov 16, 2017 at 11:26:04AM +0100, Geert Uytterhoeven wrote:
>>> With gcc-4.1.2:
>>>
>>>     drivers/infiniband/core/iwpm_util.c: In function =E2=80=98iwpm_send=
_mapinfo=E2=80=99:
>>>     drivers/infiniband/core/iwpm_util.c:647: warning: =E2=80=98ret=E2=
=80=99 may be used uninitialized in this function
>>>
>>> Indeed, if nl_client is not found in any of the scanned has buckets, re=
t
>>> will be used uninitialized.
>>>
>>> Preinitialize ret to zero to fix this.
>>
>> Did we come to a conclusion if we should apply this to the RMDA tree? Th=
e
>> patch was marked RFC..
>
> So far no one commented on what's the correct behavior in case of failure=
,
> which was the actual reason for the RFC.

As I said above, I think initializing to -EINVAL would be better than 0 her=
e,
but initializing 'ret' at declaration time is appropriate here (though
I normally
try to avoid doing so, see https://rusty.ozlabs.org/?p=3D232)

      Arnd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
