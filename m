From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Thu, 5 May 2016 14:57:01 -0400
Message-ID: <72645a3b-5945-419a-d7af-1c065080e415@redhat.com>
References: <20160502195502.GA31800@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7D6Nij45lIHRGJ3mM2oBsqn6fDlTikGaP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160502195502.GA31800-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7D6Nij45lIHRGJ3mM2oBsqn6fDlTikGaP
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/02/2016 03:55 PM, Dennis Dalessandro wrote:
[ snip stuff about the UI file ]

The UI file discussion appears to have reached a reasonable conclusion,
so I'm not going to add to it.

> We also should be able to use any of these schemes to handle our eprom
> reading/writing. Adding eprom to IPoIB as Doug suggested is a fine plan=
,
> but
> we technically don't need to do it right now when we could make do with=
 the
> "UI" functionality and hide the details in user space. In the future
> there may well be value in having an eprom capability in the rdma
> sub-system, but for now we believe we can avoid extending the kernel in=

> this regard.

I'm not sure I agree here.

First, on the "technically don't need to do it" and "can make do".  At
least one of the points of these reviews is to identify and squash cases
of "technically don't need to do it" and "can make do" when it revolves
around doing something half-assed that should be done properly instead.

The cxgb? drivers use the kernel firmware load mechanism.  I'm fine with
that.

The Mellanox drivers use a custom, user space tool.  I *was* fine with
that, when it was a one off thing.  Now you are talking about doing the
same thing, and it's going to become a two off thing.  That makes me
somewhat less OK with either one.

Upfitting IPoIB to pass through the netstack eeprom stuff should be
almost trivial to do.

1) Add eeprom_get and eeprom_set routines to struct ib_device
2) In driver, set eeprom_get and eeprom_set in ib_device
3) In IPoIB, copy eeprom_get and eeprom_set from ib_device to ethtool ops=


Everything else is done in user space.  You can use ethtool, or you
could write a custom tool to do the trick.  Mellanox could do the same
thing and modify mstflint to just pass the work to the ethool entry
points while still retaining all of their FS/IMG/GUID/MAC/PSID magic in
mstflint.  For your case, if all you need to do is to write a new file
to the eeprom, you should be able to do this:

cat <binary-image> | ethtool --change-eeprom DEVNAME magic MAGIC offset
0 length `wc -c <binary-image>`

and the eeprom is written with the new data.  If you need to do special
things, like Mellanox, in terms of recovering burned data like GIDs or
MACs or whatever, then you can write a tool that does that, but leaves
the EEPROM banging to the driver and just passes the buffers around
using the ethtool interface.

Really, it doesn't look hard at all, and it sounds much better than
continuing with everybody writing their own tool and reinventing the whee=
l.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--7D6Nij45lIHRGJ3mM2oBsqn6fDlTikGaP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXK5d9AAoJELgmozMOVy/ddVcP/ApHaIHC/VtiwdSutwNJN220
oh3lL3U/mosAEWcS2pthRcZzelr/ZrvFZBWI/eFsrvawx9X+cHcXWJ4boTvlGKvW
E8oZF3+EO9TcYvnvzYVlLEJlZUywZuOdoQR6kNcueX2rx000QVS0DtJ+/2wka9m3
Od/At8C5pXYDQqVxu0ir/KF64NrRhg2+sbG49GcZPO9vmJszLW0zHF5ADjIxieLr
69QYARk0uOcULBFZz5NJLsNU0uQr4uo/56Iusb/K8QUABkH+T9LC/6Y2Q+454f+h
oUnC7k8e2YAaneHnboMQSA9i42Q+BS/VHHRHD6qJApTpjRidQGAUNOfq6jEXkNlK
nP0xM2VhVSHU90FtiFF+faHhkzMdFQdt5dWwi/V9Hp4DIVBAt6LMRs/6csLpY/1z
0zC+9hUA6zfb/po5hSPlNucctGWGArYYjUxb2TnTZLr4jno+YQXFxtBHQifoWXKG
E6jXLUk8x9B3pSz7PWHwkHUwG1K+kqUDi1Lv8/jFP9a85FWttXEv9lUyuXdPqp2E
I/9jSxwMaxx24KYw4MznNajGnYWfUF/CgXO7MiagfNFPaoGeQvOWkQJq5IwSBExZ
lesCzpS2zblLWkZkfpxCqOOXMMiHbxbz1i4P37Q3mBqXo2FIgOmiBnufH9OhtKD9
zTsRJixqbUC1DEQuMxT1
=8Dk6
-----END PGP SIGNATURE-----

--7D6Nij45lIHRGJ3mM2oBsqn6fDlTikGaP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
