From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/iser: Accept session->cmds_max from user space
Date: Mon, 8 Jul 2013 17:01:14 +0300
Message-ID: <51DAC62A.7040605@mellanox.com>
References: <1373289560-24681-1-git-send-email-ogerlitz@mellanox.com> <1373289560-24681-4-git-send-email-ogerlitz@mellanox.com> <51DAC5FF.2050107@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51DAC5FF.2050107-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/07/2013 17:00, Bart Van Assche wrote:
> On 07/08/13 15:19, Or Gerlitz wrote:
>> +#define ISER_DEF_XMIT_CMDS_DEFUALT 512
>> +#if ISCSI_DEF_XMIT_CMDS_MAX > ISER_DEF_XMIT_CMDS_DEFUALT
>
> This looks like another spelling issue - shouldn't DEFUALT be changed 
> into DEFAULT ?
>
> Bart.

thanks for the quick feedback, will fix and re-submit

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
