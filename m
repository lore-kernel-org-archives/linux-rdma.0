From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv2] opensm/osm_qos.c: Eliminate unneeded endport SL to
 VL setup
Date: Thu, 17 Jun 2010 17:41:29 +0300
Message-ID: <20100617144129.GM20172@me>
References: <20100125202247.GA9197@comcast.net>
 <20100126132605.GJ26338@me>
 <f0e08f231001260530o6260986dice657109f4eea637@mail.gmail.com>
 <AANLkTilHxkXWzb-eEyWMLOtZXAnURNRvtw8-nZVL0OvW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTilHxkXWzb-eEyWMLOtZXAnURNRvtw8-nZVL0OvW-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09:09 Mon 14 Jun     , Hal Rosenstock wrote:
> >
> > This is intended. It's not needed since it's only doing this in the
> > wildcarded case and the wildcarding includes port 0.
> 
> Any reason not to move ahead on this ? Thanks.

No reason. Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
