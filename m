From: "Yann Droneaud" <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 00/29] Add SRIOV support for IB interfaces
Date: Mon, 18 Jun 2012 11:43:48 +0200
Message-ID: <08ad02e9d39157dc0bd5e959e2754ba8.squirrel@webmail.ocsa-data.net>
References: <9e8965c740ff0e889a097a722b9fff90.squirrel@webmail.ocsa-data.net>
    <4FDDEC16.9060702@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FDDEC16.9060702-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

> On 6/14/2012 4:21 PM, Yann Droneaud wrote:
>> How will interact vHCA/HCA regarding Automatic Path Migration (APM)
>> and IPoIB bonding with fail-over (HA), with RDMA_CM and IP usages in
>> mind ?
>
> work on vHCA the same way they do on HCA, please let me know if you have
> anything more special to realize
>

Nothing special.

As I was understanding the patches description, the SR-IOV virtualization
layer was acting like some kind of address translation (NAT) layer, so I
thought there could be some corner case, especially with fail-over.

Thanks for clarification.

Regards.

-- 
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
