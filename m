From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-rc v2 1/4] xprtrdma: Replace global lkey with lkey
 local to PD
Date: Thu, 24 Sep 2015 16:04:08 +0300
Message-ID: <5603F4C8.5080500@dev.mellanox.co.il>
References: <1443080064-28760-1-git-send-email-sagig@mellanox.com>
 <1443080064-28760-2-git-send-email-sagig@mellanox.com>
 <5603F34F.3050505@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5603F34F.3050505-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/24/2015 3:57 PM, Anna Schumaker wrote:
> Hi Sagi,

Hey Anna,

>
> On 09/24/2015 03:34 AM, Sagi Grimberg wrote:
>> From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>
>> The core API has changed so that devices that do not have a global
>> DMA lkey automatically create an mr, per-PD, and make that lkey
>> available. The global DMA lkey interface is going away in favor of
>> the per-PD DMA lkey.
>>
>> The per-PD DMA lkey is always available. Convert xprtrdma to use the
>> device's per-PD DMA lkey for regbufs, no matter which memory
>> registration scheme is in use.
>
> This is going through an RDMA tree somewhere, correct?

Yes, this was from Chuck's 4.4 RFC series. I just included it
in this set as it is related to a driver fix that should go to
4.3-rc.

>  You can add my:
>
> Acked-by: Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
