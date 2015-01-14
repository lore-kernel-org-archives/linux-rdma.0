From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH FIX for-3.19] IB/ipoib: Fix failed multicast joins/sends
Date: Wed, 14 Jan 2015 14:08:10 -0500
Message-ID: <1421262490.43839.253.camel@redhat.com>
References: <c903a4f1282f7d5852157c68bcc3f4324fd4300f.1421217352.git.dledford@redhat.com>
		 <54B692FB.1010904@dev.mellanox.co.il>
	 <1421251762.43839.249.camel@redhat.com>
	 <54B6B9CA.6090208@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-qqMtkTEz8lvRoecEmOb1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B6B9CA.6090208-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-qqMtkTEz8lvRoecEmOb1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-01-14 at 20:47 +0200, Erez Shitrit wrote:
> On 1/14/2015 6:09 PM, Doug Ledford wrote:
> > On Wed, 2015-01-14 at 18:02 +0200, Erez Shitrit wrote:
> >> Hi Doug,
> >>
> >> Perhaps I am missing something here, but ping6 still doesn't work for =
me
> >> in many cases.
> >>
> >> I think the reason is that your origin patch does the following:
> >> in function ipoib_mcast_join_task
> >>           if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
> >>               ipoib_mcast_sendonly_join(mcast);
> >>           else
> >>               ipoib_mcast_join(dev, mcast, 1);
> >>           return;
> >> The flow for sendonly_join doesn't include handling the mc_task, so on=
ly
> >> the first mc in the list (if it is sendonly mcg) will be sent, and no
> >> more mcg's that are in the ipoib mc list are going to be sent. (see ho=
w
> >> it is in ipoib_mcast_join flow)
> > Yes, I know what you are talking about.  However, my patches did not ad=
d
> > this bug, it was present in the original code.  Please check a plain
> > v3.18 kernel, which does not have my patches, and you will see that
> > ipoib_mcast_sendonly_join_complete also fails to restart the mcast join
> > thread there as well.
> Agree.
> but in 3.18 there was no call from mc_task to sendonly_join, just to the=
=20
> full-member join, so no need at that point to handle the task. (the call=
=20
> for sendonly-join was by demand whenever new packet to mcg was sent by=
=20
> the kernel)
> only in 3.19 the sendonly join was called explicitly from the mc_task.

I just sent a patch set that fixes this.

> >
> >> I can demonstrate it with the log of ipoib:
> >> I am trying to ping6 fe80::202:c903:9f:3b0a via ib0
> >>
> >> The log is:
> >> ib0: restarting multicast task
> >> ib0: setting up send only multicast group for
> >> ff12:601b:ffff:0000:0000:0000:0000:0016
> >> ib0: adding multicast entry for mgid ff12:601b:ffff:0000:0000:0001:ff4=
3:3bf1
> >> ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016,
> >> starting sendonly join
> >> ib0: join completion for ff12:601b:ffff:0000:0000:0000:0000:0001 (stat=
us 0)
> >> ib0: MGID ff12:601b:ffff:0000:0000:0000:0000:0001 AV ffff88081afb5f40,
> >> LID 0xc015, SL 0
> >> ib0: join completion for ff12:401b:ffff:0000:0000:0000:0000:0001 (stat=
us 0)
> >> ib0: MGID ff12:401b:ffff:0000:0000:0000:0000:0001 AV ffff88081e1c42c0,
> >> LID 0xc014, SL 0
> >> ib0: sendonly multicast join failed for
> >> ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
> >> ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016,
> >> starting sendonly join
> >> ib0: sendonly multicast join failed for
> >> ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
> >> ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016,
> >> starting sendonly join
> >> ib0: sendonly multicast join failed for
> >> ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
> >> ib0: setting up send only multicast group for
> >> ff12:601b:ffff:0000:0000:0000:0000:0002
> >> ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016,
> >> starting sendonly join
> >> ib0: sendonly multicast join failed for
> >> ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
> >> ib0: setting up send only multicast group for
> >> ff12:601b:ffff:0000:0000:0001:ff9f:3b0a
> >>       >>>>>> here you can see that the ipv6 address is added and queue=
d
> >> to the list
> >> ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016,
> >> starting sendonly join
> >> ib0: sendonly multicast join failed for
> >> ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
> >>       >>>>>> the ipv6 mcg will not be sent because it is after some ot=
her
> >> sendonly, and no one in that flow re-queue the mc_task again.
> > This is a problem with the design of the original mcast task thread.
> > I'm looking at a fix now.  Currently the design only allows one join to
> > be outstanding at a time.  Is there a reason for that that I'm not awar=
e
> > of?  Some historical context that I don't know about?
> IMHO, the reason for  only one mc on the air at a time was to make our=
=20
> life easier, otherwise there are locks to take/manage, races between few=
=20
> responses, etc. also, the multicast module in the core keeps all the=20
> requests in serialize mode.
> perhaps, you can use the relevant code from the full-member join in the=
=20
> sendonly joinin order to handle the mc_task, or to return the call to=20
> send-only to the mcast_send instead of the mc_task.

I reworked things a bit, but yes, the send only task now does the right
thing.  Please review the latest patchset I posted.  It's working just
fine for me here.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-qqMtkTEz8lvRoecEmOb1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUtr6aAAoJELgmozMOVy/d6hYP/11HnCtZh5mbSkeZkb8sBEnA
VHE83uw7THT2QXBXehM/vbmT8/C0oQ68e0pDsb6HOXqInlFoeVmjsc6VNFZkceWx
aOwATNFf983J17W0lX6ib3VXph0JkGbijLTl59/zE2PuIY+cM3F8z4RyZH9o7qGW
hUeAArnnjzqIu6S7dbqx4Pb2OjfbwsV+TOuEEiD0L+NDcIVcTtQhZPhZoaSd3xAn
ro8FTdwqb4D6CojH6qzFoUlLeRYKmBo2ukY6QpPEnIno0G/K+Q4ZGiUo1CJrBmVx
5muKeCV3Mp/EVa0a6hjAPjZ5Rc5mgYy9T2wKL45DoYs84Q+/6yuBeb/puwNr0AWv
mrgPNn2iVQ1JUm8dxKRD3zDgCIXRpeS+ERtNkcC8ZoG+7r7U0NwqopX5slI1ukb3
pRR43PvXziXIA0LGsj5S6fPUFDwd3gNsfoypUu5jc/MyenYIKGwAIAkdf3K8ZC/Q
F9YGfO3AtXh8WqLT21cHQrpAi1Pex4Go7GBWcxgFRA2wFL8f3M4VdhIxxg1jL4Az
69tFDJdwclwDmBU0AodIbbtGj6JoPBh6gqKI+/R9MYuTKnvIjT4CYRfT/ddChzJK
MoqN9ITrxIxkFrUomQeHxkLNF0lUTzWWCZ4XeMspvnJpgG3ojWVCcRwlYvyMUlHF
fLBXUGKUcV6kzcg6HW2K
=k0MV
-----END PGP SIGNATURE-----

--=-qqMtkTEz8lvRoecEmOb1--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
