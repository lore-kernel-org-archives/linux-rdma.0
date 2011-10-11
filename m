From: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/3] RDMA/nes: Support for Packed And Unaligned fpdus
Date: Tue, 11 Oct 2011 12:43:16 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E904EC29EC51@azsmsx506.amr.corp.intel.com>
References: <20110926013400.GA4132@FLATIF-MOBL4>
 <CAL1RGDVMBCsWnUv3w0y4bETcng4Oud3t33TM=3SR13Ck06pzjg@mail.gmail.com>
 <2EFBCAEF10980645BBCFB605689E08E904EC29E1D4@azsmsx506.amr.corp.intel.com>
 <CAL1RGDWrhQ16OW10KvHfZVDa-D4QV0T9VXqmcJjmN+oFDHuh6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWrhQ16OW10KvHfZVDa-D4QV0T9VXqmcJjmN+oFDHuh6A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sorry, we missed it in the patch.

Just need to add
 
#define NES_DBG_PAU	0x200000

Thanks!
Faisal

> -----Original Message-----
> From: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org [mailto:roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org] On Behalf
> Of Roland Dreier
> Sent: Tuesday, October 11, 2011 11:40 AM
> To: Latif, Faisal
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 3/3] RDMA/nes: Support for Packed And Unaligned
> fpdus
> 
> So as linux-next testing showed, this patch adds uses of NES_DBG_PAU
> but doesn't define it.
> 
> Should I add something in drivers/infiniband/hw/nes/nes.h like:
> 
> #define NES_DBG_PAU    0x00100000
> 
> ?
> 
> Thanks,
>   Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
