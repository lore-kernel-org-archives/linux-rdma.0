From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] staging/rdma/hfi1: select CRC32
Date: Thu, 14 Apr 2016 13:59:22 -0400
Message-ID: <20160414175922.GB11641@rhel.sc.intel.com>
References: <1459465467-31367-1-git-send-email-markus.boehme@mailbox.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459465467-31367-1-git-send-email-markus.boehme-cl+VPiYnx/1AfugRpC6u6w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus =?iso-8859-1?Q?B=F6hme?= <markus.boehme-cl+VPiYnx/1AfugRpC6u6w@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 01, 2016 at 01:04:05AM +0200, Markus B=F6hme wrote:
> The function parse_platform_config in firmware.c calls crc32_le.
> Building without CRC32 selected causes a link error:
>=20
> drivers/built-in.o: In function `parse_platform_config':
> (.text+0x92ffa): undefined reference to `crc32_le'
>=20
> Signed-off-by: Markus B=F6hme <markus.boehme-cl+VPiYnx/1AfugRpC6u6w@public.gmane.org>

Doug did you pick this up?

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
>  drivers/staging/rdma/hfi1/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/staging/rdma/hfi1/Kconfig b/drivers/staging/rdma=
/hfi1/Kconfig
> index 3e668d8..a925fb0 100644
> --- a/drivers/staging/rdma/hfi1/Kconfig
> +++ b/drivers/staging/rdma/hfi1/Kconfig
> @@ -2,6 +2,7 @@ config INFINIBAND_HFI1
>  	tristate "Intel OPA Gen1 support"
>  	depends on X86_64 && INFINIBAND_RDMAVT
>  	select MMU_NOTIFIER
> +	select CRC32
>  	default m
>  	---help---
>  	This is a low-level driver for Intel OPA Gen1 adapter.
> --=20
> 1.7.10.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
