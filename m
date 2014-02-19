From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] infiniband, ocrdma, Fix compiler warning
Date: Wed, 19 Feb 2014 12:49:35 -0500
Message-ID: <5304EEAF.1010702@redhat.com>
References: <1392821725-14137-1-git-send-email-prarit@redhat.com>  <1392828475.25314.1.camel@localhost.localdomain> <1392828848.25314.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392828848.25314.3.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 02/19/2014 11:54 AM, Yann Droneaud wrote:
> Le mercredi 19 f=C3=A9vrier 2014 =C3=A0 17:47 +0100, Yann Droneaud a =
=C3=A9crit :
>> Le mercredi 19 f=C3=A9vrier 2014 =C3=A0 09:55 -0500, Prarit Bhargava=
 a =C3=A9crit :
>>> drivers/infiniband/hw/ocrdma/ocrdma_verbs.c: In function =E2=80=98_=
ocrdma_modify_qp=E2=80=99:
>>> drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:1299:31: error: =E2=80=98=
old_qps=E2=80=99 may be used uninitialized in this function [-Werror=3D=
maybe-uninitialized]
>>>   status =3D ocrdma_mbx_modify_qp(dev, qp, attr, attr_mask, old_qps=
);
>>>
>>> ocrdma_mbx_modify_qp() (and subsequent calls) doesn't appear to use=
 old_qps
>>> so it doesn't need to be passed on.  Removing the variable results =
in the
>>> warning going away.
>>>
>>
>> Nice to see this warning removed.
>>
>>> Signed-off-by: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>
>>
>> You should move the signed of after the Cc's.
>>
>>> Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> Cc: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
>>> Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ^^^
>> There's a missing Cc: tag

Oops.  I'll add him to v2.

>>
>>> Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Cc: "Gottumukkala, Naresh" <B.A.L.NRaju.Gottumukkala-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
>>
>=20
> Additionnaly some addresses seems to be invalid:
>=20
> <B.A.L.NRaju.Gottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>: host
> emulex.com.mail5.psmtp.com[64.18.5.10] said: 550 No such user - psmtp
> (in reply to RCPT TO command)
>=20
> <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>: host emulex.com.mail5.psmtp.com[64.18.5.1=
0]
> said: 550 No such user - psmtp (in reply to RCPT TO command)

Yep, but those are spit out by get_maintainer.pl before I send the patc=
h.
There's no way to know that they are dead email addresses until the mai=
l is sent
:/.  Trimming them now...

P.

>=20
> Regards.
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
