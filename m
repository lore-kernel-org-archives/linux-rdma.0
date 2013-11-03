From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC v2 08/10] IB/mlx5: Support IB_WR_REG_SIG_MR
Date: Sun, 3 Nov 2013 14:16:41 +0200
Message-ID: <52763EA9.7080808@mellanox.com>
References: <1383222255-22699-1-git-send-email-sagig@mellanox.com> <1383222255-22699-9-git-send-email-sagig@mellanox.com> <5273C32E.2020405@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5273C32E.2020405-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/1/2013 5:05 PM, Bart Van Assche wrote:
> On 31/10/2013 5:24, Sagi Grimberg wrote:
>> +static u8 bs_selector(int block_size)
>> +{
>> +    switch (block_size) {
>> +    case 512:        return 0x1;
>> +    case 520:        return 0x2;
>> +    case 4096:        return 0x3;
>> +    case 4160:        return 0x4;
>> +    case 1073741824:    return 0x5;
>> +    default:        return 0;
>> +    }
>> +}
>
> Would it be possible to provide some more information about how the 
> five supported block sizes have been chosen ?
>
> Thanks,
>
> Bart.
>

These block_sizes were chosen from our costumers who were interested in 
signature.
This is the current HCA support for the time being.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
