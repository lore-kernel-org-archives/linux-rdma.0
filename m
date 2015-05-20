From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v4 for-next 04/14] IB/core: Add default GID for RoCE GID table
Date: Wed, 20 May 2015 19:09:35 +0300
Message-ID: <CAAKD3BC5tR8_u7E2bpN3FAXi=Ov7=gSKrf9q3Y9xaHAoiBZhQA@mail.gmail.com>
References: <1432045637-9090-1-git-send-email-matanb@mellanox.com>
	<1432045637-9090-5-git-send-email-matanb@mellanox.com>
	<20150519174159.GB18675@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150519174159.GB18675-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 19, 2015 at 8:41 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, May 19, 2015 at 05:27:07PM +0300, Matan Barak wrote:
>> When RoCE is used, a default GID address should be generated
>> for every supported RoCE type. These default GID addresses are
>> generated based on the IPv6 link-local address, but in contrast
>> to the GID based on the regular IPv6 link-local (as we generate
>> GID per IP address), these GIDs are also available if the net
>> device is down (in order to support loopback).
>> Moreover, these default GID addresses can't be deleted.
>
> That addrconf stuff needs to be in a dedicated patch

Ok, I'll split this patch.
Thanks for taking a look at this patch.

Matan

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
