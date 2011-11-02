From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/core: add support for extended performance counters
 in sysfs
Date: Wed, 2 Nov 2011 09:38:29 +0200
Message-ID: <4EB0F375.4050901@mellanox.com>
References: <CAL1RGDXdkiZNtAsnqDtgbCJGLXLFvk8s-YA5mR189kmg6FkabQ@mail.gmail.com> <CAJZOPZ+K3u+u5XutGfBhKh3DaBpNRKV_bw67CLK6jy3060OHqA@mail.gmail.com> <20111101162218.GA10710@obsidianresearch.com> <CAJZOPZLXZL=vEDdXE3rE5Jzw840SrdY=73M7QgKSNzOysRE6MQ@mail.gmail.com> <20111101173625.GH26974@obsidianresearch.com> <CAJZOPZJCY5ehTGw8htsxw0dJgMXJJAS-=LGJde9ddcMsmhqvMg@mail.gmail.com> <20111101183730.GI26974@obsidianresearch.com> <CAG4TOxMOPaTy+Y+M+4xuO_uQ-vqs+Z=GV172UJcqdMrA+mPv=w@mail.gmail.com> <20111101215200.GN26974@obsidianresearch.com> <20111101150358.17d232ee.weiny2@llnl.gov> <20111101221135.GP26974@obsidianresearch.com> <CAJZOPZJh2T5nCsdU9B0anUnoB=SpRD2_yBLT620zEi0Kr12MFg@mail.gmail.com> <20111101154627.f3c847dd.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111101154627.f3c847dd.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/2/2011 12:46 AM, Ira Weiny wrote:
> What do you mean "for both"? Ira 

The sysfs PMA counters are functional for both IB and IBoE, the latter uses
a HW counter allocated per device/port for which all the QPs created on 
that
port are reporting their rx/tx bytes/packets, see commits
cfcde11c3d7ae175f49280bb6f913478c2f1bd8c and 
c37791349cc79d025df6e9a4f896a7b0a97cdbd3

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
