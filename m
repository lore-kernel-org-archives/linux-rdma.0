From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 for-next 01/33] IB/core: Add RoCE GID cache
Date: Tue, 14 Apr 2015 17:31:01 +0200
Message-ID: <552D32B5.5090905@sandisk.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
 <44ab0dce-c7c9-400b-af24-10b8981358a7@CMEXHTCAS2.ad.emulex.com>
 <551347E9.5090503@sandisk.com> <552D14C6.50000@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552D14C6.50000-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 04/14/15 15:23, Matan Barak wrote:
>>> +    mutex_lock(&cache->lock);
>>> +
>>> +    for (ix = 0; ix < cache->sz; ix++)
>>> +        if (cache->data_vec[ix].attr.ndev == ndev)
>>> +            write_gid(ib_dev, port, cache, ix, &zgid, &zattr);
>>> +
>>> +    mutex_unlock(&cache->lock);
>>> +    return 0;
>>
>> The traditional Linux kernel coding style is one blank line before
>> mutex_lock() and after mutex_unlock() but not after mutex_lock() nor
>> before mutex_unlock().
>>
>
> I didn't find this in the CodingStyle doc. Could you please quote or
> post a link?

Hello Matan,

I'm not aware of any formal documentation of this style guideline. But 
if you look around in the Linux kernel tree you will see that most 
kernel code follows this style.

Bart.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
