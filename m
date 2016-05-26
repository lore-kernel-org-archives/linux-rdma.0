From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/10] IB/hfi1: Add ioctl() interface for user commands
Date: Thu, 26 May 2016 12:08:38 -0400
Message-ID: <d7286d9b-7763-2c29-c700-b4dd88870f91@redhat.com>
References: <20160522140351.GA10696@phlsvsds.ph.intel.com>
 <20160522175715.GD25500@leon.nu>
 <20160523122207.GA16764@phlsvsds.ph.intel.com>
 <20160523130312.GG25500@leon.nu>
 <20160523141049.GE16764@phlsvsds.ph.intel.com>
 <b9dc4ac8-cfa2-d66e-7e36-f28116f23e59@redhat.com>
 <20160524175409.GI25500@leon.nu>
 <a4477030-c966-636e-e395-96857454c7de@redhat.com>
 <20160524201317.GK25500@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB050188@ORSMSX109.amr.corp.intel.com>
 <20160524205425.GA7950@obsidianresearch.com>
 <d4913637-7167-8491-88ea-fa65d1e0c22d@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="agRlxifacWDgDgu7N1uS6sX0vrjDM4CJK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d4913637-7167-8491-88ea-fa65d1e0c22d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dalessandro Dennis <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haralanov Mitko <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Weiny Ira <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Marciniszyn Mike <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--agRlxifacWDgDgu7N1uS6sX0vrjDM4CJK
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/25/2016 01:56 PM, Doug Ledford wrote:
> On 05/24/2016 04:54 PM, Jason Gunthorpe wrote:
>> On Tue, May 24, 2016 at 08:29:41PM +0000, Hefty, Sean wrote:
>>>> Let's assume that you are planning to provide block of 20 ioctls per=

>>>> device. Right now, there are 10 (or 8 if we count driver families) d=
rivers in
>>>> drivers/infiniband/hw/ + 1 is coming (HSI) + uverbs (approximately 4=
0)
>>>> =3D> 8 * 20 + 20 + 40 =3D 220 ioctls =3D> we already in shortage wit=
hout room
>>>> to expansion.
>>>
>>> Ioctl commands are naturally scoped per open file.  Unless the
>>> opened file supports ioctls directed to every piece of hardware, I
>>> don't see why there's an obsession with command space.
>>
>> The kernel standard is to have ioctl numbers be globally unique, even
>> though technically you are right and they are scoped to a file.
>=20
> A not very well followed standard...
>=20
>=20

I took this patch, but I moved all of your ioctl numbers to the end of
the range by doing this to your declarations:

/*
 * Make the ioctls occupy the last 0xf0-0xff portion of the IB range
 */
#define __NUM(cmd) (HFI1_CMD_##cmd + 0xe0)

struct hfi1_cmd;
#define HFI1_IOCTL_ASSIGN_CTXT \
        _IOWR(IB_IOCTL_MAGIC, __NUM(ASSIGN_CTXT), struct hfi1_user_info)
=2E..

The intent here is that strace or other tools should be able to decode
the IB ioctls.  Since we are starting at the low end, it would be a
*long* time before we would ever get up here (if we even do).  Between
then and now, these will go away to be replaced by the vendor channel
support or something similar from verbs 2.0.  So I don't really care if
strace ever decodes these until we get official ioctls for the IB stack
at this location, and by then it doesn't need to know these ever existed
as they will be long gone.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--agRlxifacWDgDgu7N1uS6sX0vrjDM4CJK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXRx+GAAoJELgmozMOVy/ddLEQAIqgBJP68Emxg7w8ph26+imc
93FpXuC983MLywbbVvrAeW+yKUcwPTPq+qOxjK4/F6zs+/PZUCsiubHDg1/IKsfr
y6lY0YYaVKjrGLcI64RUvlC4bVHK4vZ9NHSLnRUCuqXuLLBzrhwoKlxBD/6UH93l
d95CepuYWLyfvIYl8C5+iufBwHk6bpxTVyRyQjnasL85M0KeaIXpWMFYqk8GTRUF
g66WTdBTYztNU7h17wAa14fmBfU0j0q1W8Occ0i/33vKtcUttgt2qPVppBMwdstd
hgDBhcIODSt2wHY1IwAqVzttNzdzHYx+h0eYIBDa1kDpb1gaG/31cP9LWt8A0jlD
iytutvimqhG7/4U4j8Il2pvDfwxlfPlMlZEvSbFl6PewkpELpZ4mpE/AVbwWqN8q
vV4pH6R6RMTafjjWOirwzKSUU0RJk8aI8BXdYNl29D692/m5wyGiqjnKhpTvIKJc
WLK3QMZgQWIDEkv76jrg8MiXlYi5U8HJt28u3MYt1PtQa/mLgL2+Cwkfi7S852fB
at8zTF/7gk1z1dxeYnONSUnZQdaQdIxdQzQ08Ypp2483bMUf37ouVgDIdF8pfoDb
rs0rv4JX7iGTk5nl2rSaVTxgCRm6wddM2c6ppXDlL1YiR4Pl8Djtj3kwLXLekmqU
dkfdjHFquOZHA4Vi9lUV
=FWq8
-----END PGP SIGNATURE-----

--agRlxifacWDgDgu7N1uS6sX0vrjDM4CJK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
