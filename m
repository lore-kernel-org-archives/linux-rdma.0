From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH][V2] RDMA/nes: do not leak uninitialized resp.reserved to
 userspace Content-Type: text/plain; charset="utf-8"
 Content-Transfer-Encoding: 8bit
Date: Mon, 4 Sep 2017 16:56:22 +0300
Message-ID: <20170904135622.GA1070@mtr-leonro.local>
References: <20170904133705.3980-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170904133705.3980-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 04, 2017 at 02:37:05PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> resp.reserved has not been initialized and so the copy_to_user (via
> ib_copy_to_udata) is copying uninitialized data from the stack back
> to user space which is a potential information leak. Fix this by
> initializing all of resp to zero.
>
> V2: Initialize all of the struct rather than just resp.reserved as
> suggested by Leon Romanovsky.

Small nitpick, it is better to put changelog under "---" marker, so
it won't be visible in the git log.

Thanks
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmtW38ACgkQ5GN7iDZy
WKcjOg/9HdmZbgwhP9baosAay6UEERTHzf6rq2k53xUMth22H/cz5m5Z62cYy4td
HXBMP/pwgjoiYSO/MwjjRGk++6skLjCCc88h0x18dW6EbVOFPdH867hKjgSGHujj
/x/tKxdeFQuGb+GklUm+auSZyLFWDlrlkq4Y9Z38dC654YiJ5A7zDHkBKNs6WpY+
r7S70rldvv32xzA++Ql/kRWdui/ovbtIhO42DfxqmP3O4eswp/eq8PlvljmY+J7C
NmFIHX71SLGslYhyQ9Cq366zwZl1DuPodUAVHXbM0JJjyeC5oBNiRPbXfzK+kiqD
xTDDjIh5T5JKn5THJkAJUtiK2AfmI2YTBLy48YABGX2PRr5x2VjeihNnmisrYRcP
SPSv7fs349kuQMAoRVM8jQSILOeTOP1wujFzkcmMSFAJ6W2j1y7jQAJyLV2o09ki
GPwBOJl533mJxEjhqNUY5XU6rPscb/oixF4xLwl4XobBWT8Dc+kvwEe5yeap2nZN
J6QhQRlTol5Wbuy29Tl8cIIHnjdnGLTVyNBCKEJkJS5fjvU1BddYuuSuZYp9z7yl
Z8LRTtVB8jE2i00p9h8skByYaoI1uIiX7+T+GVTNvHtPZbr8xXymHZ5VxWzlou6G
Wmv28z+5A+qPFdhKxTzfrzuMLgz1hwkT9pCMqPoZKteb0NkhxhQ=
=uBFC
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
