From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 1/7] libibumad: Provide MAD definitions with libibumad
Date: Wed, 20 Feb 2013 09:42:19 -0800
Message-ID: <20130220094219.19f80f5c0b65c50a48b29c96@llnl.gov>
References: <1359409135-559-1-git-send-email-sean.hefty@intel.com>
	<5124F212.2060503@dev.mellanox.co.il>
	<1828884A29C6694DAF28B7E6B8A823736F34E958@ORSMSX101.amr.corp.intel.com>
	<1828884A29C6694DAF28B7E6B8A823736F34E976@ORSMSX101.amr.corp.intel.com>
	<5124FC59.2070602@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5124FC59.2070602-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 20 Feb 2013 11:39:53 -0500
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 2/20/2013 11:29 AM, Hefty, Sean wrote:
> >> I need to check the kernel code, but I believe that the RMPP header is exposed.
> > 
> > I looked at copy_recv_mad(), and it copies the entire 256-byte MAD to user space, which includes any RMPP header, followed by any additional segmented data.  So most of the RMPP definitions are relevant, the exceptions possibly being UMAD_RMPP_TYPE_[ACK | STOP | ABORT].  IMO - I would keep those for completeness.
> 
> Yes but how much of header is relevant when it's a multipacket RMPP MAD
> message ? My concern is that it may be confusing as to validity/use of
> certain RMPP fields, etc.
> 

IMO the confusion can be overcome by documenting that fact that libibumad coalesces the multipacket RMPP response into one buffer returned by umad_recv as well as how it is done.  This is where the confusion lies.

If you do accept the RMPP defines I have a subsequent patch for the *_str functions for them.

Ira

> -- Hal
> 
> > - Sean
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
