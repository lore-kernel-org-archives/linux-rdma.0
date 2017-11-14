From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: rdma-core_15-1_amd64.changes ACCEPTED into unstable
Date: Tue, 14 Nov 2017 19:58:43 +0100
Message-ID: <1510685923.4026.41.camel@profitbricks.com>
References: <E1eENiD-000EaM-BG@fasolo.debian.org>
         <20171114023711.GA22633@ziepe.ca> <20171114072056.GP18825@mtr-leonro.local>
         <1510656661.4026.23.camel@profitbricks.com>
         <20171114184719.GC4263@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114184719.GC4263-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Am Dienstag, den 14.11.2017, 11:47 -0700 schrieb Jason Gunthorpe:
> On Tue, Nov 14, 2017 at 11:51:01AM +0100, Benjamin Drung wrote:
> 
> > * Non-Linux architectures: One package is marked as architechture
> > "any"
> > instead of "linux-any". Thus the builds are tried on non-Linux
> > archs.
> > Expect a patch to come.
> 
> Yep
> 
> > * Architecture NOT able to do coherent DMA: Some providers will be
> > disabled and the install target fail to install the missing
> > providers.
> 
> I'm surprised, can you point me at a build log? I belive the cmake
> side should work?

Here is the build overview:
https://buildd.debian.org/status/package.php?p=rdma-core
The individual build logs are referenced from there.

There is already a Debian bug report for it:
https://bugs.debian.org/881731

You might want to answer to that report.

> I suppose we have a bit of a Debian problem here as things like
> mlx5dv will not compile on certain arches but their outputs are
> directly refenced in the debian/*.install files.. Do you know how to
> handle that?

There is no elegant way to handle that. The most elegant way I can come
up with is:

1) Have two install files debian/foo.install.full and
debian/foo.install.no-coherent-dma

2) Determine the build architecture in debian/rules and set
VARIANT=full or VARIANT=no-coherent-dma depending on the architecture.

3) Extent dh_auto_configure:

    cp debian/foo.install.$(VARIANT) debian/foo.install

4) Do the clean in dh_auto_clean:

    rm -f debian/foo.install

Any better idea?

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Geschäftsführer: Achim Weiss, Matthias Steinberg
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
