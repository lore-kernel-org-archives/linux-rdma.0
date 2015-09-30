From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v1 00/24] New fast registration API
Date: Wed, 30 Sep 2015 13:15:10 -0700
Message-ID: <560C42CE.6090000@sandisk.com>
References: <1442482947-27785-1-git-send-email-sagig@mellanox.com>
 <560AE099.2080004@sandisk.com> <560AFB71.3010003@dev.mellanox.co.il>
 <560C30F4.50900@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <560C30F4.50900-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/30/2015 11:59 AM, Bart Van Assche wrote:
> On 09/29/2015 01:58 PM, Sagi Grimberg wrote:
>> On 9/29/2015 10:03 PM, Bart Van Assche wrote:
>>> On 09/17/2015 02:42 AM, Sagi Grimberg wrote:
>>>> - Converted SRP initiator and RDS iwarp ULPs to the new API
>>> How has the converted SRP initiator driver been tested ? With the kernel
>>> tree that is available on branch reg_api.4
>>
>> That's odd. Although I haven't formally submitted reg_api.4 yet, I did
>> test ib_srp initiator against upstream srpt over CX3 (mlx4) and CX4
>> (mlx5). I ran connect, disconnect, stress IO of all block sizes and
>> some unaligned block-IO and SG_IO test utilities. It all seems to pass
>> for me.
>>
>> Just this morning (my morning) I tested the v2 set on iser, srp, nfs. I
>> placed that in branch reg_api.5. Would you mind running reg_api.5 and
>> see if this issue persist (I would be surprised because I haven't seen
>> any sign of it)?
>
> Sorry but I still see these messages with the reg_api.5 branch.
> [root@ib-ini linux-kernel]# git show HEAD | grep ^commit
> commit 3b5b34777d3cd606433f0aca51e3885323648e07
> [root@ib-ini linux-kernel]# uname -a
> Linux ib-ini 4.2.0-rc6-debug+ #1 SMP Wed Sep 30 11:38:36 PDT 2015 x86_64
> x86_64 x86_64 GNU/Linux
>
> I will try to run a bisect.

(replying to my own e-mail)

Apparently this behavior got introduced through the patch "IB/srp: 
Convert to new registration API" (commit 
ad66cbace5ca8c60673bedf35e5027868b0dd2d7). Without that patch SRP I/O 
works fine. With that patch I see receive failures being reported. The 
SRP initiator was loaded on my setup with the following kernel driver 
options:

# cat /etc/modprobe.d/ib_srp.conf
options ib_srp cmd_sg_entries=255 prefer_fr=1 register_always=1

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
