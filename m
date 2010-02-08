From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ewg] bug 1918 - openmpi broken due to rdma-cm changes
Date: Sun, 7 Feb 2010 21:27:05 -0800
Message-ID: <FAF48CEDFDC74A12A8DEA8B39FFC9E60@amr.corp.intel.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com>	<0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com>	<4B6C498F.3060708@opengridcomputing.com>	<38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com>	<4B6D9948.6040007@opengridcomputing.com>	<B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com>	<4B6E15C4.9020703@opengridcomputing.com>	<4B6EAA5F.1000208@mellanox.co.il>	<4B6EECBE.6020509@opengridcomputing.com> <ada4oltxa8j.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada4oltxa8j.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>Can you identify the source of the regression?  ie what was the change
>that broke things?

My understanding is that support for loopback addresses exposes an existing bug
in openmpi.  It tries to bind to 127.0.0.1, which now succeeds.  Openmpi passes
that address to a remote node for use in connections.

>I'm most concerned that there is another regression in 2.6.33, and if so
>I would like to try and avoid letting that get into the final release.

Unless we never support loopback addresses, openmpi will see a regression.  The
only other problem that I'm aware of for 2.6.33 is that the bind to a loopback
address will succeed, even though the RDMA device may not support loopback.
This is true for the Chelsio and Ammasso drivers.  Connections should still
fail, but the bind is basically useless in this case.  I will try to get a patch
for that tomorrow.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
