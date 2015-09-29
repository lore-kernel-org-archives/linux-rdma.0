From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 00/24] New fast registration API
Date: Tue, 29 Sep 2015 23:58:25 +0300
Message-ID: <560AFB71.3010003@dev.mellanox.co.il>
References: <1442482947-27785-1-git-send-email-sagig@mellanox.com>
 <560AE099.2080004@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <560AE099.2080004-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/29/2015 10:03 PM, Bart Van Assche wrote:
> On 09/17/2015 02:42 AM, Sagi Grimberg wrote:
>> - Converted SRP initiator and RDS iwarp ULPs to the new API
>
> Hello Sagi,
>

Hi Bart,

> How has the converted SRP initiator driver been tested ? With the kernel
> tree that is available on branch reg_api.4

That's odd. Although I haven't formally submitted reg_api.4 yet, I did
test ib_srp initiator against upstream srpt over CX3 (mlx4) and CX4
(mlx5). I ran connect, disconnect, stress IO of all block sizes and
some unaligned block-IO and SG_IO test utilities. It all seems to pass
for me.

Just this morning (my morning) I tested the v2 set on iser, srp, nfs. I
placed that in branch reg_api.5. Would you mind running reg_api.5 and 
see if this issue persist (I would be surprised because I haven't seen
any sign of it)?

Thanks,
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
