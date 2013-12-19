From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: randconfig build error with next-20131211, in drivers/infiniband/hw/usnic/usnic_uiom.c
Date: Thu, 19 Dec 2013 12:02:04 -0800
Message-ID: <52B350BC.8000903@infradead.org>
References: <CA+r1ZhhA1QDeNwvOb+Yn_eoQ9VPS2VmAkGZXt8HJRiagp-rvTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+r1ZhhA1QDeNwvOb+Yn_eoQ9VPS2VmAkGZXt8HJRiagp-rvTg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Davis <jim.epost-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/11/13 07:57, Jim Davis wrote:
> Building with the attached random configuration file,
>=20
> drivers/infiniband/hw/usnic/usnic_uiom.c: In function
> =91usnic_uiom_attach_dev_to_pd=92:
> drivers/infiniband/hw/usnic/usnic_uiom.c:505:2: error: implicit decla=
ration of f
> unction =91iommu_domain_has_cap=92 [-Werror=3Dimplicit-function-decla=
ration]
>   if (!iommu_domain_has_cap(pd->domain, IOMMU_CAP_CACHE_COHERENCY)) {
>   ^
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/infiniband/hw/usnic/usnic_uiom.o] Error 1
>=20


This build error still happens in linux-next of 20131219.

--=20
~Randy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
