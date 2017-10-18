From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] rxe_cfg: Fix parsing of ethtool / ifconfig
Date: Wed, 18 Oct 2017 18:15:23 +0300
Message-ID: <CAG9sBKNhKNBDhZ=ywQ8xSTDHpmCzeshkRHEiEeQhkpdE_1CuNQ@mail.gmail.com>
References: <CALvXFTdij1WaFL2A05MJBcngn5eJ=ahxwRU64bS_VsCjvnE1XQ@mail.gmail.com>
 <20171018142454.GR2106@mtr-leonro.local> <CAG9sBKMa2nYkjWy37DxbcmMriPtwKFHb2gxn6MYT=YJwa=3E2Q@mail.gmail.com>
 <96dc09fb-14a8-a9ea-58ba-fedba2dc5194@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <96dc09fb-14a8-a9ea-58ba-fedba2dc5194-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nathan Hartwell <nathan.hartwell-YP+SxaqqoVo2oU8LL9ROB9BPR1lH4CV8@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Personally I'm in favor of the latter solution (sysfs). For sysfs attributes
> backwards compatibility is guaranteed but not for the output of the ifconfig
> or ip tools.
>
> Bart.

I agree
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
