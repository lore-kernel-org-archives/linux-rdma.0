From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ib_types.h moving [was: Re: [ofa-general] [RFC] 3/5: IB ACM: libibacm]
Date: Thu, 1 Oct 2009 15:56:37 -0700
Message-ID: <443C4473AAC343EB87025E4F88C36757@amr.corp.intel.com>
References: <EED935897ACB4DC784DFAB4184A5DC6F@amr.corp.intel.com>	<FCF6CB1AB515463BAB014EB7BB084FDA@amr.corp.intel.com>	<20090917101804.12e9e5ce.weiny2@llnl.gov>	<FD141AAD0F10420B9D0478DB68C9DEDA@amr.corp.intel.com>	<20090917132050.041b077d.weiny2@llnl.gov>	<20090925130908.GD26931@me>	<20090930183126.0011af7c.weiny2@llnl.gov>	<20091001025752.GA22310@obsidianresearch.com> <20091001155007.5bdf73f1.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091001155007.5bdf73f1.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Ira Weiny' <weiny2-i2BcT+NCU+M@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>One final thought.  Does WinOF use libibverbs as well?  Would moving ib_types
>functionality in to libibverbs be a problem for them?

Actually libibumad in WinOF uses libibverbs to get the device information.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
