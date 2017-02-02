From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: qedr and vmw_pvrdma are not packaged in rdma-core
Date: Thu, 02 Feb 2017 10:17:56 +0100
Message-ID: <1486027076.4257.30.camel@profitbricks.com>
References: <20170202062628.GZ6005@mtr-leonro.local>
         <20170202081311.GA10429@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170202081311.GA10429-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ram Amrani <ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Am Donnerstag, den 02.02.2017, 00:13 -0800 schrieb Christoph Hellwig:
> On Thu, Feb 02, 2017 at 08:26:28AM +0200, Leon Romanovsky wrote:
> > Hi Ram and Adit,
> > 
> > I want to bring to your attention that qedr and vmw_pvrdma drivers
> > are
> > missing from various package files available in rdma-core.
> > 
> > Can you please send the patches which add your drivers to rdma-core
> > packages (Redhat and Debian)?
> 
> Even better: can we find a way so that providers (old and new) get
> added automatically?

debian/ibverbs-providers.install specifies:
usr/lib/*/libibverbs/lib*-rdmav2.so

So if CMake installs the provider, the package will automatically pick
it up.

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
