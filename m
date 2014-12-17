From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH] RDMA/cma: fix first byte overwritten for AF_IB
Date: Wed, 17 Dec 2014 11:02:06 +0100
Message-ID: <CAMGffEn9cxNqv48Vyv_TSB5yO7CgGLDHGjVJBRTihPw0v=EJhw@mail.gmail.com>
References: <1418744596-25251-1-git-send-email-jinpu.wang@profitbricks.com> <1828884A29C6694DAF28B7E6B8A8237399E2DE69@ORSMSX110.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399E2DE69-8oqHQFITsIHTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

Thanks for looking into this.

I checked nfiniBand TM Architecture Release 1.2.1 VOLUME 1 - GENERAL
SPECIFICATIONS, for RDMA IP CM service,
the private data for CM REQ is defined in:
Table 532 IP Addressing CM REQ Message Private Data Format
So you mean even for RDMA IB, the private data format is also
required, could you point me a little more detail?



On Tue, Dec 16, 2014 at 10:29 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wr=
ote:
>> If user attach private data for AF_IB, the first byte will
>> be overwritten, because we always set the cma version no matter
>> family is AF_IB, so move the version set inside if condition.
>>
>> Reported-by: Fabian Holler <fabian.holler-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
>> Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
>> ---
>>  drivers/infiniband/core/cma.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core=
/cma.c
>> index d570030..22a22e2 100644
>> --- a/drivers/infiniband/core/cma.c
>> +++ b/drivers/infiniband/core/cma.c
>> @@ -2618,10 +2618,10 @@ static int cma_format_hdr(void *hdr, struct
>> rdma_id_private *id_priv)
>>       struct cma_hdr *cma_hdr;
>>
>>       cma_hdr =3D hdr;
>> -     cma_hdr->cma_version =3D CMA_VERSION;
>>       if (cma_family(id_priv) =3D=3D AF_INET) {
>>               struct sockaddr_in *src4, *dst4;
>>
>> +             cma_hdr->cma_version =3D CMA_VERSION;
>>               src4 =3D (struct sockaddr_in *) cma_src_addr(id_priv);
>>               dst4 =3D (struct sockaddr_in *) cma_dst_addr(id_priv);
>>
>> @@ -2632,6 +2632,7 @@ static int cma_format_hdr(void *hdr, struct
>> rdma_id_private *id_priv)
>>       } else if (cma_family(id_priv) =3D=3D AF_INET6) {
>>               struct sockaddr_in6 *src6, *dst6;
>>
>> +             cma_hdr->cma_version =3D CMA_VERSION;
>>               src6 =3D (struct sockaddr_in6 *) cma_src_addr(id_priv)=
;
>>               dst6 =3D (struct sockaddr_in6 *) cma_dst_addr(id_priv)=
;
>
> I don't think this is sufficient.  The RDMA CM private data header is=
 defined by the IB spec.  If the service ID starts with the prefix 0x00=
00000001, it's reasonable to assume that the header is part of the priv=
ate data.  The receive side should probably even check the version and =
discard any unknown values.
>
> - Sean



--=20
Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin
Tel: +49 30 5770083-42
=46ax: +49 30 5770085-98
Email: jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: http://www.profitbricks.de

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B.
Gesch=C3=A4ftsf=C3=BChrer: Andreas Gauger, Achim Weiss.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
