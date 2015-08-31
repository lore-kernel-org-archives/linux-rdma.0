From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: mlx4 problems with 4.2-rc8
Date: Mon, 31 Aug 2015 18:13:53 -0400
Message-ID: <55E4D1A1.3060608@redhat.com>
References: <55E142DC.8060205@redhat.com>
 <CAJ3xEMj5By11L3qbSKxcEiMarB6CeyeERMnuK_vvH11VLLFypw@mail.gmail.com>
 <55E385DB.2@redhat.com> <55E3FDAB.10706@mellanox.com>
 <55E45058.1070105@redhat.com>
 <CAJ3xEMjp+3Y0y2d-K-zi9SnBSshN_C5x5KLY3oCpD_XriDCsWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RawoH5rCLWLiICI2HKxWRPKfbrKUnpr5f"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjp+3Y0y2d-K-zi9SnBSshN_C5x5KLY3oCpD_XriDCsWw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RawoH5rCLWLiICI2HKxWRPKfbrKUnpr5f
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/31/2015 04:21 PM, Or Gerlitz wrote:
> On Mon, Aug 31, 2015 at 4:02 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> On 08/31/2015 03:09 AM, Matan Barak wrote:
>=20
>>> Actually, it looks like the dump stack we've got before [1] was fixed=
=2E
>>> This happens when the mlx4 driver is used in setups where number of
>>> cores >=3D 32.
>=20
>>> Doug, is that the case?
>=20
>> Indeed, 48 cores on this machine.
>=20
> so do we have bingo here? the patch is in the net-next tree (and we
> can't put it in 4.2 only through -stable since 4.2 is released by
> now), does it solves the problem?

Yes, it solved the problem.  I pulled the patch into my testing branch
to confirm.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--RawoH5rCLWLiICI2HKxWRPKfbrKUnpr5f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV5NGhAAoJELgmozMOVy/dGn8P/09gGQK8G1lkg86bMGSOU/hn
Q26iGHSjit6GRcFSELEWxJGTwFyS7pgJsDQ2TO4I/G6CkQKWuC8tEyE6JCHsVWsQ
xH0HyqQ9U01zVPZIlpqAiiO8h0BkCAtEv2T2I/4n9ZPhJEjhCD7rRnKEw5MI1k4n
MzSVfOQhEhvnsrYAbTsR/xnR9zd2+ZkDv6WU/jvp83fUM9S6KTUVCfz1yFTB4fti
uyehBIW+IWvE03G0TCnr7uoYkTe8Oe4nosxV97AK40KyuDgrWt7JTATpZbhzajM3
S+wnavo4IJ3ydr7p4vFu9MpMDDUc7YHzCdpS2TcfyDxb1MR3rR2hWbsMvdl1TQtd
128oTeWWycM4SnbjqDdVh8SA4nkwZp4KpjYPMoJ5v8B8ymIqUrZStNnSOT5Qg3ZM
Ii3vErn5xnihToDRhumg4gxIoCE+TEasmEkAvQ811jpY158tKth+rBpSFWkaF2lr
MDfzLc9rsQotRpTMHIXebyoDhnLmK/rXjXVHA8CQ5/oaAiIcAiHXDFnP/v/25kaU
xzcFaloJ4R+bZdUaWLsGZFhXkBay7j6JdwzpuSxmdqPiPNfhi1ENYqOocxtvGOaH
LWLoiWED++Q6q2rLWed0hpy54pRVMkUZiO/OW6gtAAlsalLCFU8aIGZDi/gk8vDI
MXhR68mrojMbAXZ8TuE7
=bM+F
-----END PGP SIGNATURE-----

--RawoH5rCLWLiICI2HKxWRPKfbrKUnpr5f--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
