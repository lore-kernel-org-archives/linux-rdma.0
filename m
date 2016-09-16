From: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/8] SIF related verbs patches
Date: Fri, 16 Sep 2016 13:30:15 -0700
Message-ID: <92bb7bce-b72f-54e1-59ab-1a93a084b10e@oracle.com>
References: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.15d71ac2c57534f1170c2c48374d3841ed75e676.1474049924.git-series.knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Knut,

On 9/16/2016 11:31 AM, Knut Omang wrote:
> This patch set contains the changes and bug fixes necessary
> to support Oracle's new Infiniband HCA (SIF) from the kernel side.
>
> The exception is patch 3 which is a useful consolidation and simplification
> made possible by patch 2 and the replacement of the dma_attr type with
> a plain bitmask.
>
> The changes to other rdma drivers are just trivial consequences of
> the extended umem_get and create_ah calls and should hopefully be
> uncontroversial.
>
> Patches 4-7 are related to corresponding libibverbs patches.
> These make minor changes (fixing end alignment) to some uverbs
> data structures, but these are carefully made to be backward
> binary compatible between user and kernel for existing provider
> libraries.
>
You have missed SOBs on few patches accidentally. You might want to
fix that for next post :-)

regards,
Santosh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
