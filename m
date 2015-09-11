From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: ehca driver status?
Date: Fri, 11 Sep 2015 11:44:06 -0400
Message-ID: <55F2F6C6.8060002@redhat.com>
References: <20150826134648.GA21814@infradead.org>
 <20150911105513.4bbf9e9e@worktp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BPNac9OKHLgdh60hjareWbVMCOC1383Rp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150911105513.4bbf9e9e@worktp>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BPNac9OKHLgdh60hjareWbVMCOC1383Rp
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/11/2015 04:55 AM, Alexander Schmidt wrote:
> On Wed, 26 Aug 2015 06:46:48 -0700
> Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>=20
>> Hi Hoang-Nam, hi Christoph, hi Alexander,
>>
>> do you know what the current state of the eHCA driver and hardware is?=

>>
>> The driver hasn't seen any targeted updats since 2010, so we wonder if=

>> it's still alive?  It's one of the few drivers not supporting FRWRs,
>> and it's also really odd in that it has its own dma_map_ops
>> implementation that seems to pass virtual addresses to the hardware
>> (or probably rather firmware), getting in the way of at least two
>> currently pending cleanups.
>>
>=20
> Hi again,
>=20
> we are okay with removing the driver from the tree, let me know if
> there is anything we should do to help.

I'll get it moved over to staging ASAP so it can be on the same schedule
as the other two drivers we are deprecating.  Thanks!


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--BPNac9OKHLgdh60hjareWbVMCOC1383Rp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV8vbGAAoJELgmozMOVy/dj0sQAI6kMvIxvXNlvcqcARAcdi6v
Td8KcqS+M7Tsl3uYUXLo6+uk/q8HzNyNy26sAnq28+S5ZAeawX6OHYqsMtEKosw9
vffM44wae0hbbTYB2xwqXPWIHS5+0JEjJor7qcSrtxje+n+eSM6FkGmBdG4FRtKD
8Q57k0yngLsNZu0Pte7w9IC+hvadChVXLOeKD0A31XO/qESL2/5P//s2IRODEca5
58EV4IRh5PvaqT7HQcOxn+H924uyhKyWTEN3nI0SI7MUOdEqk3jncYQvas17vEXM
2m+4PtGv/iZiDmJImbST4Fh1MuaeXGOLnogADbgEqrxhanoD/Jl+eEohbG6yKRwh
aBprHVcJz95tsVm7PgO/c2wxGZAih5pxubFyaKC+7hYznFxTA73koSFpLXx5R0cy
glUWjTPRBXF36zmJ5uY2NABc2WJpTpi43PYjNovPVQvdlknFPTbdvwZGFU/YgaY+
N6LUfzbnx0vuE5tLzKio4LLWIRtjxHRpmhkugoweTBRvAciaOLId+5fMzi0aXKcV
P/tClbu1Leu8dpcJ4MwJwatBKG60NHzlYV28gvQX2wUWu/8wD7u+hamGYEQfLwNR
lYn5g8cXjfjEWDgAUgcIt3ok12FUm5esXkBvgX4lnjNdzpJd/Izwa0Ny/vsWG5Ty
4wsQb6X6UXMkelLKi1PB
=dE1K
-----END PGP SIGNATURE-----

--BPNac9OKHLgdh60hjareWbVMCOC1383Rp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
