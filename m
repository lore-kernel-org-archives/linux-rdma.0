From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 7/8] IB/core: Add support for draining IB_POLL_DIRECT
 completion queues
Date: Wed, 15 Feb 2017 09:21:16 +0200
Message-ID: <20170215072116.GN6989@mtr-leonro.local>
References: <20170214185636.29250-1-bart.vanassche@sandisk.com>
 <20170214185636.29250-8-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Y+Z5jE7Arku/2GrR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170214185636.29250-8-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Y+Z5jE7Arku/2GrR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 14, 2017 at 10:56:35AM -0800, Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/cq.c    |  4 ++--
>  drivers/infiniband/core/verbs.c | 35 +++++++++++++++--------------------
>  2 files changed, 17 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
> index a754fc727de5..48242785b323 100644
> --- a/drivers/infiniband/core/cq.c
> +++ b/drivers/infiniband/core/cq.c
> @@ -58,8 +58,8 @@ static int __ib_process_cq(struct ib_cq *cq, int budget)
>   * %IB_POLL_DIRECT CQ.  It does not offload CQ processing to a different
>   * context and does not ask for completion interrupts from the HCA.
>   *
> - * Note: for compatibility reasons -1 can be passed in %budget for unlimited
> - * polling.  Do not use this feature in new code, it will be removed soon.
> + * Note: do not pass -1 as %budget unless it is guaranteed that the number
> + * of completions that will be processed is small.
>   */

Interesting solution.

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--Y+Z5jE7Arku/2GrR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlikAWwACgkQ5GN7iDZy
WKfl6A//bn5wypuH7n1RZ4+1MtVTTBFT5T+l7smodPLXKA7dmJltIFcNNEpF+Adl
EvrD524yp2x6vBFEpcpKzhEu/3fAPXD2asLOAJnKgu1wtLY+EI2kAb9ee0zakgXd
jFNOXhZZWj8X/T+3dnhSlakNPyVfWGsxRHrZknVhVpp7zwekhqTxPD8jXwH9EqLw
y5pMYmITniQN4Q5xvAxdMzDRsqnX796l9XIqzsYqkp3uHTXOi2AJsyLs/Z2j/pm5
xltxSKwBNmg/DQ6doAngDWB4kGi3q9j5apc955sDFh3bVVPxE1Hs1ryC0zkNlwaQ
5b49P444hMQylN5kjangNhBUeVG8NjkAXPfs+EY0qy7aHBkR6R0mcybRhnRQNhtG
TOAvtT3BMfjgrhnejYHjl5ujfBUMPqiVD8M2292Z4YW1wxDqkPJ6F0HePMgXwXvW
40PjZVZ6ynDPxUvu5Ke/fh1+ZkRT0UHtfah5N3LpU8Cx03iqvX8MUNdZSMN4ovHS
0i5S0/Z8isikFXO9/8ZegmxoRuzQY3Sz1TDOwgH2DBXu7gH5jFD+mKYYvlk+Qlvs
z1nw7A5XZVVRpRQR+QXXvthWc7HaPkPpw+BJCmNb//zyy3xffu82KzjgAtkrbaKG
eljcI2Drs+ZVFH0HZbguAaesdYqSBat7fumVpFSjQSSSK4W94Rc=
=7no8
-----END PGP SIGNATURE-----

--Y+Z5jE7Arku/2GrR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
