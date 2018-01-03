From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 14/15] IB/mlx5: Don't advertise RAW QP support
 in dual port mode
Date: Wed, 3 Jan 2018 14:35:47 -0600
Message-ID: <ab3fb697-7b2c-685c-2151-5f48d5d7270a@mellanox.com>
References: <20171224125741.25464-1-leon@kernel.org>
 <20171224125741.25464-15-leon@kernel.org>
 <CAJ3xEMgAtd1PKN2h1NFj=Mt72msuU5bpFy0jO4KFXxXxGRf7hA@mail.gmail.com>
 <20171225071613.GW2942@mtr-leonro.local>
 <CAJ3xEMhtssDWuu8JAB_jhyofKbkeo4vYTLixLeta6vPzKQOp+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhtssDWuu8JAB_jhyofKbkeo4vYTLixLeta6vPzKQOp+A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/25/2017 3:17 AM, Or Gerlitz wrote:
> On Mon, Dec 25, 2017 at 9:16 AM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> On Mon, Dec 25, 2017 at 12:16:15AM +0200, Or Gerlitz wrote:
>>> On Sun, Dec 24, 2017 at 2:57 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>
>>>> When operating in dual port RoCE mode RAW QPs are not supposed
>>>> to work on the slave port.
>>> why?
>> HW create flow table restriction.
>
> cryptic to me, either put a proper explanation on the V2 change log
> for this patch
> so we can review it then or explain it here if you want a review on V1

We don't report RAW QP support on a per port basis.  It's per device.  The user doesn't know which port is the master/slave, so we shouldn't support RAW QP at all in this mode. I'll update the commit message to state that.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
