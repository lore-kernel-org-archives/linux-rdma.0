From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Fri, 27 May 2016 09:32:33 -0400
Message-ID: <57484C71.309@redhat.com>
References: <166c87fa-09ef-f170-7351-d18062bc25cf@redhat.com>
 <20160527045157.GW25500@leon.nu>
 <20160527114414.GA27420@phlsvsds.ph.intel.com>
 <20160527131357.GX25500@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rpBe1T9NHFeRc1t9HK1rT74dQ2rBwgfmI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160527131357.GX25500-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rpBe1T9NHFeRc1t9HK1rT74dQ2rBwgfmI
Content-Type: multipart/mixed; boundary="atF6g4AXJm8V2pRQljPUH6q8lQvfs0Ao6"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <57484C71.309-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
References: <166c87fa-09ef-f170-7351-d18062bc25cf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20160527045157.GW25500-2ukJVAZIZ/Y@public.gmane.org>
 <20160527114414.GA27420-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
 <20160527131357.GX25500-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20160527131357.GX25500-2ukJVAZIZ/Y@public.gmane.org>

--atF6g4AXJm8V2pRQljPUH6q8lQvfs0Ao6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 5/27/2016 9:13 AM, Leon Romanovsky wrote:
> On Fri, May 27, 2016 at 07:44:15AM -0400, Dennis Dalessandro wrote:
>> On Fri, May 27, 2016 at 07:51:57AM +0300, Leon Romanovsky wrote:
>>> On Thu, May 26, 2016 at 06:34:28PM -0400, Doug Ledford wrote:
>>>> Hi Linus,
>>>>
>>>> This is the second group of code for the 4.7 merge window.  It looks=

>>>> large, but only in one sense.  I'll get to that in a minute.  The li=
st
>>>> of changes here breaks down as follows:
>>>>
>>>> Round two of 4.7 merge window patches
>>>>
>>>
>>> <...>
>>>
>>>> - The big item on the list: hfi1 driver updates, plus moving the hfi=
1
>>>>  driver out of staging                             <- everything els=
e
>>>
>>> Hi Doug and Linus,
>>>
>>> The move hfi1 from the staging is a right thing, it was there a long
>>> time and it is almost ready.
>>
>> No, not almost, it is totally ready. We have bent over backwards to go=
 well
>> beyond what was in the TODO list. This is a clean, stable, and well
>> performing driver.
>=20
> It is your's TODO, not mine.

No, but Mellanox has been adding to the TODO list, changing the goal
posts so to speak.  They really *have* bent over backwards to meet the
TODO requirements and then some.

>>
>>> However the timing of this move puzzle me, we are in the process of A=
BI
>>> change [1, 2] as a response to security alert [3]. Moves like this wi=
th
>>> proprietary char device and ABI scheme different from whole RDMA stac=
k
>>> will limit the ABI work without real need.
>>
>> The driver sitting in staging or not has no impact on the ABI re-desig=
n.
>> They are two completely separate issues.
>=20
> Separate char device? IOCTLs per-device vs. global IOCTLs per subsystem=
?
> Role of the IB CORE code in the driver management?

Really Leon?  The qib driver has the *exact* same issue, and it sits out
of staging.  If moving this driver out of staging somehow stops us from
making the new ABI while the qib driver not being in staging doesn't
prevent it, then we are a bunch of idiots.  This would appear to me to
be a very disingenuous complaint on your part.

>>
>>> Will this driver be **forced** to adjust to new ABI scheme whenever i=
t
>>> comes? If it is not possible, the better solution to converge on ABI =
change will be
>>> to leave this driver in staging/rdma and wait till proper solution wi=
ll be accepted.
>>
>> I think Doug has made it perfectly clear that hfi1 will need to adopt =
the
>> new ABI when it is available, and we are certainly on board with that.=

>=20
> It is too generic and not limited in time,

What's too generic and not limited in time is the switch to the new API
for the core.  Fundamental questions about what that API should look
like simply have not even begun to be addressed yet.  It is very
unlikely IMO that it will be read for 4.8, which means you are talking
about leaving a driver in staging for 6+ months for no fault of its own
other than the core hasn't modified itself over to the verbs 2.0 ABI
yet.  And you aren't suggesting all of the other RDMA drivers join hfi1
in staging while we wait.  They get a pass.

> I'm not against moving your
> driver out of staging, just want to be sure that ABI effort won't be
> limited by current hfi1 code which doesn't fit into current IB core
> model.

Like I said, the qib also doesn't fit into that model and I don't see
you jumping up and down about it ruining the ABI.  No, this feels more
like Mellanox trying to hinder Intel in my opinion.  And the amount of
inter-company politics that has come about by use of the staging area
has pretty much convinced me that I probably don't want to use it ever
again.  We're done with the staging area Leon.  Move on.




--atF6g4AXJm8V2pRQljPUH6q8lQvfs0Ao6--

--rpBe1T9NHFeRc1t9HK1rT74dQ2rBwgfmI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXSEx3AAoJELgmozMOVy/dfMoP/jH+yqnQt4IdRnHRt0BhtgZX
LkrtLMtMhFP/C5gbtlDjW763NvBIRHFHVw8NC4LZ9grkTrBuUV0g6BfLrbFAD2nn
ruTsQMODTNvE4eQxRGcs8qojnlW+oCEEmZMq2dE+LvzNJPy/+HV3cyAvGN4yyWjJ
3docQoK689+8BUduFPyw0B8n3Rl4I7nufpfHKUocxx6wS9J+WVSq1Sx/GrEbtPQK
h2RI31Zb5zhDUuDQq3nyCH2ksA7wOvQutCss0GnB1H5m24EAfWJzetKYa58pYZWJ
KCFAGdZdzpg7yGsU39qNUtnobWPOKO7HVAy+yCmHPe/J5h4k0Cmvp8ye1Hq7CgMG
i52xJ9glySSp8sN9VezsxgDgtXI2QqLYJe8XZexouABSbvMdOYi/oRS4Gcxa+Tl5
J+oA4g6Xy3cW0Wc7QJv9AepS7kqmkJiS+mXezR1r2/s6laxddOeR+9PwYya5jCTE
0+xUPF0Lq6ePnALT/cSeufzozUyUzUySykK/fNnniLiO0bPFuYtkgqrAWfqHM5+w
AOAon4gsJsrFVCSlb6j1PGD5eyrf076d5Tc6p1pxDNUNlu5Q9qX83IzC/LmOIFkj
Xvh8yL3UFstdHv740w6g9Eg0kGK1PWUNkj3auKziVw9yXz1dNfHfdUoMDZZv5bGp
1CL5/9XGfwJggt1IWGZU
=rhw6
-----END PGP SIGNATURE-----

--rpBe1T9NHFeRc1t9HK1rT74dQ2rBwgfmI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
