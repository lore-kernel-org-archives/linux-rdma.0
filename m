From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v1 01/24] IB/core: Introduce new fast registration API
Date: Tue, 22 Sep 2015 14:21:35 -0700
Message-ID: <5601C65F.8060403@sandisk.com>
References: <1442482947-27785-1-git-send-email-sagig@mellanox.com>
 <1442482947-27785-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442482947-27785-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/17/2015 02:42 AM, Sagi Grimberg wrote:
> The new fast registration  verg ib_map_mr_sg receives a scatterlist

                              ^ verb ?

> +/**
> + * ib_map_mr_sg() - Map a memory region with the largest prefix of
> + *     a dma mapped SG list

This description could be made more clear. How about the following:

Register the largest possible prefix of a DMA-mapped SG-list

> +			} else if (last_page_off + dma_len < mr->page_size) {
> +				/* chunk this fragment with the last */
> +				last_end_dma_addr += dma_len;
> +				last_page_off += dma_len;
> +				mr->length += dma_len;
> +				continue;

Shouldn't this code update last_page_addr ?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
