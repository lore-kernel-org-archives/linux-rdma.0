From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH V2 mlx5-next 0/2] Mellanox, mlx5 new device events
Date: Fri, 1 Jun 2018 19:21:26 +0300
Message-ID: <20180601162126.GB2843@mtr-leonro.mtl.com>
References: <20180530175950.9488-1-saeedm@mellanox.com>
 <20180531.153603.45475041396194381.davem@davemloft.net>
 <82ddad11b6a77aa07238ff50ae8769360bfb583b.camel@redhat.com>
 <20180601.114558.569563972122502762.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rJwd6BRFiFCcLxzm"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180601.114558.569563972122502762.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: dledford@redhat.com, saeedm@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, jgg@mellanox.com
List-Id: linux-rdma@vger.kernel.org


--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 01, 2018 at 11:45:58AM -0400, David Miller wrote:
> From: Doug Ledford <dledford@redhat.com>
> Date: Fri, 01 Jun 2018 11:08:24 -0400
>
> > On Thu, 2018-05-31 at 15:36 -0400, David Miller wrote:
> >> From: Saeed Mahameed <saeedm@mellanox.com>
> >> Date: Wed, 30 May 2018 10:59:48 -0700
> >>
> >> > The following series is for mlx5-next tree [1], it adds the support of two
> >> > new device events, from Ilan Tayari:
> >> >
> >> > 1. High temperature warnings.
> >> > 2. FPGA QP error event.
> >> >
> >> > In case of no objection this series will be applied to mlx5-next tree
> >> > and will be sent later as a pull request to both rdma and net trees.
> >> >
> >> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-next
> >> >
> >> > v1->v2:
> >> >   - improve commit message of the FPGA QP error event patch.
> >>
> >> Series applied, thanks.
> >
> > Hi Dave,
> >
> > Although in this case it doesn't really matter and we can work around
> > it, this was supposed to be a case of the new methodology that Saeed and
> > Jason had worked out with you.  Specifically, when Saeed says in the
> > cover letter:
> >
> >> In case of no objection this series will be applied to mlx5-next tree>
> >> and will be sent later as a pull request to both rdma and net trees.
> >
> > then it is intended for you to ack the original patch series, not apply
> > it, and when acks from both the net and rdma side have been received,
> > then we will get a pull request of just that series.
>
> Sorry, I saw your ACK and misinterpreted the situation.
>
> I'll be more careful next time.

Doug, Dave

I would like to clarify this point, we intend to send pull request to only
one maintainer, who actually needs the accepted patches.

Let's take the RDMA flow counters series as an example:
https://www.spinics.net/lists/linux-rdma/msg65620.html

This series includes 12 patches for RDMA and 2 shared code
(mlx5-next). Those two patches, the RDMA side will receive as part
of specific pull request and netdev will get them if some netdev
feature down the road will need mlx5-next branch.

Of course, it is harmless for both of you to pull, but it looks like
extra work which is not needed for you.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--rJwd6BRFiFCcLxzm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbEXKGAAoJEORje4g2clins6gP/0ovsHbRF8JfzA6Bnpo+EeVN
v0+z7zM7f/vtF7cq7IQxTSyy+XcW+jxZFLFWCl6yPiSwUtt7KEbxvDaAoeA9wvU5
7lsXw3W4h8k2mBtBWOc96XMsEM5PFTKbSJ1Ojdv4jH1jiKJdVUuCZsOprO7yA/+k
eDc0e2pjvA493QFQCoJL1Q6NFdQKKeptQfl4O1YL9tiuVY3vlpfsHSQCcrV0QRFs
Rnz5txgL/6g+6UAgycLFKk4lRS2bPQCvGoH7pycvsNxMMz515mgGNDArc/sSRiAl
zK+SGxu2q12KIIWLXBGX4RvFpIjzlP0bm3D5b+gIzilldy9L4IFezrYb9LSOpGSN
WeOej6NBZyYY9hB4PmBkDbaGzBg3JF8avISk4SWrA1gzs/OzClpYQTLjg+FA2+yR
n5m2vC9vwbNt4OlvDAmru2aWW0pNyCGC6xJMuUAZVQr++iSo9RIuuczhjxLm8XfL
/e+b9TtMkRdlBfHrxN+M4jWImXaD352B9Fut8IPb0M+kK/qrh3KWba7IAS/u10zB
47Re5wZS66ZmnyU6sHY/Tkm7E9gplUihbezkPnzB7eIxqlBotZMaTjL3g+hTG3Qu
f5xy1UO2H5rkFRpZy8fNMR2UuFH1K7WXPq5yRCXreHZ2TkFmDris9T4iceALt+MT
hURH+1nJTW0RiznIS6Oh
=jhVQ
-----END PGP SIGNATURE-----

--rJwd6BRFiFCcLxzm--
