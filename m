From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 0/9] Peer-Direct support
Date: Mon, 6 Oct 2014 23:24:21 +0300
Message-ID: <CAJ3xEMg=AeeQemGU7hL05=o9vOHHY2Xum=B7ewhUGFZr7OCyuw@mail.gmail.com>
References: <1412602019-30659-1-git-send-email-yishaih@mellanox.com>
	<5432B149.7060202@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5432B149.7060202-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 6, 2014 at 6:12 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> On 10/6/2014 8:26 AM, Yishai Hadas wrote:
>>
>> The following set of patches implements Peer-Direct support over RDMA
>> stack.
>>      Peer-Direct technology allows RDMA operations to directly target
>> memory in external hardware devices, such as GPU cards, SSD based
>> storage, dedicated ASIC accelerators, etc.
>>      This technology allows RDMA-based (over InfiniBand/RoCE) application
>> to avoid unneeded data copying when sharing data between peer hardware
>> devices.
> Does this also work over iWARP devices?

I guess so, any reason that leads you to suspect this isn't the case?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
