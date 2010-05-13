From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv8 07/11] ib_core: Add API to support IBoE from userspace
Date: Thu, 13 May 2010 19:54:47 +0300
Message-ID: <20100513165447.GB19438@mtldesk030.lab.mtl.com>
References: <20100218172425.GH12286@mtls03>
	<adak4r8uaog.fsf@roland-alpha.cisco.com>
	<20100513135645.GL16073@mtldesk030.lab.mtl.com>
	<8172EB57F9DF4F93BBFAD583235E8C3F@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8172EB57F9DF4F93BBFAD583235E8C3F-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 13, 2010 at 08:55:13AM -0700, Sean Hefty wrote:
> >
> >Interesting idea. Not sure what is better here: a seperate ABI
> >call or some additional 'u8 ctx[32]' field in struct
> >ib_uverbs_create_ah_resp that will be interpreted by the hw-specific
> >user-space driver.
> 
> I don't understand why mapping remote addresses should be driver specific.

In this case it will not be just mapping remote addresses but creating
the required AH information which is unique to each device.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
