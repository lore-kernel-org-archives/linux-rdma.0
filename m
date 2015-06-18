From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH RFC] IB: Add rdma_cap_ib_switch helper and use where
 appropriate
Date: Thu, 18 Jun 2015 21:36:45 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E1109F6B2@CRSMSX101.amr.corp.intel.com>
References: <55832793.1080105@dev.mellanox.co.il>
 <20150618202519.GA17737@obsidianresearch.com>
 <55832A0D.3070809@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55832A0D.3070809-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On 6/18/2015 4:25 PM, Jason Gunthorpe wrote:
> > Ira had patch that made some functions related to this public, not
> > sure if it is applied yet..
> 
> Which patch from Ira are you referring to ?

This patch which is in  Dougs for 4.2 tree:


commit ca0369e31d1794a4f4e39c52fe39b0406617e2b4
Author: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Wed May 13 20:02:55 2015 -0400

    IB/core: Create common start/end port functions
    
    Previously start_port and end_port were defined in 2 places, cache.c and
    device.c and this prevented their use in other modules.
    
    Make these common functions, change the name to reflect the rdma
    name space, and update existing users.
    
    Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
