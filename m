From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] rxe_cfg: Fix parsing of ethtool / ifconfig
Date: Mon, 23 Oct 2017 09:40:43 -0600
Message-ID: <20171023154043.GD11952@obsidianresearch.com>
References: <CALvXFTdij1WaFL2A05MJBcngn5eJ=ahxwRU64bS_VsCjvnE1XQ@mail.gmail.com>
 <20171018142454.GR2106@mtr-leonro.local>
 <CAG9sBKMa2nYkjWy37DxbcmMriPtwKFHb2gxn6MYT=YJwa=3E2Q@mail.gmail.com>
 <96dc09fb-14a8-a9ea-58ba-fedba2dc5194@wdc.com>
 <CAG9sBKNhKNBDhZ=ywQ8xSTDHpmCzeshkRHEiEeQhkpdE_1CuNQ@mail.gmail.com>
 <CALvXFTfBZYTMzJnbrG2feHkZa6m3OZcZEDqQVN_hSTx+1f_i5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALvXFTfBZYTMzJnbrG2feHkZa6m3OZcZEDqQVN_hSTx+1f_i5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nathan Hartwell <nathan.hartwell-YP+SxaqqoVo2oU8LL9ROB9BPR1lH4CV8@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 18, 2017 at 10:12:02AM -0600, Nathan Hartwell wrote:

> work would be applied then I would go so far as to say that a complete
> rewrite of the scrip should be looked into.

Yes. This script is horrid and needs to go away.

rxe links (and soft iwarp!) should be created via netlink using Leon's
new rdma tool. We need a bunch of steps to get there, but that needs
to be the end goal.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
