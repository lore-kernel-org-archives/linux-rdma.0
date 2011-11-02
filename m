From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/core: add support for extended performance counters
 in sysfs
Date: Wed, 2 Nov 2011 10:27:09 +0200
Message-ID: <4EB0FEDD.3010504@mellanox.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com> <alpine.LRH.2.00.1110101055570.11243@ogerlitz.voltaire.com> <CAL1RGDXdkiZNtAsnqDtgbCJGLXLFvk8s-YA5mR189kmg6FkabQ@mail.gmail.com> <CAJZOPZ+K3u+u5XutGfBhKh3DaBpNRKV_bw67CLK6jy3060OHqA@mail.gmail.com> <20111101162218.GA10710@obsidianresearch.com> <CAJZOPZLXZL=vEDdXE3rE5Jzw840SrdY=73M7QgKSNzOysRE6MQ@mail.gmail.com> <20111101173625.GH26974@obsidianresearch.com> <CAJZOPZJCY5ehTGw8htsxw0dJgMXJJAS-=LGJde9ddcMsmhqvMg@mail.gmail.com> <20111101183730.GI26974@obsidianresearch.com> <CAJZOPZ+zmwTdHva5C7k0QhBmEzxSGTa1Ajszz3eSH=WpP3A4fg@mail.gmail.com> <20111101215843.GO26974@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111101215843.GO26974-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/1/2011 11:58 PM, Jason Gunthorpe wrote:
> maybe you should patch to un-export them until things can be fixed 
> sanely...

Jason,

I don't think we want to work this way, bug are either opened or 
attempted to be fixed or fixed.

You can't just come out of the the blue and remove functionality which 
is buggy (BTW - to
your taste, I don't agree with your conclusive comments).

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
