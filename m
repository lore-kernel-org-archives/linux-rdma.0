From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 2/6] mlx5: move affinity hints assignments to generic
 code
Date: Thu, 6 Apr 2017 17:27:01 +0300
Message-ID: <20170406142701.GL2269@mtr-leonro.local>
References: <1491474998-16423-1-git-send-email-sagi@grimberg.me>
 <1491474998-16423-3-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XjbSsFHOHxvQpKib"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1491474998-16423-3-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--XjbSsFHOHxvQpKib
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 06, 2017 at 01:36:34PM +0300, Sagi Grimberg wrote:
> generic api takes care of spreading affinity similar to
> what mlx5 open coded (and even handles better asymmetric
> configurations). Ask the generic API to spread affinity
> for us, and feed him pre_vectors that do not participate
> in affinity settings (which is an improvement to what we
> had before).
>
> The affinity assignments should match what mlx5 tried to
> do earlier but now we do not set affinity to async, cmd
> and pages dedicated vectors.
>
> Also, remove mlx5e_get_cpu routine as we have generic helpers
> to get cpumask and node given a irq vector, so use them
> directly.
>
> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---

Thanks,
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--XjbSsFHOHxvQpKib
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljmUDQACgkQ5GN7iDZy
WKdDMxAAljeXK4d5Mgw37HndwWrXVYNYFqNbp/tyGfOU4uKrUB0a0Nozl8HTmxRK
9WzsnXG2Txd9rKW9Nq9OMTP5DSmfYeCm4QpK5H9uM4WCLQ1/QZ/wsNMGDw6YEOZ5
vNuT9uGg+NrqU2zeSTkvweaPRobYT3Pb6nfRFTMcp+Z64+Q2WaHURNAfPlyWv5Eg
yRRsqKYookbVKuMC71zoRF1i/6Kefi9Pz6jyK8zKUA63YOkeiN7kukteqDo8BwzC
6/X8ur3Qmtmv0G7tyy/HAm5AYDRp7V3RgRlkCW/svhPL/cn93NjURLWUnAWinGom
5ppkqHX0eaJKMUexUEh10+7wq1jKfDwlrVkdpVk5wng6oOcwlAvR5TqRV8ZZdYID
YJlRruuv88lO1RE6BZYTuzI6pQr7lwPwHU2AihLRxpHIbdprcIf7DDWIy3rFKWGi
j0TtBjiAjMak4E6K0KXusGZj3+9+3JqClcV1+fCyLqTqxfQht4zirafRLud2dQLU
LPy5TsAzBJaMQX/ve+pzwqP7pMR2Tmr0vvUQMQY9OAn/mfbfHs4MoewUjKHcsLr+
+jy1FfTBNFzTmY8df+wPXUOY6DQ/m477xChC8AqgStRb9RGTU/iFtq+Rt1TleTgy
VdHKu2YddT00O0Zz/RZm9pHFE9JZa2xtmSSJPszPjOI4W9GSNMo=
=fhTn
-----END PGP SIGNATURE-----

--XjbSsFHOHxvQpKib--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
