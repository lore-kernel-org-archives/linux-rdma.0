From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDS: Fix rds-ping inducing kernel panic
Date: Mon, 22 Jan 2018 17:10:54 +0200
Message-ID: <20180122151054.GJ1393@mtr-leonro.local>
References: <20180122112415.GA41074@beast>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MzdA25v054BPvyZa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180122112415.GA41074@beast>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sowmini Varadhan <sowmini.varadhan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Steve Beattie <sbeattie-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jay Fenlason <fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--MzdA25v054BPvyZa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 22, 2018 at 03:24:15AM -0800, Kees Cook wrote:
> As described in: https://bugzilla.redhat.com/show_bug.cgi?id=822754
>
> Attempting an RDS connection from the IP address of an IPoIB interface
> to itself causes a kernel panic due to a BUG_ON() being triggered.
> Making the test less strict allows rds-ping to work without crashing
> the machine.
>
> A local unprivileged user could use this flaw to crash the sytem.

s/sytem/system

>
> I think this fix was written by Jay Fenlason <fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
> and extracted from the RedHat kernel patches here:
>
> https://oss.oracle.com/git/gitweb.cgi?p=redpatch.git;a=commitdiff;h=c7b6a0a1d8d636852be130fa15fa8be10d4704e8
>
> This fix appears to have been carried by at least RedHat, Oracle, and
> Ubuntu for several years.
>
> CVE-2012-2372
>
> Reported-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> ---
> This is what I get for researching CVE lifetimes...
> ---
>  net/rds/ib_send.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
> index 8557a1cae041..5fbf635d17cb 100644
> --- a/net/rds/ib_send.c
> +++ b/net/rds/ib_send.c
> @@ -506,7 +506,7 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
>  	int flow_controlled = 0;
>  	int nr_sig = 0;
>
> -	BUG_ON(off % RDS_FRAG_SIZE);
> +	BUG_ON(!conn->c_loopback && off % RDS_FRAG_SIZE);
>  	BUG_ON(hdr_off != 0 && hdr_off != sizeof(struct rds_header));

To be honest this function full of BUG_ONs and it looks fishy to have them there.
Why don't we return EINVAL instead of crashing system?

Thanks

>
>  	/* Do not send cong updates to IB loopback */
> --
> 2.7.4
>
>
> --
> Kees Cook
> Pixel Security

--MzdA25v054BPvyZa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpl/v4ACgkQ5GN7iDZy
WKei0BAAv7eOefHnDLnlhHDFzjFllW5dnTCzGdwH5t9iGAue57dDbLUBu79Yg+Fp
TfAGE/sDfFDM7zliHHASUGqZFfL90sy1oqANkSSoksv119ECiqMGhzv2Bo3VcsvK
cWt2qOEGb8ScZW2VXKhUpPklWmY4qWVtjQi09IbqLIdhYYPviQVnMtqiccogpcO/
GXNuXExvy7CWyFsJDTLctEKsKJiv7VWF+WmCmSNVet8jimFtQNDgnHhRlHGOuum3
512r4bV37rAfCyuBtXSCHqgq/TSRXBGaJRY7NWVT+WxAmrlrcogMGSpcS4hVnpgp
wZDzq8MQJep9RyDQYwPONIzi0qPTubMai9Jjn1YaTkdYtYFN/vj29eysu4UkjlDx
2CoMfrUDAQEaqdl7TQ8nTQyt6Q/tEpYuO/Xxzsj81gBx6a65Atk63+iVfMjuVKk7
Tu2IgWBwiNnnvIuQT9BlHmHM+7srdWQp9g68f+6m0SrkRgpzs8iCPSelZ5DqKkxL
fsuJl6Dumk/om4Aj03iWWV1dLj0PrTwlAItc9+MkJudoBq01a3vqCEtmtdJwcmyw
2bT+mSIrnYFJHdk2124lS6tu00UNvjPhYmDLxAS8ZA8I7z5PY24Nbw78cxRak0qx
4eTfZsPbxxsp5/QuVIMdGBJpBQsp0FSkijShNenaT782PF4dA/A=
=0iAX
-----END PGP SIGNATURE-----

--MzdA25v054BPvyZa--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
