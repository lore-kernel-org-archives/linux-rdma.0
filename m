From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-rc v1 1/4] xprtrdma: Replace global lkey with lkey
 local to PD
Date: Mon, 21 Sep 2015 23:27:42 +0300
Message-ID: <5600683E.20603@dev.mellanox.co.il>
References: <1442853674-8677-1-git-send-email-sagig@mellanox.com>
 <1442853674-8677-2-git-send-email-sagig@mellanox.com>
 <4A6B165D-7603-4803-8B57-1FBDE5D921A5@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4A6B165D-7603-4803-8B57-1FBDE5D921A5-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/21/2015 8:03 PM, Chuck Lever wrote:
>
>> On Sep 21, 2015, at 9:41 AM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrot=
e:
>>
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
>>
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> You=E2=80=99ll probably need an Acked-by from Anna or Trond.

Yea, I have a v2 as I forgot to address a comment from Or.

I'll CC linux-nfs on this patch. Sorry for forgetting.

Thanks Chuck.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
