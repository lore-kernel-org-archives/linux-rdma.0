From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: building rdma-core from travis
Date: Tue, 18 Oct 2016 08:08:34 +0300
Message-ID: <20161018050834.GF25013@leon.nu>
References: <1828884A29C6694DAF28B7E6B8A82373AB096A7B@ORSMSX109.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB096A91@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xkXJwpr35CY/Lc3I"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB096A91-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--xkXJwpr35CY/Lc3I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 18, 2016 at 12:06:19AM +0000, Hefty, Sean wrote:
> > CMake Error at CMakeLists.txt:23 (cmake_minimum_required):
> >
> >   CMake 2.8.11 or higher is required.  You are running version 2.8.7
> >
> >
> > I can see that travis runs successfully against rdma-core.  Was there a
> > magic setting used to work-around the travis version?
>
> It looks like rdma-core requires the 'trusty' build on travis...

Yes, you are right.
"# We need at least cmake 2.12, this means we need to use trusty."
http://marc.info/?l=linux-rdma&m=147587977913428&w=2

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--xkXJwpr35CY/Lc3I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYBa5SAAoJEORje4g2clinuPkQAMFOB8b7k3Ldu6Vemtx0zXe0
8MUED7ffK6V94NE6O1qQQXvHAPaKmzJ/6v07yjMOd5fmddbLBWKk574iiobsZ+wT
jBV3JfQkkXirsIAym1FK6pv2LixYYcg/kJaknUs/iUxyX7ZwBeSEQVzTCU7JOtwy
YFtrCoXjMwRLpxvzyh6INwPZfVuOMEQFb6ZkBr5lELf8wh4DOZba6JdEM/nNauWl
ES+ldT/oJBrQY+FQ42trhxoccU+Dy7BeCD5Fhn9D5oXVSCmPe9ZqaQhRxPY1H974
qbruuOPfbcE/haKH05MEuxLwFeZjT5xedDnrbQ3GRp1F9/l5GF1k0MF8BwU6I+RP
3uuMUfsB4pBFXq73BLpr2pKkoedzTXUjkRoFkKnvY7gBN6d6xsxGjwK4kiRulCY4
DQzPK3MsFSuhVo6e1NEvYK0wieTxMmX0A0loJq2Ora7bGaEidDkFIbxMIex8Tkpi
+rZYP+wNHjhqqbD/uKYAfPQpuNLDasjXcyEoVp/09juQ/JKCy/MtjTpeKe4RcmDV
haou30A6ICPfLr3QAbRn/GFmjYI34gJqlHf/nTj4WQsOv1HgV5X0eMgJdQOOlau3
6jAF9DnOhBa+U6HGiNjCTzZDjrlg9WuBD5Rkim0QlmG4r8t3EH1TKmDhf6s/l1ag
IM5IWD1yagIrF8ipNwkA
=juWl
-----END PGP SIGNATURE-----

--xkXJwpr35CY/Lc3I--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
