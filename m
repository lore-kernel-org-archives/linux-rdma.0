From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] libqedr: Sort out dpm/edpm naming
Date: Sun, 2 Jul 2017 15:50:07 +0300
Message-ID: <20170702125007.GB8041@mtr-leonro.local>
References: <1498986565-2756-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1498986565-2756-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 02, 2017 at 12:09:25PM +0300, Ram Amrani wrote:
> DPM stands for Direct Packet Mode while EDPM stands for Enhanced DPM.
> Give more meaningful naming to the structures and functions to reduce
> possible confusion.
> Also avoid entering E/DPM functions if not in E/DPM to begin with.
>
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  providers/qedr/qelr.h       |  11 +--

Thanks, applied.

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllY6/8ACgkQ5GN7iDZy
WKfGpRAAvEok79M8J0h2vID46iowiXBX9+VSKoPDwFQizcr9wI/XxQuoWR7+dOtr
unWnrTmG6typ9Gm3zz5VFhMjvUih9hylvsG91R2KU8KLud4HPS4jIUYuzhRo+bRn
Oq7uflhENm1QU/zDevbsuY5FN2YOU2DHpGw+tCE27JJfSYSXn8njTztXb0Qtq/ag
A0+CrxHjNswOMQ29hfeTa2ajuQYHyudVjUHeqbMo5vSxCgcJSuSHV4mQ2lC5OblM
qHEZUO9I/zpxIneBfi6ce9uqWuH7mbcyZzXd0LBdhrJRlgXLLWQFwQNl7D+DObeK
BQGFOMFwdOihWs0myROsCPlTNskwVE7HX8lZrUUnd3pbfMos6/scnS8PHx2n47L1
/idVVy+Qn77ZmKjxNFEAnZXvyVED0TMBlr4f/ddEBBC0xcCD7HpbcoQf2jWu1H0q
CbildfHrIaPgxRvpSVsSqRR5Q76My7Ox+j7cDwXbLO1JOZSdzhl9N2XWS6nej5Pn
I4T35Pk6nbKpiGnuquXhJtTKY0R6s2xlrpilXGoNeKm/dLe7SCC12lsTB9rfGGcC
O/oLSs3CqmvbHnBusdhiPd9Zkqo40HuHrkqBzUpDrU342siILU0jv6dTTIiKd67C
9Vg3eBRUFDT1dOCEqtYbe/wGGcoUz/bTM68zKpizYY8BIDnzajM=
=IKmG
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
