From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core v1 3/3] travis: Test Debian packaging under
 artful container
Date: Sun, 5 Nov 2017 19:17:38 -0700
Message-ID: <20171106021737.GC26011@ziepe.ca>
References: <20171105144503.32709-1-leon@kernel.org>
 <20171105144503.32709-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171105144503.32709-4-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 05, 2017 at 04:45:02PM +0200, Leon Romanovsky wrote:

> -# Finally run through gcc-7 64 bit through the debian packaging This gives a
> -# good clue if patches are changing packaging related things, the RPM stuff
> -# will have to be audited by hand.
> -
> -# When running cmake through debian/rules it is hard to set -Werror,
> -# instead force it on by changing the CMakeLists.txt
> -cd ..
> -echo 'set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Werror")' >> buildlib/RDMA_EnableCStd.cmake

Loosing this stuff seems like a problem though. We need to make sure
the package builds run with -Werror or travis will not flag new
warnings.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
