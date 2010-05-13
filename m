From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] [PATCHv8 02/11] ib_core: IBoE support only QP1
Date: Thu, 13 May 2010 10:35:14 -0700
Message-ID: <adahbmbso19.fsf@roland-alpha.cisco.com>
References: <20100218172344.GC12286@mtls03>
	<ada632svqph.fsf@roland-alpha.cisco.com>
	<20100513065917.GA16073@mtldesk030.lab.mtl.com>
	<adatyqbsszt.fsf@roland-alpha.cisco.com>
	<20100513165201.GA19438@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100513165201.GA19438-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org> (Eli Cohen's
	message of "Thu, 13 May 2010 19:52:01 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > One reason is that get_src_path_mask() may access ah_lock.

I don't see that:

static u8 get_src_path_mask(struct ib_device *device, u8 port_num)
{
	struct ib_sa_device *sa_dev;
	struct ib_sa_port   *port;
	unsigned long flags;
	u8 src_path_mask;

	sa_dev = ib_get_client_data(device, &sa_client);
	if (!sa_dev)
		return 0x7f;

so if we never add the sa_client structure it just returns.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
