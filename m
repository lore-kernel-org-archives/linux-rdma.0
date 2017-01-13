From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 00/26] IB: Optimize DMA mapping
Date: Fri, 13 Jan 2017 21:59:32 +0000
Message-ID: <1484344759.2679.26.camel@sandisk.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
         <F3529576D8E232409F431C309E29399336C5FF0F@CRSMSX102.amr.corp.intel.com>
         <1484338667.2679.15.camel@sandisk.com>
         <F3529576D8E232409F431C309E29399336C5FF78@CRSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F3529576D8E232409F431C309E29399336C5FF78-8k97q/ur5Z1cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Content-ID: <56DC636F747D06429F28B24E3D411541-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-01-13 at 21:08 +0000, Estrin, Alex wrote:
> It didn't fix the failure... Apparently there is an issue with generic
> mapping itself.=20

Hello Alex,

The generic mapping code in lib/dma-virt.c works fine with at least the rxe
driver. Additionally, as far as I can see the mapping code in lib/dma-virt.=
c
is identical to the mapping in drivers/infiniband/sw/rdmavt/dma.c. What is
not clear to me however is how my patches can have caused the SDMA engine
error messages? As far as I can see the code in
drivers/infiniband/hw/hfi1/sdma.c uses PCI DMA mapping operations instead o=
f
the generic dma_virt_ops. Is that correct?

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
