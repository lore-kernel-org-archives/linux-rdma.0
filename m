From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 07/37] lib/dma-virt: Add dma_virt_ops
Date: Mon, 23 Jan 2017 16:12:19 +0000
Message-ID: <1485187925.2825.2.camel@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
         <20170120210437.26389-8-bart.vanassche@sandisk.com>
         <20170123160341.GM9529@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170123160341.GM9529-l3A5Bk7waGM@public.gmane.org>
Content-Language: en-US
Content-ID: <5D845D94FF6F2A40ACB8FA47B15AB176-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jroedel-l3A5Bk7waGM@public.gmane.org" <jroedel-l3A5Bk7waGM@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-01-23 at 17:03 +0100, Joerg Roedel wrote:
> On Fri, Jan 20, 2017 at 01:04:07PM -0800, Bart Van Assche wrote:
> > +static void *dma_virt_alloc(struct device *dev, size_t size,
> > +			    dma_addr_t *dma_handle, gfp_t gfp,
> > +			    unsigned long attrs)
> > +{
> > +	void *ret;
> > +
> > +	ret =3D (void *)__get_free_pages(gfp, get_order(size));
> > +	if (ret)
> > +		*dma_handle =3D (uintptr_t)ret;
>=20
> Why do you cast to uintptr_t everywhere in this patch before assigning
> to a dma_addr_t when you can cast directly to dma_addr_t?

Hello Joerg,

There is at least one Linux architecture for which pointers are 64 bits
wide and dma_addr_t is 32 bits wide. As you know casting a 64-bit pointer
to a 32-bit integer type triggers a compiler warning. That's why I used
uintptr_t instead of dma_addr_t.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
