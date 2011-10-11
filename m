From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] RDMA/nes: Support for Packed And Unaligned fpdus
Date: Tue, 11 Oct 2011 09:40:28 -0700
Message-ID: <CAL1RGDWrhQ16OW10KvHfZVDa-D4QV0T9VXqmcJjmN+oFDHuh6A@mail.gmail.com>
References: <20110926013400.GA4132@FLATIF-MOBL4> <CAL1RGDVMBCsWnUv3w0y4bETcng4Oud3t33TM=3SR13Ck06pzjg@mail.gmail.com>
 <2EFBCAEF10980645BBCFB605689E08E904EC29E1D4@azsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2EFBCAEF10980645BBCFB605689E08E904EC29E1D4-uLM7Qlg6MbdZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

So as linux-next testing showed, this patch adds uses of NES_DBG_PAU
but doesn't define it.

Should I add something in drivers/infiniband/hw/nes/nes.h like:

#define NES_DBG_PAU    0x00100000

?

Thanks,
  Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
