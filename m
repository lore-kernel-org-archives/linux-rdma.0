From: Alaa Hleihel <alaa-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core v1 3/3] travis: Test Debian packaging under
 artful container
Date: Mon, 6 Nov 2017 10:19:37 +0200
Message-ID: <68f08161-0ecf-17f7-f0fc-bc18b66fc4fa@dev.mellanox.co.il>
References: <20171105144503.32709-1-leon@kernel.org>
 <20171105144503.32709-4-leon@kernel.org> <20171106021737.GC26011@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171106021737.GC26011-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 06/11/2017 4:17, Jason Gunthorpe wrote:
> On Sun, Nov 05, 2017 at 04:45:02PM +0200, Leon Romanovsky wrote:
>
>> -# Finally run through gcc-7 64 bit through the debian packaging This gives a
>> -# good clue if patches are changing packaging related things, the RPM stuff
>> -# will have to be audited by hand.
>> -
>> -# When running cmake through debian/rules it is hard to set -Werror,
>> -# instead force it on by changing the CMakeLists.txt
>> -cd ..
>> -echo 'set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Werror")' >> buildlib/RDMA_EnableCStd.cmake
> Loosing this stuff seems like a problem though. We need to make sure
> the package builds run with -Werror or travis will not flag new
> warnings.

We still have compilation tests with -Werror in buildlib/travis-build (clang, 32 bit, arm, etc..).
If that is not enough, I think we can pass the -Werror to rpmbuild via CFLAGS environment variable:
CFLAGS="-Werror" rpmbuild ............

What do you think ?

Regards,
Alaa

> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
