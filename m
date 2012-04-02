From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/mlx4: fix the case of invalid speed value returned
 when the port is down
Date: Mon, 02 Apr 2012 15:52:18 -0400
Message-ID: <4F7A0372.2050906@dev.mellanox.co.il>
References: <1333377921-8349-1-git-send-email-ogerlitz@mellanox.com> <1333377921-8349-2-git-send-email-ogerlitz@mellanox.com> <CAL1RGDXvR-kk7TE3O33PrifuYoKkgdgAJ9aY5JkduywEf56w+Q@mail.gmail.com> <4F7A0063.4000408@dev.mellanox.co.il> <CAG4TOxM=bPqLySAAJzMtXkG9-SOLCT7ET=KNDK6=_x2mADtKJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxM=bPqLySAAJzMtXkG9-SOLCT7ET=KNDK6=_x2mADtKJw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/2/2012 3:41 PM, Roland Dreier wrote:
> On Mon, Apr 2, 2012 at 12:39 PM, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> How about validating the speed in mlx4 before overwriting it ? Would you
>> take such a patch ?
> 
> I don't think so... what does speed even mean when we're reporting the
> link is down?

It has no meaning but should be a valid not reserved speed.

> Do we gain anything from that check?

It's a small gain. We preserve the original FW value when possible which
means we don't need to remember that this might have be changed by the
kernel if some question comes up in the field. Many mlx4
devices/versions do the right thing here and don't return a reserved value.

-- Hal

>  - R.
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
