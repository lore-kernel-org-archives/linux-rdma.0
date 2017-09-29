From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 03/12] IB/hfi1: Remove the debug trace message in
 pin_sdma_pages()
Date: Fri, 29 Sep 2017 10:01:59 -0400
Message-ID: <42fd98bc-2d06-b3ba-529a-53f727c3e554@intel.com>
References: <20170926135843.15601.95865.stgit@scvm10.sc.intel.com>
 <20170926140016.15601.51658.stgit@scvm10.sc.intel.com>
 <20170927153033.GH2297@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170927153033.GH2297-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/27/2017 11:30 AM, Leon Romanovsky wrote:
> 
> BTW, by looking on something else,
> 
> 1. I saw that you are not checking for kcalloc failure in drivers/infiniband/hw/hfi1/verbs.c
> 
> 1138                         empty_buf = kcalloc(extra_bytes, sizeof(u8),
> 1139                                             GFP_KERNEL);
> 1140                         seg_pio_copy_mid(pbuf, empty_buf, extra_bytes);
> 
> 2. The following code in drivers/infiniband/hw/hfi1/sdma.c, can and
> should be replaced by kvmalloc. You are incorrectly open-coded failback.
> 
> 1467                 sde->tx_ring =
> 1468                         kcalloc(descq_cnt, sizeof(struct sdma_txreq *),
> 1469                                 GFP_KERNEL);
> 1470                 if (!sde->tx_ring)
> 1471                         sde->tx_ring =
> 1472                                 vzalloc(
> 1473                                         sizeof(struct sdma_txreq *) *
> 1474                                         descq_cnt);
> 

Thanks, we will look into fixing these two issues.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
