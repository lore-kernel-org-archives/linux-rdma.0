From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: rmmod mlx4_core panic 3.16-rc1
Date: Fri, 20 Jun 2014 10:18:35 -0700
Message-ID: <53A46CEB.2010807@oracle.com>
References: <53A259F3.3040203@oracle.com>	<CAJZOPZK__Qo2LcTpL3R0=WOzsLKY2FYT_7VkKXThGiPWF8wv_g@mail.gmail.com>	<20140620035112.GB23893@richard>	<CAJZOPZJ8r6CVRtuoeYGgDT=TY_YmmwirysoDePsa8KAYZj97cQ@mail.gmail.com>	<20140620062114.GA21472@richard>	<CAJZOPZJAFYxTpBEiAq5Xzo5_zCXAP08P_vRdMsqgxfEL0y6iWA@mail.gmail.com> <CAJZOPZLYBBKK70My5L7++B7_TYKoxrRABPUHegExerBKLcYwcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLYBBKK70My5L7++B7_TYKoxrRABPUHegExerBKLcYwcw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <weiyang-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When loading the modules, the proper arguments need to be checked if one depends on another. You can easily reproduce this problem by only using num_vfs = N.

Shirley

On 06/19/2014 11:34 PM, Or Gerlitz wrote:
> On Fri, Jun 20, 2014 at 9:33 AM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Fri, Jun 20, 2014 at 9:21 AM, Wei Yang <weiyang-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
>>
>>>>> From this log, it happens during probe?
>>>>> If not, any action after probe?
>>
>>>> yep, maybe the bug still exists in the error flow of probe? you can probe with
>>>> num_vfs=1,1,1 port_type_array=1,1 and see if you hit it
>>
>>> I tried this
>>> modprobe mlx4_core num_vfs=3 probe_vf=3 port_type_array=1,1
>>> It looks good to me.
>>
>> NO. I wanted you to hit the error flow where this bug seems to
>> remain... so you need to try and use single ported VFs with IB e.g
>> $ modprobe mlx4_core num_vfs=1,1,1 port_type_array=1,1
> 
> or
> 
> $ modprobe mlx4_core num_vfs=1,1,1 probe_vf=1,1,1 rt_type_array=1,1
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
