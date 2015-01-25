From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH ] mlx4_core: Enhance device capabilities flags debug
 printouts
Date: Sun, 25 Jan 2015 12:20:30 +0200
Message-ID: <20150125102029.GA6463@yuval-lab>
References: <1417996112-19060-1-git-send-email-yuval.shaia@oracle.com>
 <54881BFF.2030008@mellanox.com>
 <20141215092153.GF2806@yuval-lab>
 <CAJ3xEMght7jLakWzDOHvqTT_gNSqJJHAjLu_F6gD0j+=Narqmg@mail.gmail.com>
 <20141215122502.GA8027@yuval-lab>
 <CAJ3xEMhespfjA1Epf6qS0wFf_a1wxSODg4L7tpLzAaNpnXiO8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMhespfjA1Epf6qS0wFf_a1wxSODg4L7tpLzAaNpnXiO8g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 15, 2014 at 06:14:31PM +0200, Or Gerlitz wrote:
> >> >> >+               [52] =RSS on fragmented IP datagram support",
> >> >>
> >> >> Hi,
> >> >>
> >> >> Except for Or's comments, [55] exists twice. Furthermore, please
> >> >> move [56]-[57] to be after [55] =Port link type sensing support".
> >> > Thanks,
> >> > Will send a revise patch soon.
> >> > By accepting this patch it is agreed that function will dump device capabilities flag and not the combination of dev & driver capabilities.
> >> > (as the name suggest)
> >>
> >> NO, as Matan wrote you "except for Or's comments" - we do want to dump
> > Sure, was not ignoring this one, it was just a warn :)
> >> what is supported by both the device (firmware) and the driver, and
> >> not more. A subset of your patch can be used, let me know if you want
> >> me to prepare it.
> > Yes please do as i have no idea from where this info can be retrieved.
> 
> 
> Oh, that's easy, just follow on the MLX4_DEV_CAP_FLAG_YYY enum values
> and look for holes in the string array.
Let me try to understand - are you using the holes in the string array to know which are supported by driver?
So currently there is no way for one to tell what FW supports unless it is support by driver.
In that case then all needs to be done is to fill only the features that has MLX4_DEV_CAP_FLAG* but no entry in the string array (e.x MLX4_DEV_CAP_FLAG_WOL_PORT2).
If this is the case then there are some that needs to be removed, i.e holes in enum but filled in the string array, for example "Demand paging support" and "Router support".
> 
> Or.
> 
> > How about the idea of maintaining drv_caps_flags field equivalent to dev_caps_flags?
> >>
> >> Or.
> >>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
