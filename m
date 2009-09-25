From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ib_types.h moving [was: Re: [ofa-general] [RFC] 3/5: IB ACM: libibacm]
Date: Fri, 25 Sep 2009 10:19:15 -0700
Message-ID: <A91A32BB43ED4304A00317AD400A5BC1@amr.corp.intel.com>
References: <EED935897ACB4DC784DFAB4184A5DC6F@amr.corp.intel.com> <FCF6CB1AB515463BAB014EB7BB084FDA@amr.corp.intel.com> <20090917101804.12e9e5ce.weiny2@llnl.gov> <FD141AAD0F10420B9D0478DB68C9DEDA@amr.corp.intel.com> <20090917132050.041b077d.weiny2@llnl.gov> <20090925130908.GD26931@me>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090925130908.GD26931@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sasha Khapyorsky' <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Now I likely would agree with Ira that moving ib_types.h to libibumad
>is a least painful option. Do we have a better ideas?

Just a random thought, but what about longer term adding a second set of
interfaces to libibumad?  Basically, something more like the kernel ib_sa.  I
don't know that we need a new library just to expand the interface.

For ib_types.h, I'd rather see it broken up into separate header files, at least
some of which get distributed with libibumad.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
