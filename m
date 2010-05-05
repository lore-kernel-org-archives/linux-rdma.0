From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4_core: request MSIX vectors as much as there CPU cores
Date: Wed, 05 May 2010 07:54:54 -0700
Message-ID: <adahbmmpfep.fsf@roland-alpha.cisco.com>
References: <20100505113047.GA12242@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100505113047.GA12242-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org> (Eli Cohen's
	message of "Wed, 5 May 2010 14:30:48 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > The current code requires num_possible_cpus() + 1 MSIX vectors. However,
 > num_possible_cpus() stands for the max number of supported CPUs by the kernel.

I believe this is wrong -- num_possible_cpus() is the maximum number of
CPUs for the running system, including hotplug.

 > We should use num_online_cpus() which is the number of available CPUs for the
 > system.

But then we don't have vectors for hotplugged CPUs.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
