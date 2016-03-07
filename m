From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 03/10] IB/core: Support accessing SA in
 virtualized environment
Date: Mon, 7 Mar 2016 09:52:23 +0200
Message-ID: <CAJ3xEMiRCt1FLHVt3i7V=c=w1EP50WfhA9ithA-8f8dafOjRfQ@mail.gmail.com>
References: <1456851143-138332-1-git-send-email-eli@mellanox.com>
	<1456851143-138332-4-git-send-email-eli@mellanox.com>
	<20160301174401.GC25176@obsidianresearch.com>
	<20160301181742.GB19366@x-vnc01.mtx.labs.mlnx>
	<20160301183256.GB12495@obsidianresearch.com>
	<20160301190742.GC19366@x-vnc01.mtx.labs.mlnx>
	<20160301193153.GA25755@obsidianresearch.com>
	<20160301194608.GF19366@x-vnc01.mtx.labs.mlnx>
	<56D99D8E.5020900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56D99D8E.5020900-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 4, 2016 at 4:37 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 03/01/2016 02:46 PM, Eli Cohen wrote:
>> On Tue, Mar 01, 2016 at 12:31:53PM -0700, Jason Gunthorpe wrote:
>>>
>>> I mean opensm supports the GUID Alias scheme for virtualization, this
>>> new virtualization scheme is not compatible, and we shouldn't have the
>>> kernel drop support for existing working SMs, by, eg, replacing the
>>> mlx4 guid alias scheme with this new scheme.
>>>
>>> I'm guessing a user controlled switch is going to be necessary here to
>>> pick GUID alias or port port virtualization.

>> The alias GUID mechanism remains and can be used with mlx4 devices.
>> With this scheme the admin configures the port and node GUIDs using
>> iprout2 which ends up in the hardware driver configuring the deivce. A
>> virtualization aware SM can read this configuration through MADs.

> If the alias GUID mechanism is to be retained, then we need another NDO
> entry point for setting P_Keys on alias GUID VFs.  If we are going to
> switch over to using iproute2, then the solution needs to be complete.

Doug, as you commented on the net/core patch, iproute2 et al can't be
really used today to build mlx4 based SRIOV cloud systems. This series
doesn't introduce regressions for the way mlx4 setups are made.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
