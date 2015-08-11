From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH REPOST libibverbs] Add IP and TCP/UDP TX checksum offload support
Date: Tue, 11 Aug 2015 11:39:52 +0300
Message-ID: <CAJ3xEMjJJHDM2+avpG0uTUEEqbUDX6gu=cd4-ijit8RCJ4CYZg@mail.gmail.com>
References: <1434276784-15909-1-git-send-email-ogerlitz@mellanox.com>
	<20150618163842.GA14348@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150618163842.GA14348-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 18, 2015 at 7:38 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Sun, Jun 14, 2015 at 01:13:04PM +0300, Or Gerlitz wrote:
>> From: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Add a device capability flag IB_DEVICE_IP_SUM to denote checksum offload
>> support. Devices should set this flag if they support insertion of IP, TCP
>> and UDP checksums on outgoing IP packets sent over IB UD or ETH RAW_PACKET QPs.
>
> It would be really nice to see the man page discuss exactly what is
> done here, there are quite a few different options for checksum.
>
> IPoIB maps this to 'NETIF_F_IP_CSUM', so only UDP/TCP checksum in
> IPv4.
>
> What value should be placed in the checksum header(s) prior to issuing
> the send? It looks like IPoIB uses the CHECKSUM_PARTIAL protocol ?

yes, we can follow here on how IPoIB uses this device capability. In that case,
AFAIK and from quick look on the TX section for CHECKSUM_PARTIAL in
include/linux/skbuff.h --
nothing special is assumed to be placed in the checksum field at the
header/s prior to issuing the send, agree?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
