From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next v1 2/2] RDMA/vmw_pvrdma: Update device query
 parameters and port caps
Date: Thu, 24 Aug 2017 07:32:23 +0300
Message-ID: <20170824043223.GB1724@mtr-leonro.local>
References: <cover.1503468979.git.aditr@vmware.com>
 <a31ee424df9ad51371ff38e4f8239a390df13947.1503468979.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sMP3l7aO1Ldl3x+Z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a31ee424df9ad51371ff38e4f8239a390df13947.1503468979.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--sMP3l7aO1Ldl3x+Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 22, 2017 at 11:19:01PM -0700, Adit Ranadive wrote:
> Added support for two device caps - max_sge_rd, max_fast_reg_page_list_len
> and the IP_BASED_GIDS port cap flag.
>
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h | 9 ++++++++-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c   | 9 +++++++++
>  2 files changed, 17 insertions(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--sMP3l7aO1Ldl3x+Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmeVtcACgkQ5GN7iDZy
WKcRYw//VL4Ik2WIJVKrYB+r1Mvo0HYV/V4k21SHukhUZwHy9Vnord/m8wM/wod7
AvuPVuKv4WYpus7QsC/UuQpJjoD94B7hDrDjFHToJjc+7QKWyun9xeYWA38SveJK
KCWoWMIVyayPg48c/H5FBc6XMfYVkTAR0kgaQePr+OSZppO+JEwifegkGaQNw07v
bdlfaSAINQWSWyb1hJetUgw+efYkNjNnS5af/AX/Ck+lgrdmI/nWnAOr0udHMbrc
0X5W5IrlQHG57G6xJvewmQYJfujeyn1anugekge5fib1wjqUCA6Mrg426mJ+CCoz
/mA98/uZy6J43hKc+rU8WiLaeejMDNBHkYNb+DXSIdf+v7HkgbK1TwqyCHkCfvvD
yV/MSzbgqZHXMySUPF182jWV9KpbcvqPJkS6z/o7kGJRal02ZV4YsG1EBScUpQhK
Qpld307PeZNJZ8aceLZD/shd/UzrIF7rJluQlD/x1xYAnWhN7lw03bg1hYtKx729
mTekD/aZ+U7NuoMPjzmd1bh9zbhADcBrQlfj/E/kMHT3uJ+SLOCtgIcJwMjoerM/
lGiiaPdr84H1zA2nNORK5BBzK/Sut9nTC5G9Z4gHtoVcmXHQ0WqWWr3zYkiDH924
fBvJ6c1wNQN1R580lGY/wBOCWJhxxM7C53vhCawWEQzTk7/t5Ow=
=qan+
-----END PGP SIGNATURE-----

--sMP3l7aO1Ldl3x+Z--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
