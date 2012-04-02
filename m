From: "Heinz, Michael William" <michael.william.heinz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] Proposal to change Node Description naming scheme for
 HCA's
Date: Mon, 2 Apr 2012 18:52:53 +0000
Message-ID: <F93D748CDCC46C42B498F40A38D903696411EF@FMSMSX107.amr.corp.intel.com>
References: <20120330173908.0abdd264.weiny2@llnl.gov>
 <F93D748CDCC46C42B498F40A38D90369641004@FMSMSX107.amr.corp.intel.com>
 <20120402184545.GA1311@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120402184545.GA1311-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'd agree but the network up/down functionality tends to vary significantly from distro to distro. There's also the question of "what package would we add this functionality to?" I mean, I assume it wouldn't be part of ofa_kernel. Might actually be the installer script that has to patch the DHCP chain.

-----Original Message-----
From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org] 
Sent: Monday, April 02, 2012 2:46 PM
To: Heinz, Michael William
Cc: Ira Weiny; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Doug Ledford; Bob Ciotti; James Silva
Subject: Re: [RFC] Proposal to change Node Description naming scheme for HCA's

On Mon, Apr 02, 2012 at 03:27:35PM +0000, Heinz, Michael William wrote:

> Any ideas on how we could solve the hostname problem while we're 
> changing the description?

The node description needs to be set from the DCHP notifier script chain (eg /etc/network/if-up.d/ on Debian) and also from a udev rule triggered on device insertion.

It should probably not be set from the openibd script..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
