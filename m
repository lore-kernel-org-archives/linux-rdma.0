From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] rxe_cfg: Fix parsing of ethtool / ifconfig
Date: Wed, 18 Oct 2017 17:24:54 +0300
Message-ID: <20171018142454.GR2106@mtr-leonro.local>
References: <CALvXFTdij1WaFL2A05MJBcngn5eJ=ahxwRU64bS_VsCjvnE1XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DLrrb1ThO6aUXDeM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALvXFTdij1WaFL2A05MJBcngn5eJ=ahxwRU64bS_VsCjvnE1XQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Nathan Hartwell <nathan.hartwell-YP+SxaqqoVo2oU8LL9ROB9BPR1lH4CV8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--DLrrb1ThO6aUXDeM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Moni ?????

Thanks

On Wed, Oct 11, 2017 at 01:00:24PM -0600, Nathan Hartwell wrote:
> rxe_cfg does not always parse the output of ethtool and ifconfig correctly.
>
> Fix two items:
> 1)  Parsing of ethtool's link speed field to always output a link speed.
> 2)  Parsing of ifconfig's IP address / MTU fields with newer builds of
> ifconfig that have a slightly different output format than in the
> past.
>
> Signed-off-by: Nathan Hartwell <nathan.hartwell-YP+SxaqqoVo2oU8LL9ROB9BPR1lH4CV8@public.gmane.org>
>
> --------------------------------------------------------------------------------
>
> diff --git a/providers/rxe/rxe_cfg.in b/providers/rxe/rxe_cfg.in
> index 0a8583d..8429b28 100755
> --- a/providers/rxe/rxe_cfg.in
> +++ b/providers/rxe/rxe_cfg.in
> @@ -180,9 +180,9 @@ sub get_dev_info {
>                     if ($fields[0] =~ "Link detected") {
>                         $link_state{$eth} = $fields[1];
>                     }
> -           }
> -           elsif ($line =~ "10000baseT") {
> -               $link_speed{$eth} = "10GigE";
> +                   elsif ($fields[0] =~ "Speed") {
> +                       $link_speed{$eth} = $fields[1];
> +                   }
>             }
>         }
>
> @@ -197,6 +197,11 @@ sub get_dev_info {
>                 @fields = split(/\s+/, $line);
>                 $ipv4_addr{$eth} = $fields[0];
>             }
> +           elsif ($line =~ /inet /) {
> +           $line =~ s/^\s+inet //g;
> +               @fields = split(/\s+/, $line);
> +               $ipv4_addr{$eth} = $fields[0];
> +           }
>
>             # get ethernet mtu
>             if ($line =~ /MTU:/) {
> @@ -204,6 +209,11 @@ sub get_dev_info {
>                 @fields = split(/\s+/, $line);
>                 $eth_mtu{$eth} = $fields[0];
>             }
> +           elsif ($line =~ /mtu /) {
> +               $line =~ s/^.*mtu //g;
> +               @fields = split(/\s+/, $line);
> +               $eth_mtu{$eth} = $fields[0];
> +           }
>         }
>      }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--DLrrb1ThO6aUXDeM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnnZDYACgkQ5GN7iDZy
WKd+oQ/+MpF99tUn5N/uK9xWS4g54ccbZgfnFacPv8Cx5PcMbDkzwCEfDRAekHYI
OhqxNEkTUsdSckVr++t7XDamrSib7LBI3XebqOX2Wp/cf1YOq4zWXv+MdbU7Yc6G
W1pUsgD+lfSy41uYGVbSioJVGb3aKFP6gVXo3hvBwND6mej/tS09rWFjiGvht0AY
qIPkhvtYJOUrZUy1gVdH/OXmnV99DyDuZZslT7BLDnzy7r4YuKmfvdFdtVGrtNj7
QfXEecfNYIQ10lq58F6CcI5JucXeM/xd1Txzsm3Xug+lZjKXraz7szJvoCKUnOBT
PyMI4amF6r++IM83RGzY05ClHIjkSyw1RgOPZWVm1bgz1bjnbk1KmdBF2GKKKY6w
IlOpyeshqMg/IEBBKO1rfUfL3QAjVhK6pXwngg+P138F6KM8RBYn6di7bw6gKyXY
iTgZdWWRBoutg6EXZV7/shdAGGnp/t0G6xEM5X6JzMChRdUrEKlxgd9h8MvMLX8a
VQBspMfwYHyTk8jxbzfO+Fu6KMvsi82bOLvVdkj6kJdn01gcoRx6OKWt07e0jKlg
BQGBP9paRVS6ltgu3Tupe9WbAMEdqsvHMvwFrC734QnzC3LqTrQrtlcOGkV1abFx
4oEjhvdJLKlQXBtMOOQwRf9Vahc3WGEN1RS0vpNfr9C0eHNZj5o=
=42U8
-----END PGP SIGNATURE-----

--DLrrb1ThO6aUXDeM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
