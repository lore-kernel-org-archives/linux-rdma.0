From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v5 00/10] Fix ipoib regressions
Date: Mon, 26 Jan 2015 08:37:45 -0500
Message-ID: <1422279465.2854.15.camel@redhat.com>
References: <cover.1421936879.git.dledford@redhat.com>
			 <1422031938.3352.286.camel@redhat.com>
			 <54C4E793.2010103@dev.mellanox.co.il>
		 <1422224477.3352.373.camel@redhat.com>
		 <54C616A8.3050804@dev.mellanox.co.il> <1422276712.2854.5.camel@redhat.com>
	 <54C6400E.30607@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-sTfokq2WJxH6d42swvyg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54C6400E.30607-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-sTfokq2WJxH6d42swvyg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-01-26 at 15:24 +0200, Erez Shitrit wrote:
> >>>> The main cause is the concept that was broken for the send-only join=
,
> >>>> when you treat the sendonly like a regular mcg and add it to the mc =
list
> >>>> and to the mc_task etc.
> >>> I'm looking at 3.18 right now, and 3.18 adds sendonly groups to the m=
cg
> >>> just like my current code does.  The only difference, and I do mean
> >>> *only*, is that it calls sendonly_join directly instead of via the
> >>> mcast_task.
> >> Yes, and i already wrote that it is more than just "only", it changed
> >> the concept of the sendonly mc packet.
> > Be more specific please.  What do you mean by "concept"?  And just so w=
e
> > are clear, this all started because the existing multicast code was
> > super easy to break and was racy, so if the "concept" you are referring
> > to is what made the original code easy to break and racy, I'm not going
> > to care one whit that I changed that concept.
> >
>=20
> I agree that you fixed many bugs in your patches to 3.18, where the mc=
=20
> flow was easy to break, no argue about that.
> The only issue that i disagree is about the way now sendonly is handled=
=20
> (and i think that this is the reason for the regression we see now).

It's not.  The patch I sent you off list should be sufficient at this
point to finally put your issues to rest.

> In general, IMHO, the sendonly join is part of the TX flow and not part=
=20
> of the  ipoib_set_mcast_list flow.

I disagree.  I'll get into that below.

> The original meaning of the ipoib_set_mcast_list task that restart the=
=20
> mc_task is to be used for the kernel in order to add one or more new=20
> mcg's macs to the driver/HW (ndo_set_rx_mode), the sendonly mc is not=20
> such object, its mac should not be part of the "mac" list of the driver=
=20
> (in IB wards, no qp_attach for it)

This part I agree with.

>  and from the kernel point of view=20
> whenever it sends packet from sendonly mcg type no need to do the join,=
=20
> it's a regular send, the only reason we have the sendonly join is the IB=
=20
> enforcement for such mcg.

This is where you and I differ.  There is a requirement on us from the
IB spec that we have to join a sendonly MC group in order to do what the
kernel would think of as a normal send if we were on Ethernet.  We
aren't on Ethernet though, so acting like we are to the above layer is
fine, but in our own layer we should be coding to the realities of our
layer.  And that means treating a sendonly MC group like a regular MC
group.

> The reason the driver keeps the sendonly mcg in its mc_list is from=20
> others reasons, the first is to handle the case when the kernel decides=
=20
> to move a mcg from sendonly membership to full-member, one more other=20
> reason is to do the leave operation when needed and not for being=20
> handled as a full-member mcg.

It's been a long time since I first started working on this issue, so
some of the details are fuzzy in my memory.  I think my first 8 patch
patchset is now about 6 months old.  But, I think probably the most
important thing you left off this list, and the one that trumps all the
others, is that whether a sendonly MC group has a QP attached or not, we
still have to account for these groups, we have to track them, and on
shutdown we have to reliably leave them without oopsing.  Putting the
join of the sendonly groups directly in mcast_send opens us up to
problems with synchronizing our mcast list (either due to a dev flush, a
mcast restart task, or something else).  I can't say for certain that
the change to how we record the return value from ib_sa_join_multicast
in sendonly_join is enough to keep the sendonly join code from racing
with the flush code and causing problems.  For that reason, I am highly
reluctant to put the sendonly join back directly into the tx path
because that could have been part of the original problem in the first
place, it's just that my memory of back then is too fuzzy to say that
with 100% certainty either way.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-sTfokq2WJxH6d42swvyg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUxkMpAAoJELgmozMOVy/deSQP/i4B2sdx3LVbkorGqHEb/xb3
/+ABhEgKFBP3zD+GdaL1yQXlLvdWW6CtpKBC+hiKhMyvNTxMsToycGWALAq99oNt
7z6/HXqOFOvO2rSZp4XsU5lGHhtGUFAqgUfPa1rlWYU3DpLMXaSi6FYcw4NLhubG
p0OoaobtrM7pkRZXBFZfmzc80hbpiyKeFlnUYrr5HwldNIxFEIAyftpi01nAlyv/
rmEk5HUT74m0O26dw4LkD+cAo+rHNTJycoDyvnP4rxNkkaSXinfczia/TF7wNFcK
3M/cGBQyyGmP1ha7G8ZJcy02MxFMVJJHfJT3UHO5ECBFeyaEWka5NuOP9Sbjo3Sl
cQcZWV9fY87t0A/3+9kJKlKhnfOG6oTv0ZTubPmXCOpNBGcHDz99EFOwNKsEFaNf
CjM+YpA3BR/IFeOgqRtDb9HnS7QGksCatOLMSzd2IVcoTwvX47xLI4KYEM1mwQqq
pAG9HKWLnkcsGWL3GftGW9AKBK+Ki3WvDZYO2NmRI6dfYZkeEO+Hqqg8xqPgsf6J
hcdX0y8hyPNiyMbsCV/jjAtX8cOBEZZvdxmVwnjW/YejcUsnrNoCwIt/gKJ3DeZb
LVVMM6XH1EL/gVsguJhzOfpX9RgEeqkc9HUldkjiGm1eEvWtc+5455PHR711mF4g
CUbYeo7T/6hcCE5BQQJT
=0Kwh
-----END PGP SIGNATURE-----

--=-sTfokq2WJxH6d42swvyg--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
