From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/mlx4: fix the case of invalid speed value returned
 when the port is down
Date: Wed, 4 Apr 2012 00:36:21 -0700
Message-ID: <CAL1RGDUPeGfABU=BM1+iEywJsH_g=8+F5WoMdOBVLh1BfZUWBg@mail.gmail.com>
References: <1333377921-8349-1-git-send-email-ogerlitz@mellanox.com>
 <1333377921-8349-2-git-send-email-ogerlitz@mellanox.com> <CAL1RGDXvR-kk7TE3O33PrifuYoKkgdgAJ9aY5JkduywEf56w+Q@mail.gmail.com>
 <4F7BEC4B.2030503@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F7BEC4B.2030503-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 3, 2012 at 11:38 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wro=
te:
> On 4/2/2012 10:27 PM, Roland Dreier wrote:
>>
>> This looks reasonable, applied
>
>
> Thanks, so we're in a situation where there are / will be fixes for 3=
=2E4 and
> new code for 3.5 is coming, how about that suggestion I made lately -
> =A0for-next to contain code for the next kernel (e.g 3.5 at this poin=
t) and
> have a different branch (maybe rc-fixes) to track fixes for the curre=
nt
> kernel (e.g 3.4)?

Yes, I am planning on doing that, and also never rebasing my for-next b=
ranch.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
