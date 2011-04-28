From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: infiniband-diags/perfquery.c: Use ib_types.h defines for CapabilityMask
Date: Thu, 28 Apr 2011 13:59:27 -0400
Message-ID: <4DB9AAFF.3090609@dev.mellanox.co.il>
References: <4DB97DF4.3020004@dev.mellanox.co.il>	<CF9C39F99A89134C9CF9C4CCB68B8DDF261A1F3A02@orsmsx501.amr.corp.intel.com>	<4DB995CE.8070203@dev.mellanox.co.il>	<CF9C39F99A89134C9CF9C4CCB68B8DDF261A1F3AB8@orsmsx501.amr.corp.intel.com> <20110428101456.8f9ac048.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110428101456.8f9ac048.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/28/2011 1:14 PM, Ira Weiny wrote:
> I would very much like the diags to not depend on opensm

It will take more than ib_types for this to happen. There are other
dependencies but maybe it's one step at a time...

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
