From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: ib_types.h moving [was: Re: [ofa-general] [RFC] 3/5: IB ACM:
 libibacm]
Date: Fri, 25 Sep 2009 16:09:08 +0300
Message-ID: <20090925130908.GD26931@me>
References: <EED935897ACB4DC784DFAB4184A5DC6F@amr.corp.intel.com>
 <FCF6CB1AB515463BAB014EB7BB084FDA@amr.corp.intel.com>
 <20090917101804.12e9e5ce.weiny2@llnl.gov>
 <FD141AAD0F10420B9D0478DB68C9DEDA@amr.corp.intel.com>
 <20090917132050.041b077d.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090917132050.041b077d.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13:20 Thu 17 Sep     , Ira Weiny wrote:
> 
> Sasha, would you be willing to accept such a patch?  First move ib_types.h to umad and then move the long inline functions into the lib and separate out the remaining header.
> 
> Or would you prefer a new library?  I think there is enough code there but I leave it up to you.

Basically cleaning ib_types.h issue (which was raised repeatedly in the
past too) and making some order here with libibmad duplications would be
a nice thing.

However I still not understand clearly yet how things should be
organized properly (assumig all histories, ibutils dependencies, etc.).
And sure we can try to find an optimal model, so let's discuss:

libibumad is an option. However today this library only provides a
layer to user_mad kernel API and actually is transparent to MAD's
structure. Maybe complicating this with adding ib_types.h and some MAD
fields access helpers is not a big deal, but sort of disadvantage
anyway.

To place this stuff in separate library/package is another possibility,
but perspective of adding new package doesn't make me happy.

In theory ib_types.h would be also merged with libibmad. However for
me the current libibmad seems to be too much heavy for not using it for
stuff other than infiniband-diags.

Another options?

Now I likely would agree with Ira that moving ib_types.h to libibumad
is a least painful option. Do we have a better ideas?

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
