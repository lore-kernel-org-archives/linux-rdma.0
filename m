From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH] rxe_cfg: Fix parsing of ethtool / ifconfig
Date: Wed, 18 Oct 2017 08:03:57 -0700
Message-ID: <96dc09fb-14a8-a9ea-58ba-fedba2dc5194@wdc.com>
References: <CALvXFTdij1WaFL2A05MJBcngn5eJ=ahxwRU64bS_VsCjvnE1XQ@mail.gmail.com>
 <20171018142454.GR2106@mtr-leonro.local>
 <CAG9sBKMa2nYkjWy37DxbcmMriPtwKFHb2gxn6MYT=YJwa=3E2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKMa2nYkjWy37DxbcmMriPtwKFHb2gxn6MYT=YJwa=3E2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Nathan Hartwell <nathan.hartwell-YP+SxaqqoVo2oU8LL9ROB9BPR1lH4CV8@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/18/17 07:45, Moni Shoua wrote:
> On Wed, Oct 18, 2017 at 5:24 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> Moni ?????
>>
>> Thanks
>>
>> On Wed, Oct 11, 2017 at 01:00:24PM -0600, Nathan Hartwell wrote:
>>> rxe_cfg does not always parse the output of ethtool and ifconfig correctly.
>>>
>>> Fix two items:
>>> 1)  Parsing of ethtool's link speed field to always output a link speed.
> 
>>> 2)  Parsing of ifconfig's IP address / MTU fields with newer builds of
>>> ifconfig that have a slightly different output format than in the
>>> past.
> did you consider replacing ifconfig with ip? I can't say for sure but
> the recommendation AFAIK is to replace is to replace ifconfig with ip
> in scripts that parse the output
> Another alternative is to use /sys file system (e.g. /sys/class/net/p2p1/speed)

Personally I'm in favor of the latter solution (sysfs). For sysfs 
attributes backwards compatibility is guaranteed but not for the output 
of the ifconfig or ip tools.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
