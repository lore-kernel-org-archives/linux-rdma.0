From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 03/24] IB/mlx5: Support the new memory registration API
Date: Thu, 24 Sep 2015 10:39:39 +0300
Message-ID: <5603A8BB.9080706@dev.mellanox.co.il>
References: <1442482947-27785-1-git-send-email-sagig@mellanox.com>
 <1442482947-27785-4-git-send-email-sagig@mellanox.com>
 <5601C7A4.5030302@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5601C7A4.5030302-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/23/2015 12:27 AM, Bart Van Assche wrote:
> On 09/17/2015 02:42 AM, Sagi Grimberg wrote:
>> +static int
>> +mlx5_alloc_priv_descs(struct ib_device *device,
>> +              struct mlx5_ib_mr *mr,
>> +              int ndescs,
>> +              int desc_size)
>> +{
>> +    int size = ndescs * desc_size;
>> +
>> +    mr->descs = dma_alloc_coherent(device->dma_device, size,
>> +                       &mr->desc_map, GFP_KERNEL);
>> +    if (!mr->descs)
>> +        return -ENOMEM;
>> +
>> +    return 0;
>> +}
>
> Would it be possible to clarify the choice for coherent memory ?

No specific reason. I was just copying  alloc_fastreg_page_list logic.

> Would performance be better if non-coherent memory would be used and if memory
> would be synced after initialization of desc_map has finished ?

It probably would I assume. I'll change that.

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
