From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] infiniband: remove WARN that is not kernel bug
Date: Wed, 14 Dec 2016 13:16:45 -0500
Message-ID: <b5343f5e-68a8-5a01-5fa9-04e9181e4082@redhat.com>
References: <1479723531-17940-1-git-send-email-dvyukov@google.com>
 <alpine.LNX.2.00.1611211123450.22752@pobox.suse.cz>
 <CACT4Y+ZO9sTbBGwNUUMkAQ5m0N-4aT0S9xypCRbBUch1pQNw9g@mail.gmail.com>
 <20161121114417.GA4158@leon.nu>
 <CACT4Y+Y1sL-8K7HhZ5M5ABVPG0kM=dKZh+6gvuNRvzXFtiA5aQ@mail.gmail.com>
 <20161121121408.GC4158@leon.nu> <20161121165253.GA22237@obsidianresearch.com>
 <20161121173820.GC23083@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jvdmKT0T6FPMJf8CFa2N1EqdheSrb63Ri"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161121173820.GC23083-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, syzkaller <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jvdmKT0T6FPMJf8CFa2N1EqdheSrb63Ri
Content-Type: multipart/mixed; boundary="KamagMOvhjVNpr8lfQ9RjrVtDh1UiVm1f";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, syzkaller
 <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org,
 Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <b5343f5e-68a8-5a01-5fa9-04e9181e4082-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] infiniband: remove WARN that is not kernel bug
References: <1479723531-17940-1-git-send-email-dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
 <alpine.LNX.2.00.1611211123450.22752-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
 <CACT4Y+ZO9sTbBGwNUUMkAQ5m0N-4aT0S9xypCRbBUch1pQNw9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <20161121114417.GA4158-2ukJVAZIZ/Y@public.gmane.org>
 <CACT4Y+Y1sL-8K7HhZ5M5ABVPG0kM=dKZh+6gvuNRvzXFtiA5aQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <20161121121408.GC4158-2ukJVAZIZ/Y@public.gmane.org> <20161121165253.GA22237-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <20161121173820.GC23083-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20161121173820.GC23083-2ukJVAZIZ/Y@public.gmane.org>

--KamagMOvhjVNpr8lfQ9RjrVtDh1UiVm1f
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/21/2016 12:38 PM, Leon Romanovsky wrote:
> On Mon, Nov 21, 2016 at 09:52:53AM -0700, Jason Gunthorpe wrote:
>> On Mon, Nov 21, 2016 at 02:14:08PM +0200, Leon Romanovsky wrote:
>>>>
>>>> In ib_ucm_write function there is a wrong prefix:
>>>>
>>>> + pr_err_once("ucm_write: process %d (%s) tried to do something hink=
y\n",
>>>
>>> I did it intentionally to have the same errors for all flows.
>>
>> Lets actually use a good message too please?
>>
>>  pr_err_once("ucm_write: process %d (%s) changed security contexts aft=
er opening FD, this is not allowed.\n",
>>
>> Jason

I applied Leon's reworked version of this patch, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--KamagMOvhjVNpr8lfQ9RjrVtDh1UiVm1f--

--jvdmKT0T6FPMJf8CFa2N1EqdheSrb63Ri
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUYyNAAoJELgmozMOVy/dxhcP+gNQQHIqtAmzKwn/afKfFfRG
U5MJ3hj/BG/FlYpvVPxk9UiBQRAXUCPk0pen7ozoGTSI3g17OP8ZV6xIJblzVaWZ
/A2cC+vP81V2Nd/L5BF1VTa98721r1W9wDRW9JmpfkXzFdAC1HbImeaHvBAKD39U
nnPDxlDW/rI8szC4oKBvvRhDV2tmsI+Cd0DU3m4FlsqdcHFjtaLXwXW58vwGRYQ3
tL5zl0cjlZ8Xp0Oo0tkV2a3QwUZfvG7YvI4t9JLi/isVh8FQB9Xmo/iX8+NTdgxP
Wgab1q74WD8zFhCwcBD/uRNAfVC9ebTxHqIYyJNAaTjFGjCDym3yv7qFnDHyKKeC
1ykOpBiTfOkF8y3wVQZ8XkB47Xm7ZcugYAwP38e4gb1Sj0JDvt8Szb79SbzKYMzl
TF/2/WmAhOi6gC8xXZJb6SH06DM5Oq9J83FIsRjj57+62vt9qw/exuTQ9LrK+hRR
5vxyuFfPdDrpFTpp+1ulShGzg74Pj36w6ls5KCYO1PMofCHte1hvnYAObibXswXU
pC9bDuvPztdziYTO9nHaqWF10y/HyI+c0KsjZZRQqELAtwMD9esimZCrJNJ4277P
JS073rr980LPkYKgTK2LhGW4+bjCbMRlcrpY4QSh0dQ+NnqQ6ZqpKzq0djvzhCOM
Z/W9zr0LPhQRPLiYPsOl
=OyjT
-----END PGP SIGNATURE-----

--jvdmKT0T6FPMJf8CFa2N1EqdheSrb63Ri--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
