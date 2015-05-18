From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ib/cm: Change reject message type when destroying cm_id
Date: Mon, 18 May 2015 11:04:02 -0400
Message-ID: <1431961442.3114.0.camel@redhat.com>
References: <1431632941-3430-1-git-send-email-sean.hefty@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-S+FPkA8fXB/YKcNRkYMJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431632941-3430-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ted Kim <ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-S+FPkA8fXB/YKcNRkYMJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-14 at 12:49 -0700, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ted Kim <ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>=20
> Problem reported by: Ted Kim <ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>:
>=20
> We have a case where a Linux system and a non-Linux system are
> trying to interoperate.  The Linux host is the active side and
> starts the connection establishment, but later decides to not go
> through with the connection setup and does rdma_destroy_id().
>=20
> The rdma_destroy_id() eventually works its way down to cm_destroy_id()
> in core/cm.c, where a REJ is sent. The non-Linux system
> has some trouble recognizing the REJ because of:
>=20
> A. CM states which can't receive the REJ
> B. Some issues about REJ formatting (missing comm ID)
>=20
> ISSUE A: That part of the spec says, a Consumer Reject REJ can be
> sent for a connection abort, but it goes further
> and says: can send a REJ message with a "Consumer Reject"
> Reason code if they are in a CM state (i.e. REP
> Rcvd, MRA(REP) Sent, REQ Rcvd, MRA Sent) that allows
> a REJ to be sent (lines 35-38).
>=20
> Of the states listed there in that sentence, it would
> seem to limit the active side to using the Consumer Reject
> (for the abort case) in just the REP-Rcvd and MRA-REP-Sent
> states. That is basically only after the active side
> sees a REP (or alternatively goes down the state transitions
> to timeout in which case a Timeout REJ is sent).
>=20
> As a fix, in cm-destroy-id() move the IB-CM-MRA-REQ-RCVD case
> to the same as REQ-SENT.  Essentially, make a REJ sent after
> getting an MRA on active side a timeout rather than Consumer-
> Reject, which is arguably more correct with the CM state
> diagrams previous to getting a REP.
>=20
> Signed-off-by: Ted Kim <ted.h.kim-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

I've picked this up for 4.2.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-S+FPkA8fXB/YKcNRkYMJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVWf9jAAoJELgmozMOVy/dRt8P/1pYm+xpGfvBLw1ydZesZxA+
95KmDL62+CR8IbPQX1OHiOadXHsGli9SCEzpKcc27MpuIiC57MVK4sOVsSNTy+WF
BXuZmrD9lmB+YMt9gaGi63vlit24NpZ8qK8my5EJqi4s8ApMSsuDi2qgmFAbHkkk
XuXCepmeTHZa3sGM/UtcFKSbPyuTQKWYXzLdlvaBuiMRDYTTSsJvTyKYWuKe2ADi
dKdhkqmLdbYlq2moF2z+dEuKq5isXe4z4AkCrXlDBS2uq/5zYCq1zeM6KpjP/hUs
2rFFmKvVMCFTPJO2GRHw48U4k9ojXknmbkLBtJ//nBoA4esEminLLFSWDgHUj5Dt
DKC23a1NkDWI+svBytBKIyKuoi7Nbx/dmznvrg6mpAhvUtyvgVnfWONFr6yDWqtF
k5YxBdVb51HNQhcbmOZ0frA5qnvtyjz+yQYFyB67rSw6ir7VBEgd98U1unKj7XY9
11bhaeUPIRHyVZiNrDKrQ05+LR8tQKVMGgNMQW4GJ4ML4ZzIYY1BpgBjFjRC+Jwv
zGZyaTA6t6nZZhfYlUYJIt8VATHdyDwunZkfOH5cA+gbr+98my2actTWu94i39IU
BhIUPnknP+5w0SBPkw1PIyWCIfRhCfTwRcEvOS+2+HJqqk9wtBpZYRxLzUmtHhG3
pv6B3/7EMQWi38JDVpTq
=3bhK
-----END PGP SIGNATURE-----

--=-S+FPkA8fXB/YKcNRkYMJ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
