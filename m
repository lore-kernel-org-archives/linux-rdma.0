From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v4 2/2] ulps: Align several ULPs to use core/rdma_cm logging
 helpers
Date: Tue, 12 May 2015 14:31:44 +0300
Message-ID: <5551E4A0.3050405@dev.mellanox.co.il>
References: <1431425527-30114-1-git-send-email-sagig@mellanox.com>	 <1431425527-30114-3-git-send-email-sagig@mellanox.com> <1431428675.25060.48.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431428675.25060.48.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/12/2015 2:04 PM, Yann Droneaud wrote:
> Hi,
>
> Le mardi 12 mai 2015 =C3=A0 13:12 +0300, Sagi Grimberg a =C3=A9crit :
>> Remove rds & xprtrdma specific helpers and have them and
>> srp, iser, isert use the generic helpers. While we're at it
>> align svcrdma as well.
>>
>> Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>> Reviewed-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
>
> That's quite a big patch. Why not splitting it per ulp ?

Its just cosmetics, I can do it though...

>
> Anyway, is changing the format of the messages going to break some
> userspace trying to parse those ?
>

I don't think logging is something that user-space should rely on
to be unmodified forever.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
