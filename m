From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH -next] infiniband: fix printk format in hw/nes_cm.c
Date: Mon, 17 Oct 2011 14:18:30 -0700
Message-ID: <CAL1RGDXqQ+5W2LH5c6jzR6_AygcJ+Xh=0fcHga=Ps8rjEnPE8w@mail.gmail.com>
References: <20111013181606.a204565fad9caaa0fe680b75@canb.auug.org.au> <4E976147.9030000@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E976147.9030000@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Faisal Latif <faisal.latif@intel.com>, Linux RDMA <linux-rdma@vger.kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Thanks, rolled this into the offending commit.
