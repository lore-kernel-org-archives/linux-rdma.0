From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: HFI1 code duplication todo
Date: Fri, 20 Nov 2015 12:46:43 -0500
Message-ID: <564F5C83.6020908@redhat.com>
References: <20151112211317.GB11252@phlsvsds.ph.intel.com>
 <20151119222319.GA17605@phlsvsds.ph.intel.com> <564F3F1C.4020508@redhat.com>
 <20151120163935.GA10091@kroah.com> <564F512A.1060808@redhat.com>
 <20151120171346.GA14829@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qpkkMEeukpxoXdU4KepQpqBWda2tSTlvh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151120171346.GA14829-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qpkkMEeukpxoXdU4KepQpqBWda2tSTlvh
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/20/2015 12:13 PM, Greg KH wrote:

>>> I think it's too late for that, especially given that I have 34+ patc=
hes
>>> for the staging rdma drivers already in my tree in linux-next.
>>
>> For hfi1 rename detection should work, for the other three, patches to=

>> removed files are easily resolved as simply dropped patches.  So I don=
't
>> think it's that large of an issue.  Correct me if I'm wrong.
>=20
> I don't know what kind of conflicts will happen, if the changes will
> propagate over if you rename a file in one branch and expect the change=
s
> made to the file in a different branch to come over.  Haven't done that=

> in years.

Well, there's also the possibility of just me pulling your current
for-next and making that the starting point of my for-next and doing the
deletions and move there.  That would resolve the issue.

>> And that's orthogonal to the issue that the primary TODO item for this=

>> driver requires coordination between it, qib (in the RDMA tree), and t=
he
>> upcoming soft_roce driver.  If the driver isn't moved, then we have to=

>> coordinate between your tree and mine to make sure that no patches are=

>> taken into your tree until after the patches they depend on have lande=
d
>> in my tree.  And then you tree likely won't build unless you pull from=

>> my tree and merge up first.  It's not really tenable.  That was why I
>> had suggested (and originally you agreed to) that I would handle the
>> entire staging/rdma tree.  However, since you changed your mind on tha=
t
>> issue, we now have this coordination issue.  I don't really want to de=
al
>> with that, so I would rather move the hfi1 driver and take care of the=

>> all the needed patching myself going forward.
>=20
> That might be the _primary_ TODO item, but really, look at the patches
> being submitted so far, they are just fixing up basic things that shoul=
d
> have been done a long time ago to the codebase.

Yes, I agree.  The driver is in active development.  It is not a mature
driver, and they are still fixing things up.

>  How about people get it
> cleaned up "completely" for this merge cycle, going through my tree, an=
d
> then, when it's all cleaned up, I'll move it to your portion of the tre=
e
> and merge that into 4.5-rc1 and then the cross-driver/core changes you
> are referring to can happen.  There's no big rush here to try to force
> the issue.

Other than the fact that people are ready to start on the initial
changes to support the library, there's no rush.  But doing the move now
(even if just via my for-next branch) allows people to start submitting
those other patches.  There are multiple people working on this driver,
some of them working on cleaning the driver up in general, and some
working on that transition to a core library for transfers.  Getting the
driver moved allows those people to submit patches in parallel instead
of forcing serialization of the development flow.

>>> I had expected the drivers to be deleted for -rc1, removing them now
>>> seems a bit late in the merge window.
>>
>> Yes, I know.  I've been busy.  My apologies for not getting it in prio=
r
>> to rc1.
>=20
> It's not a problem, life happens (congratulations by the way),

Thanks :-)

> but don't
> rush things now, why not just wait until the next merge window, there
> are no deadlines here that require this to happen for 4.4-final.

I'm actually not in a rush to get the deletions in, or to get the
cleanup patches to hfi1 in, I'm only trying to enable getting the
library development started.  Right now, it's blocked.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--qpkkMEeukpxoXdU4KepQpqBWda2tSTlvh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWT1yDAAoJELgmozMOVy/daTYP/jNlnJEHSnzdnt4rdjTAZPQ1
O6aTQ3vP9x+T3ofLKvZWpgxVVuSCkqBT9L5wgAJzy979CjjOvbCcUhHD0rTf0uGC
4hPeooCXuDvEH7vVK+zJmQNmtXUsvTGg05G48wb7dNKORqbW16GKuMs06iCiQwfI
bDhevJ9mh1stEIgQnVilmuZ7WjE0mpCfixgt7vFgSs9ABBgPi7QaomrmDca5iGyP
fcQx/8Hg6kZDbCEXuHe23TFHfVfTE4Gy870lnJGE0oT0KcO7p3zV+XxU8BU2OauN
MdurEN/+ZJ9xfT0L+B0w/m83T2JvZavet+tT4Rrw1r0HkPSts10YrxGEKzScCYtW
XPhShf80SwzvdbpYuZgpNMs68H66B7l+R8l/+CdRMakKtzgRexZ14nP/Bna4nHRX
yVBqhHMo0G0l9A1Aw3daRrDxDPZ0gxuulZPSzyVngiZowr4o/ftnKsDmB2xTHRNL
qpqnfbllGfSz+kD71KKBIka/qaP38JBQCL7XVe/UjUBfN3U8uR84wfBqo0ODUfVi
o3pbRMWsAEOIIgdyHCKIMKu4TBMsNcKu1rlew8JuKlehfJfWk/3385ASz6M7uBjd
GgmdPJbPih742w4Z07xdWI36R53YNz9rSYe0LS8zJzq9AP+l/XBwsCfqiVGpHlUi
NVP3zZLdE9ZtvUcUfyl1
=M1+C
-----END PGP SIGNATURE-----

--qpkkMEeukpxoXdU4KepQpqBWda2tSTlvh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
