From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 5/6] net/mlx4: Adjust initial value of vl_cap
 in mlx4_SET_PORT
Date: Sun, 20 May 2012 14:21:36 +0300
Message-ID: <4FB8D3C0.7040603@mellanox.com>
References: <1336681689-16668-1-git-send-email-ogerlitz@mellanox.com> <1336681689-16668-6-git-send-email-ogerlitz@mellanox.com> <CAL1RGDUjNrRnU2_cfbdJd790K9oLD+rRFQDOyR6eX-3R1tWbQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUjNrRnU2_cfbdJd790K9oLD+rRFQDOyR6eX-3R1tWbQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aviad Yehezkel <aviadye-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/19/2012 3:40 AM, Roland Dreier wrote:
>> +#define CX3_PPF_DEV_ID 0x1003
>> +static int vl_cap_start(struct mlx4_dev *dev)
>> +{
>> +       /* for non CX3 devices, start with 4 VLs to avoid errors in syslog */
>> +       if (dev->pdev->device != CX3_PPF_DEV_ID)
>> +               return 4;
>> +       return 8;
>> +}
>
> This really doesn't look maintainable as different devices with different limits come along.

Yep, I considered this patch to be a bit of ugly, but decided to send it 
since the potential damage without
something done here e.g wrong support calls as of false negatives prints 
seemed to justify that..  BTW I noticed
that today there IS some CX3 special code in mlx4_core/main.c

> 282-    /* Sense port always allowed on supported devices for 
> ConnectX1 and 2 */
> 283:    if (dev->pdev->device != 0x1003)
> 284-            dev->caps.flags |= MLX4_DEV_CAP_FLAG_SENSE_SUPPORT;

anyway,

>
> How ugly is it to pass some sort of "no warn" flag down into the command to suppress the messages?

We will check the feasibility of doing so.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
