From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] IB/mlx4: Fix extended counters support
Date: Thu, 11 Feb 2016 12:46:12 -0500
Message-ID: <56BCC8E4.5030709@redhat.com>
References: <1455179084-4778-1-git-send-email-matanb@mellanox.com>
 <56BCB215.4050802@redhat.com>
 <CAAKD3BDQ7x2JzeWrPz+bzG_otRzWmhEmh8cMJ_DXkYGH+SqAzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Q2LbcKOsteDkrxmsQvcrccNwCBEOrMoFh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BDQ7x2JzeWrPz+bzG_otRzWmhEmh8cMJ_DXkYGH+SqAzw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Q2LbcKOsteDkrxmsQvcrccNwCBEOrMoFh
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 02/11/2016 11:49 AM, Matan Barak wrote:
> On Thu, Feb 11, 2016 at 6:08 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> On 02/11/2016 03:24 AM, Matan Barak wrote:
>>> From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>
>>> Hi Doug,
>>>
>>> This series fixes an issue introduced in 4.5 after applying Christoph=
 Lameter's
>>> "IB 64 bit counter support" series.  Christoph used a mad in order to=
 query the
>>> vendor driver for extended counters support, however this mad wasn't =
handled in
>>> mlx4 when link layer is Ethernet.  Thus, extended counters support wa=
s broken.
>>> In addition, this series fixes a bug in IB/core sysfs which was also =
introduced
>>> in "IB 64 bit counter support" series.
>>>
>>> Patch 0001 fixes wrong handling of port info capability mask, which c=
aused
>>> setting of extended counters sysfs even if underlying device doesn't =
support
>>> it.
>>> Patch 0002-0003 align mlx4 counters sysfs for extended counters schem=
e in case
>>> link layer is Ethernet.
>>>
>>> Thanks,
>>> Eran and Matan.
>>>
>>> Eran Ben Elisha (3):
>>>   IB/core: Fix reading capability mask of the port info class
>>>   IB/mlx4: Add support for extended counters over RoCE ports
>>>   IB/mlx4: Add support for the port info class for RoCE ports
>>>
>>>  drivers/infiniband/core/sysfs.c  |  5 ++--
>>>  drivers/infiniband/hw/mlx4/mad.c | 63 ++++++++++++++++++++++++++++++=
+---------
>>>  2 files changed, 52 insertions(+), 16 deletions(-)
>>>
>>
>> Hi Matan,
>>
>> The first patch is a true bug fix while the next two add the feature t=
o
>> RoCE mode.  Based upon the code patches, the RoCE code should work fin=
e
>> for 4.5 without the new support, there isn't a bug there (they simply
>> won't respond to the ext counters port request).  So I took the first
>> patch for-rc and the next two I'll put in for-next.
>>
>=20
> Hi Doug,
>=20
> I think it's partially correct. In RoCE, mlx4_ib_process_mad calls
> iboe_process_mad directly.
> iboe_process_mad assumes that we should always fill counters in the MAD=
's
> response buffer (without checking it). Therefore, when IB_PMA_CLASS_POR=
T_INFO
> is sent, we'll actually fill counters data. If the sysfs parses this da=
ta as
> "extended counters are supported", it'll call the mlx4 driver
> expecting to get these
> counters. However, this functionality won't exist.
>=20
> If you don't want to merge these two mlx4 patches, we could send a
> patch that catches
> IB_PMA_CLASS_PORT_INFO MAD and returns that only basic counters are sup=
ported.
>=20
> Thanks for applying these patches,

OK, respin the last two patches, but put this explanation in the commit
log of the appropriate patch so that it's clear that even though this is
adding support, it is fixing the broken nature of our lack of support.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Q2LbcKOsteDkrxmsQvcrccNwCBEOrMoFh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWvMjlAAoJELgmozMOVy/dutkQAKGgkjr1rND4FLj1fFjg8nm1
cHM9OqFscCQls8NvLkzbZFMdmF6DegP6Axw5YSG/sV0FqfmzqPaHVLP8P8hNWFHf
c520p9aZ1bjOWiO/04b27OW1AlGrtNFFifB2XLm14m5aJ59CYBkFCjGcpN4EE63+
dHNJsAyQG7jwBF0xNxZAPZteZVmEXVvdpbKbpeTbJTP7lxcG2tbi6Jbn+wldviqj
/Fo6rU/ZtimrRfKvT7hRglUEKvOWFTe+1s+RNpBHLNOT+juDaw7wG5CFIQvgE35B
rMUFRa9AhGv5rYau2ScZqzb848iC1zpzNJ8fb0uUc0es3nqf3zOBNbWkjGdDBNvv
9JUDpXxp8O3Q4bKu4Jc0fTStiDVoXrIv5RRELstDZmLTVT9x3H+6/uZ0sJT79uur
nKOfXoNx6ELoX1XRKypPmvL/poYAeDpQhuR6mOnJScWxWvLIWXlQ8/MyGPTxd/xi
q5UKmidVKucalYj9bGCcosCgfer4l0GLxrwF5x0RKilSN0NonWxO4RSaacgJdK45
x49UZ0+diJYRGL3uxYOnTCLR3r/5KP4RFbfA0WXJkox62SHRJUMU5CsvFQ9I3iav
WGqb7Wy2INWWZpj/SP6cX4VaubF+4CQwtRvlO3IBCU5nFyqCSWUP5EN0qOCxQXX7
1QMZReLhho/4H3I1zmPX
=kco7
-----END PGP SIGNATURE-----

--Q2LbcKOsteDkrxmsQvcrccNwCBEOrMoFh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
