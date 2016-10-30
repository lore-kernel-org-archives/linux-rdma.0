From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] qedr: Use list_move_tail instead of
 list_del/list_add_tail
Date: Sun, 30 Oct 2016 22:56:26 +0200
Message-ID: <20161030205626.GS3617@leon.nu>
References: <1477757993-32186-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ShzQXCswyqjgWi6k"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477757993-32186-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ShzQXCswyqjgWi6k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 29, 2016 at 04:19:53PM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> Using list_move_tail() instead of list_del() + list_add_tail().
>
> Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> ---
>  drivers/infiniband/hw/qedr/verbs.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
> index a615142..cdaddf9 100644
> --- a/drivers/infiniband/hw/qedr/verbs.c
> +++ b/drivers/infiniband/hw/qedr/verbs.c
> @@ -2413,8 +2413,7 @@ static void handle_completed_mrs(struct qedr_dev *dev, struct mr_info *info)
>  		 */
>  		pbl = list_first_entry(&info->inuse_pbl_list,
>  				       struct qedr_pbl, list_entry);
> -		list_del(&pbl->list_entry);
> -		list_add_tail(&pbl->list_entry, &info->free_pbl_list);
> +		list_move_tail(&pbl->list_entry, &info->free_pbl_list);
>  		info->completed_handled++;
>  	}
>  }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ShzQXCswyqjgWi6k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYFl56AAoJEORje4g2clinMh4P/3K7QrjRkqJYfmZEXqGRz8lu
kWHYrKO+bvQzmpavWXCrdncTzA+UfxB1YSfviprIJTlkkWDBsbvth1VlzplC1SCq
vLEce5bryp7XoohlmrPPtjNJX6Vucu+bBj5ZyedIDXEKn3vFtRC3dTeEnRLGBPfU
E9a7UOsBrJmE2fmg6BPTviSulyyrjk/gjeG61DASgg7hgYOPC+EDhoLD8xn+cNf9
yziAc5B2Uc245ZOtEkgDFLvrJlZigc2vRzrwfutml6Wf7WBxmuWLL+iWCea1jKxO
NTrRbY29ZriBpodW8gn0MKY9i0GoK9z55ugx9w9v3sL7alDvOuyLeHz0J5axjZrm
wFwjwv5V98YV9v2BlGoyXopTT/QewzL7T6ohFRUn8pt0/zOORBxQ5hd5y9+Ua/aY
XPSTSk6qdNq5ogGyzUlWDRqa+abs4V8z9dZ8cCVDeQ6D7UOfaFytMTPO42UTFA3/
uNQwdDRVERAbEvcw1LFA5CrHLIc3A3hNGDtCjtS9bteRI/OietPPJ2dGfHJQ+8QE
Xccxcm8M2TckEOfY+aY9s+s8AS06FW8IipwGfxMwqAZOWmkuM/8+82H1uYkjUy62
Sa2LGDxKOAuVDwaO4A229u5txN6WSLhamn2HxGOvrc0pyIlnRt1VOnRLLJmIOqAO
h6QFcjle7t67wF0NK3Jb
=S1u1
-----END PGP SIGNATURE-----

--ShzQXCswyqjgWi6k--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
