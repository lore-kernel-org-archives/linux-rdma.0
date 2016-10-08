From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH qedr 04/10] qedr: Add support for PD,PKEY and CQ verbs
Date: Sat, 8 Oct 2016 09:35:06 -0400
Message-ID: <a146f562-1970-e939-1bd5-074af868f7d6@redhat.com>
References: <1475682483-9878-1-git-send-email-Ram.Amrani@cavium.com>
 <1475682483-9878-5-git-send-email-Ram.Amrani@cavium.com>
 <20161006133357.GP9282@leon.nu>
 <CY1PR0701MB1337AC7B933E917765C3EBC990C60@CY1PR0701MB1337.namprd07.prod.outlook.com>
 <20161007142454.GU9282@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8JKXkRiKrc2XsS3re1XjIIWkRJviOJu5m"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161007142454.GU9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8JKXkRiKrc2XsS3re1XjIIWkRJviOJu5m
Content-Type: multipart/mixed; boundary="iTnMhO5oUeEVgidT2FVBG3mNFNwgoNPac";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Message-ID: <a146f562-1970-e939-1bd5-074af868f7d6-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH qedr 04/10] qedr: Add support for PD,PKEY and CQ verbs
References: <1475682483-9878-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
 <1475682483-9878-5-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
 <20161006133357.GP9282-2ukJVAZIZ/Y@public.gmane.org>
 <CY1PR0701MB1337AC7B933E917765C3EBC990C60-UpKza+2NMNLi6bjPjkn3FE5OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
 <20161007142454.GU9282-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20161007142454.GU9282-2ukJVAZIZ/Y@public.gmane.org>

--iTnMhO5oUeEVgidT2FVBG3mNFNwgoNPac
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/7/2016 10:24 AM, Leon Romanovsky wrote:
> On Fri, Oct 07, 2016 at 10:47:18AM +0000, Elior, Ariel wrote:
>>>> @@ -66,6 +85,12 @@ struct rdma_cqe_common {
>>>>     struct regpair qp_handle;
>>>>     __le16 reserved1[7];
>>>>     u8 flags;
>>>> +#define RDMA_CQE_COMMON_TOGGLE_BIT_MASK  0x1
>>>> +#define RDMA_CQE_COMMON_TOGGLE_BIT_SHIFT 0
>>>> +#define RDMA_CQE_COMMON_TYPE_MASK        0x3
>>>> +#define RDMA_CQE_COMMON_TYPE_SHIFT       1
>>>> +#define RDMA_CQE_COMMON_RESERVED2_MASK   0x1F
>>>> +#define RDMA_CQE_COMMON_RESERVED2_SHIFT  3
>>>>     u8 status;
>>>
>>> It is VERY uncommon to mix defines and structs together.
>>> Please don't do it, it confuses a lot and doesn't help to
>>> readability/debug.
>>
>> Hi Leon,
>> Firstly, thanks for investing your time in reviewing our driver.
>> As for mixed defines and structures, far from being very uncommon, the=
y are
>> actually ubiquitous throughout the kernel and are used by the foremost=

>> developers (Dave Miller, Linus, Jeff Kirsher).
>=20
> Net subsystem is very different from other kernel community.
> For example, this article from LWN [1] - "Coding-style exceptionalism"
> talks about it.

> [1] https://lwn.net/Articles/694755/

That article only refers to multi-line comments, not to embedding
#defines inside of structs that the #defines are used with.

My personal taste on things like this is that if you had something like
a variable with a result code, then use a separate enum for the possible
options.  However, in this case, you have a multi-mask item and the
defines are the three masks and their shifts.  I'm OK with that being
mixed in or being separate, but if it's separate, I would want it
immediately before the struct with a comment specifying that this is the
format of the status byte in the struct.  What I wouldn't want is the
#defines moved far away from the struct with a bunch of other defines
where the context of the struct is lost.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--iTnMhO5oUeEVgidT2FVBG3mNFNwgoNPac--

--8JKXkRiKrc2XsS3re1XjIIWkRJviOJu5m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIbBAEBCAAGBQJX+PYQAAoJELgmozMOVy/dY0UP91juVGjd0PDGNOtkq1gLDNZ+
ydTDM5BW6b+4yWVQQ+6ZU999RIMPNomh1O6S1r1FVxyA1GyjCsdY89ZvcsngoqOi
Gl7Fqo6TKsRZriE2+c/XkCaLeE+12hmBmCvosElCNQEpnO/WfJSC7U9wOqxyPbuE
L7RPGSUfvXB3ggHtMQPONIS6PRi/asKwT09NMDCTS90lbsxxQCRsXJBgp8RHWWAA
fgC6GYw+IkBKD8ARemYJK3Snt7vJXUlSVvtqchnoQB0U/Lo3Hl17hXQWS+4+d0zF
6vCZydbz9ULaGGH49javg6O8erBE0L1nPeAMFPuTcOYjqUJ9R3trk71dAegETO8i
KiCxLn3vbNXRyMAiuQyTWQpr3fuKKvn+WJOQvxMnNubT89rqNhZNl+S3p7AtnFwW
uG7CGyBU7HkXD0ZdZjFtvtW1i4qu0jnLMXA1wUhE3k7D0loLNW3FdWRuHy/TolZo
NjrqjD++JQ29ySL5nctQEtgjp50dvbv9qFvQNdU233r7dWrIfjOakEUqF09MO1Fk
+xmqTzIeThY9olBMA+6M/aqOiB/gTw6Kx62OIXIkjM2iguJyvJXrJ73bbVIv4a2d
u84fpcFXIi8CrEr0CA1WSCmdwtSyEhbvC71BgnhTqcrBJkF5tuM6qUAgshhLxcfa
/s86EgG/tWFUQGnPVnc=
=TEAj
-----END PGP SIGNATURE-----

--8JKXkRiKrc2XsS3re1XjIIWkRJviOJu5m--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
