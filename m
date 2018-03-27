From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v3 iproute2-next 1/8] rdma: include rdma-core
 <rdma/rdma_cma.h>
Date: Tue, 27 Mar 2018 08:46:22 +0300
Message-ID: <20180327054622.GU1877@mtr-leonro.local>
References: <cover.1522097991.git.swise@opengridcomputing.com>
 <326e72eaa0a6ed3d42aa857f13c80232a2550c77.1522097991.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/NwG7NuG0/W8LcLh"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <326e72eaa0a6ed3d42aa857f13c80232a2550c77.1522097991.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--/NwG7NuG0/W8LcLh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 26, 2018 at 01:57:32PM -0700, Steve Wise wrote:
> This avoids requiring rdma-core be installed on systems.
>
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> ---
>  rdma/include/rdma/rdma_cma.h | 728 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 728 insertions(+)
>  create mode 100644 rdma/include/rdma/rdma_cma.h
>

Steve,

Sorry for not spotting it before, you actually need only 3 enums for the
cm_id_ps_to_str() from rdma_cma.h.

Simply copy/paste that enum into cm_id_ps_to_str().

Thanks

--/NwG7NuG0/W8LcLh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlq52q4ACgkQ5GN7iDZy
WKfFrQ/+L6yFiIZI+ihNEKwYBcYJi1BVasex5rJR6LdK3FV9XlLDGrD+10iuxrPo
uToo5INjau2D1xZP1plUn+eaGXQZeL26rRLqdiAa2teimKMyUB8WHrfFLCuT7cGY
lilUyAne8Ch9Mkb5rkmky0xQ4P3yJIc+I8WQPiosu4x9jlrECThbwyYUx3RUt5dy
hJfA8hNhLC/yu550rvMs6JIoaFI+hhcyMP1NcS9+LaahmMIqYhwNlQPFPCtWMdXv
ZQkiMz38CYvxSZVTUljstwvbXQP7/M4s42nhe6DSZcqjMZU56FpPMjTbhewGk3JW
pBNJ2sjP7yfjbWfAu76ldFBkezuTkDlm6vEOSmg4ZQjdPZpl2ZQSOw1oF/yCBg8/
Wb17LVSOkN8AB5GttYgXCqHUWYUYtWNwWpGweKt2pSfBYjbONCfu/8UgMjTUtJL4
OwSPzMwBxKKpCvIrJJGxAuvkvpNfznkZPUbKkHEVqy0ANvSUWZLNFROw2tPJd5sA
0NzRY42JmGbsG01FoOQmsKczZd325F5buYFH32ZNE2TTXK6hFasxCDkFH/jQsTWe
I1ewnLsuSdljbmeRHq86Rur/prX8B95NV26kF72L+9OHSTH1Mmo1Njlrw22CROLL
c9GEyR8NgGyxwaZdy/BEqfW3CFOoHcgu+AwhRcUOo8JJnkXZqm0=
=PmN4
-----END PGP SIGNATURE-----

--/NwG7NuG0/W8LcLh--
