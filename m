From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next V3 6/6] RDMA/core: Unify style of IOCTL commands
Date: Mon, 5 Sep 2016 08:33:42 +0300
Message-ID: <20160905053342.GW21847@leon.nu>
References: <1472988635-31463-1-git-send-email-leon@kernel.org>
 <1472988635-31463-7-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="USQ0BwiCE5W4XvtQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472988635-31463-7-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--USQ0BwiCE5W4XvtQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 04, 2016 at 02:30:35PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> MAD and HFI1 have different naming convention, this patch
> simplifies and unifies their defines and names.
>
> As part of cleanup, the HFI1 _NUM() macro and command indexes
> were removed. It has a potential to break applications which use
> these defines directly, while shouldn't.
>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  include/uapi/rdma/rdma_user_ioctl.h | 98 ++++++++++++++-----------------------
>  1 file changed, 38 insertions(+), 60 deletions(-)
>

<....>

>  /*
> - * User IOCTLs can not go above 128 if they do then see common.h and change the
> - * base for the snoop ioctl
> + * General blocks assignments
> + * It is closed on purpose do not expose it it user space

Doug,
Do you mind to change "it it" to be "it to" and save to everyone
respin?

Thanks

--USQ0BwiCE5W4XvtQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXzQO2AAoJEORje4g2clinGiYQAIhWvPOnOL3c56Shr2iAMvfU
hJqGBsBiNwcGvAG3t/wDWMlVcFM1fcVbuSbTx2/XKqyLYfwMwoAkvhW4xLrWk5GL
JRlr7BFOLsjSpHJoG4hHEqbSgrgTDru6T83xvyRkpstd1LkwiORs7NxoQMq2tyj+
JDuFR+6Ju5adhUt0rOGDDb1Xo5sZSG3aZo489d0TSChH6zpp8Jp1fa/KVUJJuznU
0lqCUCcRXFGKSIyHU3QIG6teTma+nBu91uRymUt0UamEY20uzFNK51uYOBGliImD
EGlkLzDP6UzEgu5eE4zR0+r1CJfLaJw0ZRK237xkwPB6sXmTUphfMZdUx1lp4Eun
88rfxHyPV0UZHo28B4XYZ4DqsmjgIps9H8VUXLj2cVUdjXZyrJZV5/ZMDjEgTbCY
qaB5M0jxpAwUXv+m0FTnS14WQNgn1tk0Ft/oOaK1XGh9vn8eExKC0Za8n6f8P4n8
9cEFtAU4E8JDA3HpkZHHfZVt7L4mPhN9KicERygwE7wfXvbNfNpYQB8OLolfF4G/
7wkjCZtp3JEL/uKGP9JhOYjkJSLYjCyAWwKpRNNBUnz1ytH3ZbOALZ0ILFS8KOiB
qI0Fb9mRDK4APlOq0FluuK1ikqpcXgQqXgJjYSBwNsLF45xqsg6YUyaVV4woK8eB
PE6ub/8P2HOdBNbIy3NO
=9dTS
-----END PGP SIGNATURE-----

--USQ0BwiCE5W4XvtQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
