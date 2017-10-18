From: Nathan Hartwell <nathan.hartwell-YP+SxaqqoVo2oU8LL9ROB9BPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] rxe_cfg: Fix parsing of ethtool / ifconfig
Date: Wed, 18 Oct 2017 10:12:02 -0600
Message-ID: <CALvXFTfBZYTMzJnbrG2feHkZa6m3OZcZEDqQVN_hSTx+1f_i5A@mail.gmail.com>
References: <CALvXFTdij1WaFL2A05MJBcngn5eJ=ahxwRU64bS_VsCjvnE1XQ@mail.gmail.com>
 <20171018142454.GR2106@mtr-leonro.local> <CAG9sBKMa2nYkjWy37DxbcmMriPtwKFHb2gxn6MYT=YJwa=3E2Q@mail.gmail.com>
 <96dc09fb-14a8-a9ea-58ba-fedba2dc5194@wdc.com> <CAG9sBKNhKNBDhZ=ywQ8xSTDHpmCzeshkRHEiEeQhkpdE_1CuNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKNhKNBDhZ=ywQ8xSTDHpmCzeshkRHEiEeQhkpdE_1CuNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 18, 2017 at 9:15 AM, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> Personally I'm in favor of the latter solution (sysfs). For sysfs attributes
>> backwards compatibility is guaranteed but not for the output of the ifconfig
>> or ip tools.
>>
>> Bart.
>
> I agree

While I agree in principle with the idea to move to sysfs, if that
work would be applied then I would go so far as to say that a complete
rewrite of the scrip should be looked into. For example, there are a
number of other areas (e.g. the calls to modprobe) that can produce
unhelpful (but harmless) warnings to the console. We are focusing on
other fixes that have been found and need to be applied to rxe at the
moment so I am not sure when / if we will cycle around to revisit
updates to the script.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
