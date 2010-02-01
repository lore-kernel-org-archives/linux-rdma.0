From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] Increase maximum Infiniband HCAs per-system
Date: Mon, 1 Feb 2010 07:55:54 -0500
Message-ID: <f0e08f231002010455w432bf496xec6b747faabda838@mail.gmail.com>
References: <20100129214039.17745.38679.stgit@bob.kio>
	 <adar5p8ldxv.fsf@roland-alpha.cisco.com>
	 <20100129234145.GC5177@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100129234145.GC5177-e+Ta4ugHZmL3oGB3hsPCZA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, justin.chen-VXdhtT5mjnY@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 29, 2010 at 6:41 PM, Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org> wrote:
> * Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>:
>>
>> Have you considered drivers/infiniband/core/user_mad.c and ucm.c?
>
> Ah, darn. I had not considered those drivers. You're gonna make
> me learn a lot more about IB than I'd originally intended. ;)
>
>> I think user_mad.c is somewhat more important, as that is what
>> allows an adapter to be used for running the SM. =C2=A0So I think
>> we're still left with some potential issues around lots of
>> adapters in one system. =C2=A0(I think use of ucm by real apps is
>> minimal to nonexistent, but someday we should deal with that
>> too)
>
> Ok, a quick glance through those drivers shows:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0enum {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0IB_UMAD_MAX_PO=
RTS =C2=A0=3D 64,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0IB_UMAD_MAX_AG=
ENTS =3D 32,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0IB_UMAD_MAJOR =
=C2=A0 =C2=A0 =C2=A0=3D 231,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0IB_UMAD_MINOR_=
BASE =3D 0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0};
>
> and
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0enum {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0IB_UCM_MAJOR =3D=
 231,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0IB_UCM_BASE_MI=
NOR =3D 224,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0IB_UCM_MAX_DEV=
ICES =3D 32
> =C2=A0 =C2=A0 =C2=A0 =C2=A0};
>
> They're all sharing the same major number, so they'll all have to
> get the same treatment as the uverbs driver wrt overflow (to
> prevent minor number overlap).
>
> What I'm a little unsure of is, does IB_UMAD_MAX_AGENTS need to
> double too? We don't export the agent id in the filesystem
> anywhere, but we do give it to the user via an ioctl. That's just
> used for book keeping purposes but...
>
> Currently, there are 2x as many ports as there are agents. Do we
> want to keep that ratio, or would it be ok to have 4x as many
> ports as there are agents?

I think it's 2x as many ports as devices (based on the common HCAs
being 2 ports max). This should be maintained as that is still the
case.

-- Hal

>
> Thanks (and sorry for the n00b questions).
>
> /ac
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
