From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/core: add support for extended performance counters
 in sysfs
Date: Thu, 22 Dec 2011 19:09:57 +0200
Message-ID: <4EF36465.7080505@mellanox.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com> <alpine.LRH.2.00.1110101055570.11243@ogerlitz.voltaire.com> <CAL1RGDXdkiZNtAsnqDtgbCJGLXLFvk8s-YA5mR189kmg6FkabQ@mail.gmail.com> <CAJZOPZ+K3u+u5XutGfBhKh3DaBpNRKV_bw67CLK6jy3060OHqA@mail.gmail.com> <20111101162218.GA10710@obsidianresearch.com> <CAJZOPZLXZL=vEDdXE3rE5Jzw840SrdY=73M7QgKSNzOysRE6MQ@mail.gmail.com> <20111101173625.GH26974@obsidianresearch.com> <CAJZOPZJCY5ehTGw8htsxw0dJgMXJJAS-=LGJde9ddcMsmhqvMg@mail.gmail.com> <20111101183730.GI26974@obsidianresearch.com> <CAG4TOxMOPaTy+Y+M+4xuO_uQ-vqs+Z=GV172UJcqdMrA+mPv=w@mail.gmail.com> <4EB17AF9.3000608@mellanox.com> <CAG4TOxOYAnuB8oKkJgr9_6EpF+YR-h9WNak+gSWwpV0Nz-LeZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxOYAnuB8oKkJgr9_6EpF+YR-h9WNak+gSWwpV0Nz-LeZg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/8/2011 2:54 AM, Roland Dreier wrote:
> Let's make sure we learn from our mistakes. Let's say we create a new 
> "ext_counters" directory. What should the format of those files be? 
> Should they be assumed to be 64-bit quantities? Do we want to allow 
> some way of indicating the number of bits (ie 0-padded hex entries?)?

Hi Roland,Jason -  again, I'd like to re-submit that for kernel 3.3 - if 
there's anything specific you think need to change, could you please 
comment? thanks

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
