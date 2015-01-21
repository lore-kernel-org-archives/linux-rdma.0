From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 06/17] IB/core: Add support for extended query device
 caps
Date: Wed, 21 Jan 2015 13:50:12 +0100
Message-ID: <1421844612.13543.40.camel@opteya.com>
References: <1418310266-9584-1-git-send-email-haggaie@mellanox.com>
	 <1418310266-9584-7-git-send-email-haggaie@mellanox.com>
	 <1418733236.2779.26.camel@opteya.com> <549128B4.5010301@mellanox.com>
	 <1418824811.3334.3.camel@dworkin> <54918F50.7020705@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54918F50.7020705-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mercredi 17 d=C3=A9cembre 2014 =C3=A0 16:12 +0200, Haggai Eran a =C3=
=A9crit :
> On 17/12/2014 16:00, Yann Droneaud wrote:
> > Le mercredi 17 d=C3=A9cembre 2014 =C3=A0 08:54 +0200, Haggai Eran a=
 =C3=A9crit :
> >> On 16/12/2014 14:33, Yann Droneaud wrote:
> >>> Le jeudi 11 d=C3=A9cembre 2014 =C3=A0 17:04 +0200, Haggai Eran a =
=C3=A9crit :
> >>>>  static inline int ib_copy_to_udata(struct ib_udata *udata, void=
 *src, size_t len)
> >>>>  {
> >>>> -	return copy_to_user(udata->outbuf, src, len) ? -EFAULT : 0;
> >>>> +	size_t copy_sz;
> >>>> +
> >>>> +	copy_sz =3D min_t(size_t, len, udata->outlen);
> >>>> +	return copy_to_user(udata->outbuf, src, copy_sz) ? -EFAULT : 0=
;
> >>>>  }
> >>>
> >>>
> >>> This is not the place to do this: as I'm guessing the purpose of =
this=20
> >>> change from the patch in '[PATCH v3 07/17] IB/core: Add flags for=
 on=20
> >>> demand paging support', you're trying to handle uverbs call from=20
> >>> a userspace program using a previous, shorter ABI.
> >>
> >> Yes, that was my intention.
> >>
> >>>
> >>> But that's hidding bug where userspace will get it wrong at passi=
ng the=20
> >>> correct buffer / size for all others uverb calls.
> >>>
> >>> That cannot work that way.
> >>>
> >>> In a previous patchset [1], I've suggested to add a check in=20
> >>> ib_copy_{from,to}_udata()[2][3] in order to check the input/outpu=
t
> >>> buffer size to not read/write past userspace provided buffer
> >>> boundaries: in case of mismatch an error would be returned to
> >>> userspace.
> >>>
> >>> With the suggested change here, buffer overflow won't happen,
> >>> but the error is silently ignored, allowing uverb to return a
> >>> partial result, which is likely not expected by userspace as
> >>> it's a bit difficult to handle it gracefully.
> >>>
> >>> So this has to be removed, and a check on userspace response
> >>> buffer must be added to ib_uverbs_ex_query_device() instead.
> >>
> >> I agree that we shouldn't silently ignore bugs in userspace, but I=
'm not
> >> sure the alternative is maintainable. If we have in the future N n=
ew
> >> extensions to this verb, will we need to validate the user space g=
iven
> >> output buffer is one of the N possible sizes?
> >>
> >=20
> > Yes.
>=20
> It would very easy for someone to forget one of the possible sizes, a=
nd
> thus blocking support for an older version of libibverbs. Such a bug
> would be hard to detect because it requires testing all previous
> versions of libibverbs. I think the problem you are trying to solve -
> userspace accidentally setting a smaller response size then required =
-
> will be detected immediately when one attempts to use that code.
>=20
> >=20
> > Additionnaly the size should be checked related to the flags set in=
 the
> > "comp_mask": eg. requiring IB_USER_VERBS_EX_QUERY_DEVICE_ODP but no=
t
> > providing the expected response buffer should be an error.
>=20
> In a query verb like EX_QUERY_DEVICE, I would expect the user-space c=
ode
> to request all bits in the comp_mask, since there's very little benef=
it
> from requesting a specific set (only a slightly shorter response for =
the
> system call). The kernel would ignore bits it doesn't know, and the
> user-space would ignore bits it doesn't know in the response.
>=20

Regarding comp_mask (not for this particular verb):

It's not clear whether request's comp_mask describe the request or the
response, as such I'm puzzled.

How would the kernel and the userspace be able to parse the request and
the response if they ignore unknown bits ?

How would they be able to skip the unrecognized chunk of the request an=
d
response buffer ?

How one bit in a comp_mask is related to a chunk in the request or
response ?

It's likely the kernel or userspace would have to skip the remaining
comp_mask's bits after encountering an unknown bit as the size of the
corresponding chunk in request or response would be unknown, making
impossible to locate the corresponding chunk for the next bit set in
comp_mask. Having said that, comp_mask is just a complicated way of
expressing a version, which is turn describe a size (ever growing).

Anyway, I wanted to point to the perf subsystem and tool:

perf subsystem use a version in it's request (ok, it's a size):

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/inc=
lude/uapi/linux/perf_event.h?id=3Dv3.19-rc5#n255

It's checked in perf_copy_attr():

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/ker=
nel/events/core.c?id=3Dv3.19-rc5#n7072

As you can see, any unknown value passed to the kernel is rejected with
-EINVAL. Which is the way to follow, with respect to
http://blog.ffwll.ch/2013/11/botching-up-ioctls.html rules.

Then perf userspace tool is able to probe the maximum supported
features:

See __perf_evsel__open()
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/too=
ls/perf/util/evsel.c?id=3Dv3.19-rc5#n1038

Such complicated construct could be used in userspace to check what's
the highest supported "comp_mask" is.

I don't think it would solve our issue here, but this is a piece to be
reviewed.

By the way, we have to find how to handle the issue as soon as possible=
,
because we can't let this thing working this way for v3.19.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
