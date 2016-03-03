From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] RDMA/ocrdma: Add RoCE-v2 support
Date: Thu, 3 Mar 2016 09:51:35 -0500
Message-ID: <56D84F77.2070401@redhat.com>
References: <1453989599-21307-1-git-send-email-devesh.sharma@avagotech.com>
 <CANjDDBgVeADqgDTtC1L7QMOLmuH6UE5L3+wXTTetWzKA6+nMnw@mail.gmail.com>
 <CANjDDBhixkF7Fm6y1Uoat-FFm772m=hJWAreCfomqHCa7CxPaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bUHpF3348O7tL8CIPMElq07cpVNFtl0Ob"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANjDDBhixkF7Fm6y1Uoat-FFm772m=hJWAreCfomqHCa7CxPaQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bUHpF3348O7tL8CIPMElq07cpVNFtl0Ob
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 03/02/2016 10:04 PM, Devesh Sharma wrote:
> Hi Doug,
>=20
> Ping, any update about the timeline of this patch series?

I already have these pulled in.  I have an ocrdma branch in my github
repo that is going to be part of the overall 4.6 merge and these are in i=
t.

> -Regards
> Devesh
>=20
> On Mon, Feb 8, 2016 at 4:18 PM, Devesh Sharma
> <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org> wrote:
>> Hi Dough,
>>
>> This is a gentle reminder to pull this patch series into upstream.
>> Please let me know if you are targeting a specific kernel version.
>>
>> -Regards
>> Devesh
>>
>> On Thu, Jan 28, 2016 at 7:29 PM, Devesh Sharma
>> <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org> wrote:
>>> This patch series adds support for RoCE-v2 protocol
>>> on Avago's RoCE enabled adapters.
>>>
>>> Devesh Sharma (3):
>>>   RDMA/ocrdma: Support RoCE-v2 in the UD path
>>>   RDMA/ocrdma: Support RoCE-v2 in the RC path
>>>   RDMA/ocrdma: Support user AH creation for RoCE-v2
>>>
>>> Somnath Kotur (1):
>>>   RDMA/ocrdma: Export udp encapsulation capability
>>>
>>>  drivers/infiniband/hw/ocrdma/ocrdma.h       |  8 +++
>>>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c    | 75 +++++++++++++++++++=
+++++-----
>>>  drivers/infiniband/hw/ocrdma/ocrdma_ah.h    |  5 +-
>>>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 26 +++++++++-
>>>  drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  4 ++
>>>  drivers/infiniband/hw/ocrdma/ocrdma_sli.h   | 16 ++++--
>>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 22 +++++++--
>>>  7 files changed, 134 insertions(+), 22 deletions(-)
>>>
>>> --
>>> 1.8.3.1
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--bUHpF3348O7tL8CIPMElq07cpVNFtl0Ob
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW2E93AAoJELgmozMOVy/dMEAQAIlnPQAAaPuYUEMuUZohtFu0
b48xCQLcxsPXO5h0SSFiq1V5zNYHJiW5zzEPvoVumBhpEbdVCBb/7ar3v9EWL8oY
14JdLs4+kO4TtMnqOQz6hgVMcdLWM87bEAa5tnzi6qYfLly4AsXi8f9MadKThu/S
MbaJUWkB1S0Usy4QhjquXHbhSS5t+R7jEBZzi7gjyXJofq4EyJQc0Hi+3rCxMxtN
2tIhbEjw2X9sLw6Q9EidPvhrlZvmhNK7/PGMa+X3LAVS35XWlZdD42ObBFQF9Xfn
7FtcSk1driW7d3iWj+ra9+h4XBrl+AHpqWR9Bxlqo+rahH9z2OL7yKSLPKCgwccq
embeo3ZEDxjqKf4FPjxvI4cc1LwwHWCxoNcfutyjsJl6hh9ZPIkVyIe3plbhIvoc
Lr3KY90d5lSrOu2CGuHrtrW45qo65K4InhZ+X+Yf1JMj5juNQ+7ENecqecYgat4K
r9jh9LpM7aQsyB/8KlXG7PqXs2Zv2E6iBsP3k7Wtbvy7/baP0o4ZI9UnUuMK06c+
NrUddPML2yazn9XdrreOAYa/9hTCt+kXByiL0CyxW4xFPRghMh2iz4AFPV/eV9+2
j+qsiijFA1v9Y4fkk2vged6elmAuveIeYogS3Ryk+EW0dhoz43k5+7gV6wUQ56BW
8cajqf9U+ucFk2hKK55T
=2Hdq
-----END PGP SIGNATURE-----

--bUHpF3348O7tL8CIPMElq07cpVNFtl0Ob--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
