From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 03/10] IB/core: Support accessing SA in
 virtualized environment
Date: Tue, 1 Mar 2016 23:15:09 +0200
Message-ID: <CAJ3xEMiZ5Z4=WzNNN7o5XqpaBL085YEM65-1T61PMNdDB8qSWw@mail.gmail.com>
References: <1456851143-138332-1-git-send-email-eli@mellanox.com>
	<1456851143-138332-4-git-send-email-eli@mellanox.com>
	<20160301174401.GC25176@obsidianresearch.com>
	<20160301181742.GB19366@x-vnc01.mtx.labs.mlnx>
	<20160301183256.GB12495@obsidianresearch.com>
	<20160301190742.GC19366@x-vnc01.mtx.labs.mlnx>
	<20160301193153.GA25755@obsidianresearch.com>
	<20160301194608.GF19366@x-vnc01.mtx.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160301194608.GF19366-lgQlq6cFzJSjLWYaRI30zHI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 1, 2016 at 9:46 PM, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Tue, Mar 01, 2016 at 12:31:53PM -0700, Jason Gunthorpe wrote:

>> I mean opensm supports the GUID Alias scheme for virtualization, this
>> new virtualization scheme is not compatible, and we shouldn't have the
>> kernel drop support for existing working SMs, by, eg, replacing the
>> mlx4 guid alias scheme with this new scheme.

[...]

> The alias GUID mechanism remains and can be used with mlx4 devices.
> With this scheme the admin configures the port and node GUIDs using
> iproute2 which ends up in the hardware driver configuring the device.

Indeed. The provisioning through standard means (rtnetlink, iproute2)
would work for both mlx4 (uses Alias GUIDs) and mlx5 (uses
vHCA/vGUIDs).

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
