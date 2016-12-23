From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] Remove atexit and destructors
Date: Fri, 23 Dec 2016 07:09:29 -0500
Message-ID: <bdea7a08-49e9-6ee3-02e1-d9be573e789e@redhat.com>
References: <20161222221047.GA15780@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Fk1uwuewM1tjJmVib2hPi5KlRumi3dLxT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161222221047.GA15780-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Fk1uwuewM1tjJmVib2hPi5KlRumi3dLxT
Content-Type: multipart/mixed; boundary="78jBXfj8u9gh9BjjbS14SkNnCDfewO865";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
 Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <bdea7a08-49e9-6ee3-02e1-d9be573e789e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] Remove atexit and destructors
References: <20161222221047.GA15780-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20161222221047.GA15780-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--78jBXfj8u9gh9BjjbS14SkNnCDfewO865
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/2016 5:10 PM, Jason Gunthorpe wrote:
> There is no guarantee how a process will be exiting, specifically there=

> is no guarantee that there is only 1 thread. This means what atexit
> handlers can safely do is very limited.
>=20
> In particular freeing resources that would otherwise be freed by the OS=

> is absolutely wrong in a multi-threaded environment.
>=20
> - neigh.c: This deletes the netlink socket
> - ocrdma_main.c: These delete locks and free devices
> - cma.c: This frees pds and other objects
> - amp.c: We don't need to wait for a thread to exit if we are
>   exiting.
>=20
> This fixes a crash on-exit observed with at least rping where a
> thread calls exit() while the main thread is still running.
> This creates a race where rdma_destroy_id() runs concurrently
> with ucma_cleanup() and one of them will randomly crash with a jump
> to NULL.
>=20
> This will create some leaked memory complaints from valgrind
> mem checkers. These need to be solved with sensible resource
> tracking to free the objects once all possible users are gone
> and not relying on atexit.
>=20
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

This all looks sane, thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--78jBXfj8u9gh9BjjbS14SkNnCDfewO865--

--Fk1uwuewM1tjJmVib2hPi5KlRumi3dLxT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXRP5AAoJELgmozMOVy/dQCYP/isiea9WVrcUokXC5aAdJiKs
DklQdBI6+qA8ybKkJkUBeaNgkj85Zba48PhMgmwjtTJb1j5HwHCpUBpmojcGGKCX
nBkvPQ427UwWvc0ZpHHTnzn4JPU3hQAvPq0GRMeuCHAZI+MhhRSjP6UV9ttZW+ja
8/r3OOE7RsPpPjwoiXU4hDVI9Yhsaf0p1/KlMIhDUHNDPa3KEWF4ct4Wjlt8s2Bu
3pwqfCvou5NSoiLXHo9f/uQpVyzFa2RQi61l2+C3VIIk/8YlnoH7hBD6FUbMygtz
HOOsXu5o49i7DAi113SMpB7hN9czIQjpMmAb4SgPxnXttPD4olrT8s1aEv5ToDLJ
Bz+JVGgHC1l1oQn4EtaB0vmPV/Xfm6TFKwLBOiKhB9x1wkvf3YtZiUdkPXgBtnwv
jFCwMTv3vMMCAqqIx4dzKbuDNWaTqvZOAF0oFALqrBN4srzRQj9a0YN8ncCZp5Vq
Tw4TYLiakqKkoIfWpqaJIaP31lUSYFKHTINpG5eIYULmIMKExol/yCKTMtyL7FSO
A5p90X3AECcN8jGZEu4Dtrow3/nBsS6eQvOXBgXQ2cja/hL8O7tn9INMY/NZ+YY0
7e7BK79MAT8TPCUQ5+k1ih/0Ij/P9THCiKrlI1bGvaDQTCI/Kdsy2OW/jhCAU+0x
mlEZ6lP+E+yM5+RDvQSs
=xp9z
-----END PGP SIGNATURE-----

--Fk1uwuewM1tjJmVib2hPi5KlRumi3dLxT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
