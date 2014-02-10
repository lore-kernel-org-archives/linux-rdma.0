From: "Davis, Arlin R" <arlin.r.davis@intel.com>
Subject: Re: [PATCH 1/4] NULL undeclared on Fedora
Date: Mon, 10 Feb 2014 19:14:10 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F972DEC88A@ORSMSX101.amr.corp.intel.com>
References: <54347E5A035A054EAE9D05927FB467F972DEC731@ORSMSX101.amr.corp.intel.com>
	<1392033167.11170.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <1392033167.11170.22.camel@localhost.localdomain>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

> > --- a/dat/include/dat2/dat_platform_specific.h
> > +++ b/dat/include/dat2/dat_platform_specific.h
> > @@ -147,6 +147,7 @@ typedef DAT_UINT64		DAT_PADDR;
> >  #if defined(__KERNEL__)
> >  #include <linux/types.h>
> >  #else
> > +#include <stdio.h>
> 
> You could use #include <stddef.h> if only NULL is needed
> http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/stddef.h.html

There was an issue with Fedora where linux/stddef.h is empty. Looks like
I need to clean this up and use <stddef.h> instead of <linux/stddef.h> 
for the non-kernel build.

Thanks.
