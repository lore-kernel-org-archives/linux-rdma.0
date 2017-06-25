From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 11/13] RDMA/bnxt_re: Fix return value of poll
 routine
Date: Sun, 25 Jun 2017 08:48:15 +0300
Message-ID: <20170625054815.GN1248@mtr-leonro.local>
References: <1498065504-27902-1-git-send-email-selvin.xavier@broadcom.com>
 <1498065504-27902-12-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bAr+fMtvBxbbbkvl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1498065504-27902-12-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--bAr+fMtvBxbbbkvl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 21, 2017 at 10:18:22AM -0700, Selvin Xavier wrote:
> From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>
> Fix the incorrect reporting of number of polled
> entries by taking into account the max CQ depth
> in the driver.
>
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 1 +
>  1 file changed, 1 insertion(+)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--bAr+fMtvBxbbbkvl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllPTp8ACgkQ5GN7iDZy
WKeNzxAAgDzZvPfXWDZaI8NLrvBizJzZIL8BqjmtHx7zmd5702y+0DaYTARZ5hFV
bz0HIxWZWGKCdaMWZfzLkETaB/JcR8ME+eHY1i6B9HJ8RPnJVSv4sNjaTLtVR4tz
k9zI7mwtomGqqkveQZIIf9gf16GknmzvOxgXs2OuY1ppiGheLrEa71C6cEPfI/Nf
w2p6apQeJkI3TQW7FVLuGJ6QHVtGwidPYBPlQ6WXvch34mUyJsV/XlDrFgCcKjjb
5cMP30J4Jtu+OhynxkIMH1PoGAXBTchGZmLzN9i+QcV7hd6cqbH9wnMX3W8IvYu1
ePZGB82iOkaTx/v+N8ul7OMPumBWrYFtoZgG+XBCrllIBU5yHJbOoL57BATbLR0A
W01+XPhO384UsJJPUwQcWlVNzES4rJQ2CTVj9EBceWh8spcWO7bBvltyxjxpWcqV
WDAT3u5m8mwptjEBL2A08f8iC55OWfcXKqCT62X5ZMipIz2B/jzBYblt/JiaXbFv
SYobSyxRPuoIxUeO1MfKEAsi3iwDBKRXqXbemYqL1QIW7mGFBtRPPqjwG9ofFu9c
M/pmsXshRAXxlXoUxp6m80dFkyuphnjQN5JpwoSzM6jv/neDNbMiHGoAxHQkb24G
R4H3NN1TUkZRuPS1N29ox2ldkHJPCFQJGcdihtUu6ttUD/XauOM=
=nWJl
-----END PGP SIGNATURE-----

--bAr+fMtvBxbbbkvl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
