From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-3.11 2/3] rdma/cm: Fix accessing invalid private
 data for UD
Date: Thu, 1 Aug 2013 05:46:54 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA214E@ORSMSX109.amr.corp.intel.com>
References: <1374703569-16668-1-git-send-email-sean.hefty@intel.com>
 <1374703569-16668-3-git-send-email-sean.hefty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374703569-16668-3-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> If a application is using AF_IB with a UD QP, but does not
> provide any private data, we will end up accessing invalid
> memory.  Check for this case and handle it appropriately.
> 
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Roland, hold off on this patch, but please push the other 2 for 3-11.

After looking at this patch again, it doesn't end up doing much more than introducing a stack variable as an alias for the private data.  The problem I was trying to fix (conn_param->private_data_len too small) shouldn't result in a crash.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
