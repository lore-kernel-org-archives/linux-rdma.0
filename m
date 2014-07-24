From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH libibverbs V4 0/5] Add support for UD QPs under RoCE IP
 addressing
Date: Thu, 24 Jul 2014 11:34:07 +0000
Message-ID: <EE7902D3F51F404C82415C4803930ACD3FE2059B@CMEXMB1.ad.emulex.com>
References: <1400405929-14313-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
 <537AFD31.3000401@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <537AFD31.3000401-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Or,

Is V5 on the cards in the near future?

-Regards
 Devesh

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Or Gerlitz
> Sent: Tuesday, May 20, 2014 12:29 PM
> To: Jason Gunthorpe
> Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
> Subject: Re: [PATCH libibverbs V4 0/5] Add support for UD QPs under RoCE IP
> addressing
> 
> On 18/05/2014 12:38, Or Gerlitz wrote:
> [...]
> > changes from V3 -- addressed feedback from Jason:
> >    - replaced the char* that used to hold the MAC address provided to
> >      the provider library (e.g libmlx4) with sockaddr_storage and use ARPHRD
> >      for the af_family (similar to the practice used in the kernel)
> >
> >    - Dropped mask1 from ibv_query_port_ex and put all fields in
> comp_mask
> >    - Added a man page for ibv_query_port_ex
> >    - Made the code c99 friendly by dropping the anonymous union and
> struct
> >    - Splitted the patches to patch that adds the interface and patch that uses
> it
> >    - Removed the usage of drv_ and lib_ schemas
> >    - Removed the VERBS_CONTEXT_XXXXXXX
> 
> Hi Jason,  so Matan has addressed you comments from V3, could you please
> take a look and ack? we find tiny little bug in patch #1 but want to get your
> feedback before re-spinning  V5.
> 
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
