From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/mlx4: fix the case of invalid speed value returned
 when the port is down
Date: Mon, 2 Apr 2012 12:41:30 -0700
Message-ID: <CAG4TOxM=bPqLySAAJzMtXkG9-SOLCT7ET=KNDK6=_x2mADtKJw@mail.gmail.com>
References: <1333377921-8349-1-git-send-email-ogerlitz@mellanox.com>
 <1333377921-8349-2-git-send-email-ogerlitz@mellanox.com> <CAL1RGDXvR-kk7TE3O33PrifuYoKkgdgAJ9aY5JkduywEf56w+Q@mail.gmail.com>
 <4F7A0063.4000408@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F7A0063.4000408-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 2, 2012 at 12:39 PM, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> How about validating the speed in mlx4 before overwriting it ? Would you
> take such a patch ?

I don't think so... what does speed even mean when we're reporting the
link is down?
Do we gain anything from that check?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
