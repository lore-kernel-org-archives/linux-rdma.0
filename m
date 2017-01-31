From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: rdma-core 12 breaks libibverbs ABI
Date: Tue, 31 Jan 2017 13:23:03 +0100
Message-ID: <1485865383.4257.10.camel@profitbricks.com>
References: <1485446147.4194.4.camel@profitbricks.com>
         <20170126171325.GA16562@obsidianresearch.com>
         <20170126173548.GA15006@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170126173548.GA15006-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Am Donnerstag, den 26.01.2017, 09:35 -0800 schrieb Christoph Hellwig:
> On Thu, Jan 26, 2017 at 10:13:25AM -0700, Jason Gunthorpe wrote:
> > I missed asking for this when the ibv_cmd_create_ah@IBVERBS_1.4
> > patch
> > was merged, but before we release 13 we need to drop all the
> > ibv_cmd_*
> > entry points from the public headers so that nothing outside rdma-
> > core
> > can link to these symbols.
> 
> A good thing would be to move all these symbols into a
> @IBVERBS_PRIVATE
> namespace, similar to what glibc does for it's internal library only
> exports.

I am fine with moving the private symbols into a IBVERBS_PRIVATE_XX
namespace as long as all consumers of the private symbols are build
from the rdma-core source package. I need to check if there is a
package in Debian that uses the private symbols.

So either go forward (extra namespace for private symbols) or revert
the ABI breakage (for the time being). The discussion on this list seem
to prefer the first option.

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL:  http://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Geschäftsführer: Andreas Gauger, Achim Weiss.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
