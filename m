From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 17/50] IB/hfi1: add PSM driver control/data path
Date: Thu, 30 Jul 2015 18:10:41 -0400
Message-ID: <55BAA0E1.7000402@redhat.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <20150730191859.25256.28987.stgit@phlsvslse11.ph.intel.com>
 <20150730194041.GA28754@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC25777DA0@fmsmsx120.amr.corp.intel.com>
 <55BA9A38.2030401@redhat.com>
 <32E1700B9017364D9B60AED9960492BC2577809D@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iuDPPqbWFW3oPeb4Gw6EqWCllISOVvWKM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC2577809D-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iuDPPqbWFW3oPeb4Gw6EqWCllISOVvWKM
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/30/2015 06:00 PM, Marciniszyn, Mike wrote:
>> On 07/30/2015 04:01 PM, Marciniszyn, Mike wrote:
>>>>
>>>> I thought you were getting rid of this?
>>>>
>>>> Jason
>>>
>>> Doug wanted the v4 submitted as we currently have it.
>>
>> To be accurate, I said "If you want a chance at making 4.3, I need a v=
4".  I
>> didn't comment on whether or not any specific review comments were
>> addressed.
>>
>>> Doug?
>>
>> I have no problem with this code.  That Al finds the user space ABI fo=
r this
>> driver to be bizarre is neither here nor there to me.  Sure, this file=
 does not
>> exhibit normal file API behavior.  Who cares?  It's not a normal file =
in *any*
>> sense of the word.  For example, the normal write routine will never, =
ever
>> accept just plain data.  It's always in the form of a command.  If you=
 don't
>> have the right magic decoder ring, you will get nothing but errors whe=
n
>> trying to do something with this file.
>>  Much like /dev/infiniband/uverbs? files, it is a command interface, n=
ot a
>> raw data interface.  I actually think the fact that you guys use write=
 for a
>> single command and writev/write_iter for a command queue is an elegant=

>> solution to your particular needs.  The only reason Al threw a hissy o=
ver it is
>> because it tripped him up when he went to do the conversion from write=
v to
>> write_iter.  That's understandable.  So, some clear documentation so
>> someone like Al doesn't have to go reading through sources and try to =
figure
>> out what you are doing would be the generally nice thing to do for oth=
er
>> kernel generalists that might come poking around this way.  Or, anothe=
r
>> option would be to drop the write function altogether and just make al=
l
>> commands come through writev/write_iter and if you only have one
>> command, you only send one element.  Regardless, those things can be
>> cleaned up in follow on patches, please do not resubmit this set for t=
hat.
>>
>=20
> Jason,
>=20
> I did ask you in http://marc.info/?l=3Dlinux-rdma&m=3D143707462806767&w=
=3D2 if you thought ioctl was ok.
>=20
> Hearing nothing, we left the interface as it was.

I think the interface is fine as is, with the only thing I would do, if
*really* forced to by Al, would be to do as I suggested above and
convert all of the write cases to writev with a single element.

> I suspect (I lack the early history) that the ioctl BKL might have forc=
ed both uverbs and PSM to go this route.

An ioctl interface is not really designed for a queue of commands to be
sent in a single operation any more than any other interface is.  I
don't personally see a great benefit to it.

>=20
> Doug,
>=20
> Where would be the appropriate location to document?  In the source its=
elf?  Somewhere else?

At the function for both write and writev (and a patch to update to
write_iter would be a good next step to keep us in line with qib),
document how each is used and point to the other one and point out that
they differ in their basic usage.  If Al had a clear comment saying "our
write function is used to pass a single command to our driver, and our
writev function is used to pass a queue of formatted commands, one per
element", he might have not written what he did in his commit message.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--iuDPPqbWFW3oPeb4Gw6EqWCllISOVvWKM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVuqDhAAoJELgmozMOVy/dKmAP/jyH6PyeAYkWnQhjkp9/LnTB
yejnVcCFLrsUpKlDyikCzkYTaOmQK2XMCyFCfhGFEzgllkrsl5OnIher1cBGuwXY
us1st84GHju+ZlFRqm2/FXAkccsPZx9d2s5PC+1+EcqlAet+JXz01XyNeOe3lBOP
S5XCBcpCkwl5t4X43MN+UrWDOXsZTjHr2H1tkpHzLUb9MtIBVywL4wbc762dIj0l
OkAhe+MjsdIg6QH1hOwXMVPz4CjZ6g0dGr3imwYFc3k6zd9nP26kMJ8HeK/g904D
khDPkZ0tco0Y2GZSB8407BEBfYUJJLDJHRCjfYpLN4HJJ8+925pcwIJ/BOs2k9so
xyNWQXZ8AgKEJsAKWfjfjS99NvMllgbj+alUQgaewKrraYojjv+T8gO7rS0rYtrI
WOm2J7Db+eEyWKI2/FcXVcJCac7EWlgiPfgoVp9VX/nzf9jp6yyRxCU0OcPGnym4
74WR2WQaE1IVK8B/iZmdp0OpPmchoealcjCEmxQGyRRey1vCAQngUQ/yZQi5zFsm
ZaYgv1OKG/vNKR8IzKhyEEv4fpGGq71alUryV05zbNkjeB4O40+UoQit1ihE69YO
7WmslmYnYnjK0sih1QtKj9bM8WdxjI8dS4IG+cQNYbO2TFt6sHHQi9xtnfBukI93
CmOHMSSglyr/IZKSzH1t
=TsX+
-----END PGP SIGNATURE-----

--iuDPPqbWFW3oPeb4Gw6EqWCllISOVvWKM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
