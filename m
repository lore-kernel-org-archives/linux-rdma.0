From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 00/29] Add SRIOV support for IB interfaces
Date: Sun, 17 Jun 2012 17:39:18 +0300
Message-ID: <4FDDEC16.9060702@mellanox.com>
References: <9e8965c740ff0e889a097a722b9fff90.squirrel@webmail.ocsa-data.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9e8965c740ff0e889a097a722b9fff90.squirrel-2RFepEojUI2lDZmfZ6uX/xeHL2rgt/dS@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/14/2012 4:21 PM, Yann Droneaud wrote:
> How will interact vHCA/HCA regarding Automatic Path Migration (APM) 
> and IPoIB bonding with fail-over (HA), with RDMA_CM and IP usages in 
> mind ?

work on vHCA the same way they do on HCA, please let me know if you have 
anything more special to realize

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
