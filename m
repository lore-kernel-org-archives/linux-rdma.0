From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 15/26] IB/srp: Split srp_map_sg
Date: Sun, 27 Sep 2015 10:03:55 +0300
Message-ID: <560794DB.1050200@dev.mellanox.co.il>
References: <1443116118-10730-1-git-send-email-sagig@mellanox.com>
 <1443116118-10730-16-git-send-email-sagig@mellanox.com>
 <56057320.4010905@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56057320.4010905-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/25/2015 7:15 PM, Bart Van Assche wrote:
> On 09/24/2015 10:35 AM, Sagi Grimberg wrote:
>> This is a perparation patch for the new registration API
>              ^ preparation ?

Fixed, thanks.

>> +    WARN_ON_ONCE(!dev->use_fmr);
>> +
>> +    if (state->npages == 0)
>> +        return 0;
>> +
>> +    if (state->npages == 1 && target->global_mr) {
>> +        srp_map_desc(state, state->base_dma_addr, state->dma_len,
>> +                 target->global_mr->rkey);
>> +        return 0;
>> +    }
>> +
>
> The above is not correct. The npages and dma_len variables have to be
> reset before returning. How about changing the "return 0" statement into
> "goto reset_state" and adding a "reset_state" label ?

Done, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
