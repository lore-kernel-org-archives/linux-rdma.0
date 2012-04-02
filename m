From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/mlx4: fix the case of invalid speed value returned
 when the port is down
Date: Mon, 02 Apr 2012 15:39:15 -0400
Message-ID: <4F7A0063.4000408@dev.mellanox.co.il>
References: <1333377921-8349-1-git-send-email-ogerlitz@mellanox.com> <1333377921-8349-2-git-send-email-ogerlitz@mellanox.com> <CAL1RGDXvR-kk7TE3O33PrifuYoKkgdgAJ9aY5JkduywEf56w+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXvR-kk7TE3O33PrifuYoKkgdgAJ9aY5JkduywEf56w+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/2/2012 3:27 PM, Roland Dreier wrote:
> On Mon, Apr 2, 2012 at 7:45 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> When the IB port is down, the active_speed value returned by the MAD_IFC
>> command equals seven (7) which isn't among the IB speeds defined by the
>> ib_port_speed enum. This results in invalid speed value seen by higher
>> layers or applications who do port query. Fix that by setting the speed
>> to be SDR - the lowest possible when the port is down.
> 
> This looks reasonable, applied.

How about validating the speed in mlx4 before overwriting it ? Would you
take such a patch ?

-- Hal

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
