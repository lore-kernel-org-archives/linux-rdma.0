From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/8] IB/cxgb4: Fix formatting of physical address
Date: Sun, 27 Oct 2013 15:54:38 -0700
Message-ID: <1382914478.30941.18.camel@joe-AO722>
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
	 <1382910645.2994.45.camel@deadeye.wl.decadent.org.uk>
	 <1382911111.30941.2.camel@joe-AO722>
	 <1382911333.2994.55.camel@deadeye.wl.decadent.org.uk>
	 <1382912049.30941.5.camel@joe-AO722>
	 <1382912801.2994.61.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1382912801.2994.61.camel@deadeye.wl.decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2013-10-27 at 22:26 +0000, Ben Hutchings wrote:
> I don't think so.  This doesn't find anything:
>     git grep '&[ (]*pci_resource_start'
> and I was able to build drivers/{net,pci,scsi}/ successfully with
> pci_resource_start() changed to an inline function.

Hi again Ben.  You're right.

It could be nice though to have some mechanism to get from
a pci_resource_start/end that could be emitted via %pa
without an intermediate or casting like
(unsigned long long)pci_resource_<foo>(struct resource *)

There are at least a few dozen uses of dmesg/seq_printf with
%llx or %lx and (some_cast)pci_resource_<foo> that could be
converted.
