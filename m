From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0254/1285] Replace numeric parameter like 0444 with macro
Date: Tue, 2 Aug 2016 11:08:32 -0400
Message-ID: <20160802150832.GA26697@home.goodmis.org>
References: <20160802105341.30676-1-baolex.ni@intel.com>
 <006201d1ecc7$f6889bd0$e399d370$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <006201d1ecc7$f6889bd0$e399d370$@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: 'Baole Ni' <baolex.ni@intel.com>, swise@chelsio.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, airlied@linux.ie, kgene@kernel.org, k.kozlowski@samsung.com, dougthompson@xmission.com, bp@alien8.de, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, hch@infradead.org, matanb@mellanox.com, markb@mellanox.com, jgunthorpe@obsidianresearch.com, dean.luick@intel.com
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 02, 2016 at 09:12:54AM -0500, Steve Wise wrote:
> Acked-by: Steve Wise <swise@opengridcomputing.com>
> 

I have to ask, why did you ack all these? There's several things wrong with
this patch series, but even the point of the patch is mistaken. It makes
readable code much less readable. When you chmod a file, do you type

  chmod 0444 file

or do you write

  chmod S_IRUSR|S_IRGRP|S_IROTH file

?

Which of the above is easier to figure what is being changed?

Not to mention, because the subject is the same for all 1285 patches, and you
deleted the content of the patch in your ack, there's no way to know what
exactly this ack is for (I haven't received the original patch yet because
it's probably being ratelimited by some mail server).

-- Steve
