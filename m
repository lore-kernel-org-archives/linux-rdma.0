From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 02/13] IB/core: Find the network device matching
 connection parameters
Date: Tue, 28 Jul 2015 11:16:08 +0300
Message-ID: <55B73A48.7020103@mellanox.com>
References: <1437924832-18327-1-git-send-email-haggaie@mellanox.com>
 <1437924832-18327-3-git-send-email-haggaie@mellanox.com>
 <20150727174522.GF18348@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150727174522.GF18348-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yotam Kenneth <yotamke-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 27/07/2015 20:45, Jason Gunthorpe wrote:
> On Sun, Jul 26, 2015 at 06:33:41PM +0300, Haggai Eran wrote:
>> From: Yotam Kenneth <yotamke-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> In the case of IPoIB, and maybe in other cases, the network device is
>> managed by an upper-layer protocol (ULP). In order to expose this
>> network device to other users of the IB device, let ULPs implement
>> a callback that returns network device according to connection parameters.
>>
>> The IB device and port, together with the P_Key and the GID should
>> be enough to uniquely identify the ULP net device. However, in current
>> kernels there can be multiple IPoIB interfaces created with the same GID.
>> Furthermore, such configuration may be desireable to support ipvlan-like
>> configurations for RDMA CM with IPoIB.  To resolve the device in these
>> cases the code will also take the IP address as an additional input.
> 
> I already sent this, but again:
> 
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Thanks. I only removed it because the patch had some changes related to
the locking scheme, and I wasn't sure you would approve them.

Thanks anyway,
Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
