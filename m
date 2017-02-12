From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 22/27] IB/hfi1: Add receive fault injection feature
Date: Sun, 12 Feb 2017 19:42:05 +0200
Message-ID: <20170212174205.GI14015@mtr-leonro.local>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
 <20170208132800.16442.94549.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yzvKDKJiLNESc64M"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170208132800.16442.94549.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--yzvKDKJiLNESc64M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 08, 2017 at 05:28:01AM -0800, Dennis Dalessandro wrote:
> From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Add fault injection capability:
>   - Drop packets unconditionally (fault_by_packet)
>   - Drop packets based on opcode (fault_by_opcode)
>
> This feature is disabled by default and can be
> enabled using the HFI1_FAULT_INJECTION Kconfig.
>
> The faulting traces have been added:
>   - misc/fault_opcode
>   - misc/fault_packet
>
> See 'Documentation/fault-injection/fault-injection.txt'
> for details.
>
> Examples:
>   - Dropping packets by opcode:
>     /sys/kernel/debug/hfi1/hfi1_X/fault_opcode
> 	# Enable fault
> 	echo Y > fault_by_opcode
> 	# Setprobability of dropping (0-100%)
> 	# echo 25 > probability
> 	# Set opcode
> 	echo 0x64 > opcode
> 	# Number of times to fault
> 	echo 3 > times
> 	# An optional mask allows you to fault
> 	# a range of opcodes
> 	echo 0xf0 > mask
>     /sys/kernel/debug/hfi1/hfi1_X/fault_stats
>     contains a value in parentheses to indicate
>     number of each opcode dropped.
>
>   - Dropping packets unconditionally
>     /sys/kernel/debug/hfi1/hfi1_X/fault_packet
> 	# Enable fault
> 	echo Y > fault_by_packet
>     /sys/kernel/debug/hfi1/hfi1_X/fault_packet/fault_stats
>     contains the number of packets dropped.
>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/Kconfig      |    6 +
>  drivers/infiniband/hw/hfi1/debugfs.c    |  222 +++++++++++++++++++++++++++++++
>  drivers/infiniband/hw/hfi1/debugfs.h    |   35 +++++
>  drivers/infiniband/hw/hfi1/driver.c     |    8 +
>  drivers/infiniband/hw/hfi1/trace_misc.h |   48 +++++++
>  drivers/infiniband/hw/hfi1/verbs.c      |    6 +
>  drivers/infiniband/hw/hfi1/verbs.h      |    4 +
>  7 files changed, 329 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hfi1/Kconfig b/drivers/infiniband/hw/hfi1/Kconfig
> index f6ea088..7465595 100644
> --- a/drivers/infiniband/hw/hfi1/Kconfig
> +++ b/drivers/infiniband/hw/hfi1/Kconfig
> @@ -27,3 +27,9 @@ config SDMA_VERBOSITY
>  	---help---
>  	This is a configuration flag to enable verbose
>  	SDMA debug
> +config HFI1_FAULT_INJECTION
> +	bool "Fault-injection capability"
> +	depends on FAULT_INJECTION && FAULT_INJECTION_DEBUG_FS
> +	default n

First no need to set default to "n", it is already default.
Second, we got NAK from Doug while we proposed to add new Kconfig to our
driver (mlx5) to improve debug.

Doug,
I would like to know if your statement do not add new Kconfigs to IB is
still relevant.

Thanks

--yzvKDKJiLNESc64M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlignm0ACgkQ5GN7iDZy
WKcxbw/+PKSNd+MrRGQI/FwmNL0acRhmhFR7xE1mti4q9NCxy2+rR3NWdIsvXlBu
0kYQqhdQtZi24B/qM95QWjfnvI+I//EbiAu9QRPnVIUKnn9KRLjzbUPgs07roX0f
bQkVb27ic6F/rtakujJlQbBZy6HSKEBPJL1JmMUbyWbf/DDQ40DZWhoPfDUXK1Pk
ZAhJvwcb1sRBCbVo1XR+adaQk0LPEY4oEoHpZk266LR1u8GKEpZjfzKJbj7b+XJE
/J7EbFitZeqIul5pXnVxgsIwJ3MxtCrSOibajUk7emZT7tJ2XGRlr34sOEhvYxiY
d4yxtbBq2WEOMHpF3qH8OdmJAKyO+qSwl7EgQhn8bfPzhoqXrWVREkxzAdPtEk66
Si0w0yM3t/65d/KvesAGRQHb84mhKr83TlyPaPWsR/kB015vJEBMPKUkyL8Ddevm
WhOpurDFh0F/gCbxhJlXqTeRZtLNi+XQZwWFQGJGB9meqV/d0VMowrVOhIgjeh4I
RSF1LjrHl+4GGkFQS42FrhsuyP3I7eCxXwmYvZqXO2JNps+DoTWu3QyQZG2mTY7J
VRdPa7r4lusubJ6bp8WrOACVNI3VR384sFiDeGNBMzT/EvYDkghyViYRayleXhlc
1OH9zXIiNFOuW3nNxYICg9kuLdqxoirvyE4Y8WQhFUir+pGhOAA=
=IFsq
-----END PGP SIGNATURE-----

--yzvKDKJiLNESc64M--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
