From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ib_types.h moving
Date: Fri, 2 Oct 2009 09:56:22 -0700
Message-ID: <FB1B0AC05BE24B3892604089AAB3C706@amr.corp.intel.com>
References: <EED935897ACB4DC784DFAB4184A5DC6F@amr.corp.intel.com>	<FCF6CB1AB515463BAB014EB7BB084FDA@amr.corp.intel.com>	<20090917101804.12e9e5ce.weiny2@llnl.gov>	<FD141AAD0F10420B9D0478DB68C9DEDA@amr.corp.intel.com>	<20090917132050.041b077d.weiny2@llnl.gov>	<20090925130908.GD26931@me>	<20090930183126.0011af7c.weiny2@llnl.gov>	<376DB0F1C4874D9388729D1367F54C23@amr.corp.intel.com> <20091001173841.9ef6bca2.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091001173841.9ef6bca2.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Ira Weiny' <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

><sigh> yes this discussion has digressed.  But I don't think we should dive
>into breaking up (or moving) ib_types just to move things around.  I think
>Sasha is right we need to have a plan for where things _should_ end up.  As I
>look for homes for all the items of ib_types I find that it is not just one
>place.  :-/

I really don't think it's worth the effort to rework IB libraries and MAD
layers.  Most user space applications need simpler interfaces to use than
communicating directly with the IB SA.  For the few that want or need to, the
existing libraries are sufficient.  We only need a better place for some of the
structure definitions than an opensm header file.  Even the ib-diags shouldn't
depend on opensm.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
