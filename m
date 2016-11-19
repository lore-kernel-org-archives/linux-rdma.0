From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sat, 19 Nov 2016 18:11:22 -0500
Message-ID: <710f3e81-dd9c-8221-cf5e-7a96f4cad5b9@redhat.com>
References: <58466423-c87e-3921-101e-bffab8989fd8@redhat.com>
 <20161117184950.GP4240@leon.nu> <582E089A.3040106@redhat.com>
 <20161117200203.GQ4240@leon.nu>
 <CAJ3xEMjXYYnhS6qUzM9F+yjtq8Aahn08MjsSU4OnLS66Cu7mgw@mail.gmail.com>
 <fea924a0-f399-8ecf-c039-5cb7c5e0acb8@redhat.com>
 <CAJ3xEMimsUMgRhWgSChFS39nw3XggsVGSnmgP+L4gSco=vAF3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PO23CqrWosoQP3j5s3QF5qSFeiMrqxLXa"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMimsUMgRhWgSChFS39nw3XggsVGSnmgP+L4gSco=vAF3A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PO23CqrWosoQP3j5s3QF5qSFeiMrqxLXa
Content-Type: multipart/mixed; boundary="uOR2NNkICbw769JVXl3J91mAvn9DrvPMf";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: linux-rdma <linux-rdma@vger.kernel.org>,
 Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <710f3e81-dd9c-8221-cf5e-7a96f4cad5b9@redhat.com>
Subject: Re: [PULL REQUEST] Please pull rdma.git
References: <58466423-c87e-3921-101e-bffab8989fd8@redhat.com>
 <20161117184950.GP4240@leon.nu> <582E089A.3040106@redhat.com>
 <20161117200203.GQ4240@leon.nu>
 <CAJ3xEMjXYYnhS6qUzM9F+yjtq8Aahn08MjsSU4OnLS66Cu7mgw@mail.gmail.com>
 <fea924a0-f399-8ecf-c039-5cb7c5e0acb8@redhat.com>
 <CAJ3xEMimsUMgRhWgSChFS39nw3XggsVGSnmgP+L4gSco=vAF3A@mail.gmail.com>
In-Reply-To: <CAJ3xEMimsUMgRhWgSChFS39nw3XggsVGSnmgP+L4gSco=vAF3A@mail.gmail.com>

--uOR2NNkICbw769JVXl3J91mAvn9DrvPMf
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 11/19/2016 2:46 PM, Or Gerlitz wrote:
> On Fri, Nov 18, 2016 at 4:01 AM, Doug Ledford <dledford@redhat.com> wro=
te:
>> On 11/17/2016 5:24 PM, Or Gerlitz wrote:
>=20
> [...]
>=20
>> I agree with you.  It doesn't fix your patch.  The commit message can
>> still be fixed up.
>=20
>>> Please do not send it to Linus and wait for them to respond. I
>>> disagree that it fixes my commit b/c my commit was prior to when
>>> route-able RoCE  was introduced and on that time TOS had no relation.=

>=20
>> I agree.  A better fix tag would be the commit that added RoCEv2 suppo=
rt.
>=20
> But this is the smaller part of the problem. The bigger part is that I
> have asked for clarifications on the patch and they didn't provide
> anything.

You asked for clarification on the commit message, I didn't hear any
objections to the content of the patch itself.

> So if you are picking patches where a reviewer comments are
> ignored, what lesson are you teaching the submitter, that he can just
> continue with this practice? why you letting this go that way?

Because I can fix up the log message at any time prior to pulling it
into my official -next branch.  Since that's all you objected to, I can
take the patch and wait for the final version of the comments.  It's not
a big deal Or.

>>> does a tiny enhancement for a 10y old commit of Roland, why you think=

>>> we need it in 4.9-rc6 or 7??
>=20
>> I don't, it's in the mlx-next branch which means I'll queue it up for
>> the 4.10 merge window.  I have no plan on sending that branch for 4.9-=
rc.
>=20
> Are you going to comment on that to the submitter? if not, they are
> going to continue with this practice.

Comment on what to the submitter?  That the patch might not have been
-rc material?  I would have been OK with it around rc1 or rc2, just not
this late in the rc cycle.  In the end, I don't, nor can I, rely on
submitters to determine what's RC material and what isn't, that's what
I'm supposed to be doing.  I will always apply my own judgment on that
issue and submitters will learn over time when their patches get skipped
on any sort of a regular basis.

> How are we supposed to realize from patchworks + your github branches
> that patches that were submitted for 4.9-rc are picked for 4.10? this
> is very confusing and error prone too.

I emailed the submitters off list about it and provided them a list of
what patches went where and why.

> Please comment also on the bunch of patches I pointed you where the
> copy you have picked into your tree (pulled it from somewhere?) isn't
> what was submitted.

I'm sorry, but you'll have to refresh my memory on this issue.


--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--uOR2NNkICbw769JVXl3J91mAvn9DrvPMf--

--PO23CqrWosoQP3j5s3QF5qSFeiMrqxLXa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYMNwaAAoJELgmozMOVy/dS7IP/30MxhnoxoxWuV2dMQMxxBKf
cDGmMpdEzSefgJnKfFcFnQAzskz9JkiYyfI5nX+RUbWR3bueeW5sjkSCsM244mJR
aH+nZP+qjAaWhITC0GoS0/ED8LugIh1AtYMwNSl4Cow7iE9qGcUCGnGFU4bFxZSA
R31MoVzZqgUhjCQ2rFUiH1Z9IxVILaf8aBxmFgOZFbA/QJoe7WN8zJIx1T6jvOND
FUKF5ZMsXVab2YM7tObIrHu3JiSz3j/ZKrRKKFkz8gDgvk9u5xBrQRF4n8vhIgnL
V1CVsT2ONgtzN+KMZKwSYwdNSGD53SrXY5h14NaFFHMWTtCEukNamehipJkBYWGy
zrl2+J0itxUfodJoMdSZJMhVYys+gFLPobp8qnht0LglwHPhKlVn/dunNbDAeBKv
wWWhi5QlnIR4Y7nxTmnlP+zlU9BjZmxzpXlyiH1dT55jfGOkio5oRm1GyImyblob
4s8Kr3DF9EoqekFE74Cu5lwFNSLQYSfnMG1OqERD/o1L6mGXdPXxYziF4p1OaKYC
WFXInm4nCc49dgKb5YffnGWtCHYOKRl/MH1f+fWVqzCfSt7BIY6Jnrxvr+pY8nzE
YP6WSK09p1DLnEt6yl2IqFCO9gNFNp+7OI/FMVUfmsDvDeglR2GIj1Goy9E+Gs61
lvGg/nzUGy3WZ7yo5f3B
=jql1
-----END PGP SIGNATURE-----

--PO23CqrWosoQP3j5s3QF5qSFeiMrqxLXa--
