From: "Yann Droneaud" <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 00/29] Add SRIOV support for IB interfaces
Date: Thu, 14 Jun 2012 15:21:37 +0200
Message-ID: <9e8965c740ff0e889a097a722b9fff90.squirrel@webmail.ocsa-data.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

> This patch set adds SRIOV support for IB interfaces.
> Patches 1-13 are "precondition" patches.
> Patches 14-29 actually implement the feature.
> This patch set introduces Infiniband SRIOV support for ConnectX2 and
ConnectX3
> devices.  Each function presents itself as an independent vHCA (virtual
HCA) to
> the host while a single HCA is observable by the network, which is
unaware
> of
> the vHCAs.  No changes are required by the IB subsystem, ULPs, and apps
to
> support SRIOV, and vHCAs are interoperable with any existing
> (non-virtualized)
> IB deployments.

Please forgive me, I haven't tried the patches or go deeper in reading them.

How will interact vHCA/HCA regarding Automatic Path Migration (APM) and
IPoIB bonding with fail-over (HA), with RDMA_CM and IP usages in mind ?

Regards.

-- 
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
