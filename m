From: Chris Metcalf <cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] tile: revert pr_info to printk in <asm/io.h>
Date: Mon, 4 Feb 2013 12:56:41 -0500
Message-ID: <510FF659.8030905@tilera.com>
References: <201302012043.r11KhFXi024365@farm-0021.internal.tilera.com> <1359758038.17807.18.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359758038.17807.18.camel@joe-AO722>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/1/2013 5:33 PM, Joe Perches wrote:
> On Fri, 2013-02-01 at 12:34 -0500, Chris Metcalf wrote:
>> Using pr_info in a header exposes us to potential trouble from
>> subsystems that define pr_fmt.  This change fixes:
>>
>>   In file included from include/linux/scatterlist.h:10,
>>                    from include/scsi/scsi.h:12,
>>                    from drivers/infiniband/ulp/srp/ib_srp.c:46:
>>   arch/tile/include/asm/io.h: In function =E2=80=98ioport_map=E2=80=99=
:
>>   arch/tile/include/asm/io.h:296: error: expected =E2=80=98)=E2=80=99=
 before =E2=80=98PFX=E2=80=99
> Interesting.
>
>> diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
> []
>> @@ -292,7 +292,7 @@ static inline long ioport_panic(void)
>> =20
>>  static inline void __iomem *ioport_map(unsigned long port, unsigned=
 int len)
>>  {
>> -	pr_info("ioport_map: mapping IO resources is unsupported on tile.\=
n");
>> +	printk("ioport_map: mapping IO resources is unsupported on tile.\n=
");
> It'd be nicer to add an appropriate KERN_<LEVEL> here.
>
> My preference would be to change ib_srp.c (and ib_srpt) like:
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband=
/ulp/srp/ib_srp.c
> index d5088ce..59bf409 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -30,7 +30,7 @@
>   * SOFTWARE.
>   */
> =20
> -#define pr_fmt(fmt) PFX fmt
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> =20
>  #include <linux/module.h>
>  #include <linux/init.h>
>

Makes sense to me, and it does fix the compile failure.  I've pulled my=
 original change from my tree and instead, for the change above (assumi=
ng Joe is implicitly providing a Signed-off-by on this patch):

Acked-by: Chris Metcalf <cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org>

--=20
Chris Metcalf, Tilera Corp.
http://www.tilera.com

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
