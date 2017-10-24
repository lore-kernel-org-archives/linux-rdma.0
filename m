From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] rxe_cfg: Fix parsing of ethtool / ifconfig
Date: Tue, 24 Oct 2017 18:26:32 +0300
Message-ID: <CAG9sBKOGC+gAwLq28oevGRY6d0KBg8F5A6DOGe-rezbuA=Jz7A@mail.gmail.com>
References: <CALvXFTdij1WaFL2A05MJBcngn5eJ=ahxwRU64bS_VsCjvnE1XQ@mail.gmail.com>
 <20171018142454.GR2106@mtr-leonro.local> <CAG9sBKMa2nYkjWy37DxbcmMriPtwKFHb2gxn6MYT=YJwa=3E2Q@mail.gmail.com>
 <96dc09fb-14a8-a9ea-58ba-fedba2dc5194@wdc.com> <CAG9sBKNhKNBDhZ=ywQ8xSTDHpmCzeshkRHEiEeQhkpdE_1CuNQ@mail.gmail.com>
 <CALvXFTfBZYTMzJnbrG2feHkZa6m3OZcZEDqQVN_hSTx+1f_i5A@mail.gmail.com> <20171023154043.GD11952@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171023154043.GD11952-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Nathan Hartwell <nathan.hartwell-YP+SxaqqoVo2oU8LL9ROB9BPR1lH4CV8@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> rxe links (and soft iwarp!) should be created via netlink using Leon's
> new rdma tool. We need a bunch of steps to get there, but that needs
> to be the end goal.
>
Agreed. I'll take it with Leon.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
