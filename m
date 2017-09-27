From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Enable pkey and device name decoupling
Date: Wed, 27 Sep 2017 18:01:40 +0300
Message-ID: <20170927150140.GF2297@mtr-leonro.local>
References: <20170927093248.3819-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oPmsXEqKQNHCSXW7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170927093248.3819-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kernel-6AxghH7DbtA@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--oPmsXEqKQNHCSXW7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 27, 2017 at 12:32:48PM +0300, Yuval Shaia wrote:
> The sysfs "create_child" interface creates pkey based child interface but
> derives the name from parent device name and pkey value.
> This makes administration difficult where pkey values can change but
> policies encoded with device names do not.
>
> We add ability to create a child interface with a user specified name and a
> specified pkey with a new sysfs "create_named_child" interface (and also
> add a corresponding "delete_named_child" interface).
>
> We also add a new module api interface to query pkey from a netdevice so
> any kernel users of pkey based child interfaces can query it - since with
> device name decoupled from pkey, it can no longer be deduced from parsing
> the device name by other kernel users.
>
> Signed-off-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Chien-Hua Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/infiniband/ipoib.txt        |  12 ++
>  drivers/infiniband/ulp/ipoib/ipoib.h      |   3 +
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 187 ++++++++++++++++++++++++++++++
>  drivers/infiniband/ulp/ipoib/ipoib_vlan.c |  76 +++++++++++-
>  4 files changed, 272 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/infiniband/ipoib.txt b/Documentation/infiniband/ipoib.txt
> index 47c1dd9818f2..1db53c9b2906 100644
> --- a/Documentation/infiniband/ipoib.txt
> +++ b/Documentation/infiniband/ipoib.txt
> @@ -21,6 +21,18 @@ Partitions and P_Keys
>
>      echo 0x8001 > /sys/class/net/ib0/delete_child
>
> +  Interfaces with a user chosen name can be created in a similar
> +  manner with a different name and P_Key, by writing them into the
> +  main interface's /sys/class/net/<intf name>/create_named_child
> +  For example:
> +     echo "epart2 0x8002" > /sys/class/net/ib1/create_named_child
> +
> +   This will create an interfaces named epart2 with P_Key 0x8002 and
> +   parent ib1. To remove a named subinterface, use the
> +   "delete_named_child" file:
> +
> +     echo epart2 > /sys/class/net/ib1/delete_named_child

I doubt that delete_named_child is actually needed. You can use delete_child
on the pkey, which you used to create named child.

Maybe better to add support to rename child instead of introducing named
child concept?

Thanks

--oPmsXEqKQNHCSXW7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnLvVQACgkQ5GN7iDZy
WKfvFQ/+Kdm3X5nY2PjZyhDu7HOLq9YrXMqxI0UUVlMBNZSwV8Tw2G1sQu+O8ByX
mn2REypsBS4GOR+BW7xFPsb2LNd5sImd5Az83fxpTxfxAlH0N1ygvUWQwb88R4zU
JYCq2rzlYD50cAYWkbKepjV7lEA35orR1N1JoRaTMVJs9R8G7NU3p3u0sEMWcAcK
UPj6mqDHTVoSIuv81RRsasJvIJShKHmzju1r/u9L/CKeIGGGrpTQJwXY9nfuRwff
o4LQIP7xyx79PzwfomztiP76Ld0UzEAWb7trNdV4HV8Fo0QOg4j/ZkoYas50kjtb
EdP5yaZBFHat1nCFoEWAHwQsR5hG2beAh2Wp588CGiAR0RgHA91AXZ0s9h4pgT10
MPNyDbyE+gjysd/AE2TALr1ogkaiJbNg46H7U+JYI1s3lciqsFbOChDRM//+2kwq
hdCjh57oIn4jLkDK/d/z0Vse+driR4jk05VnDIZPmDfNHekw14Zb+UoM2ulnTE2G
H/dy4H+IP+lROQdh3cVcf9vd2YkocHCTs4jn+bpTQY2JHQAszXoGrREsIMgAbLYa
UA6EiVWpRbq8lgxQTo38mLtOtEb/YF80P+UoDYg0gbUaPhAFKWdyyImwKYi40PUQ
Vzt2edZzDq6t4cxC4Qk96/RLvXzlhpr3HSAUX3Opxg9Em5/zb5U=
=1AKO
-----END PGP SIGNATURE-----

--oPmsXEqKQNHCSXW7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
