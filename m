From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 03/10] IB/core: Support accessing SA in
 virtualized environment
Date: Tue, 1 Mar 2016 21:46:08 +0200
Message-ID: <20160301194608.GF19366@x-vnc01.mtx.labs.mlnx>
References: <1456851143-138332-1-git-send-email-eli@mellanox.com>
 <1456851143-138332-4-git-send-email-eli@mellanox.com>
 <20160301174401.GC25176@obsidianresearch.com>
 <20160301181742.GB19366@x-vnc01.mtx.labs.mlnx>
 <20160301183256.GB12495@obsidianresearch.com>
 <20160301190742.GC19366@x-vnc01.mtx.labs.mlnx>
 <20160301193153.GA25755@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160301193153.GA25755-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 01, 2016 at 12:31:53PM -0700, Jason Gunthorpe wrote:
> 
> I mean opensm supports the GUID Alias scheme for virtualization, this
> new virtualization scheme is not compatible, and we shouldn't have the
> kernel drop support for existing working SMs, by, eg, replacing the
> mlx4 guid alias scheme with this new scheme.
> 
> I'm guessing a user controlled switch is going to be necessary here to
> pick GUID alias or port port virtualization.
> 

The alias GUID mechanism remains and can be used with mlx4 devices.
With this scheme the admin configures the port and node GUIDs using
iprout2 which ends up in the hardware driver configuring the deivce. A
virtualization aware SM can read this configuration through MADs.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
