From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Wed, 20 May 2015 17:11:17 +0200
Message-ID: <1432134677.5304.23.camel@opteya.com>
References: <1431869786-6308-1-git-send-email-ogerlitz@mellanox.com>
	 <1431869786-6308-10-git-send-email-ogerlitz@mellanox.com>
	 <20150519185801.GM18675@obsidianresearch.com>
	 <20150519190031.GN18675@obsidianresearch.com>
	 <CAJ3xEMiO2y6G5YzzkGC1M=XB6yrtNJ7jj13pTUAee1TssiYwkQ@mail.gmail.com>
	 <20150519191553.GP18675@obsidianresearch.com>
	 <CAJ3xEMjj31SpZmYXORCePVCQfMOWVKEhtNay-v59FcnCOQWm9w@mail.gmail.com>
	 <20150520002915.GD16941@obsidianresearch.com>
	 <555C9D00.2090609@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <555C9D00.2090609-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mercredi 20 mai 2015 =C3=A0 17:41 +0300, Or Gerlitz a =C3=A9crit :
> On 5/20/2015 3:29 AM, Jason Gunthorpe wrote:
> > On Tue, May 19, 2015 at 10:30:00PM +0300, Or Gerlitz wrote:
> > > > Are you objecting adding the clock frequency and mask to the=20
> > > > qeury device verb?
> > > > why?
> > Lets see the verbs side and I'll let you know.
>=20
> You mean the user series of libibverbs/libmlx4? I don't see why this=20
> should be a must for the review of the kernel bits. The user-space=20
> code=20
> is coming up soon, sure, but we should be able to review kernel=20
> patches=20
> without requiring to actually see the user-space code.
>=20

In some other subsystems: no userspace code, no merge.

http://blog.ffwll.ch/2015/05/gfx-kernel-upstreaming-requirements.html


> As the change-logs here explained, the clock frequency is needed for=20
> applications to convert the HCA clock delta (current time - timestamp=
=20
> on=20
> WC) into nano-secs and such.The mask is needed to realize how many=20
> bits
> from the 64b time-stamp are supported by the HW.
>=20
> >=20
> > > > If not, are objecting using the vendor specific track of the=20
> > > > verb to
> > > > pass from the vendor driver to the vendor library this or that=20
> > > > detail
> > > > which is needed for proper operation? why?
> > I'm uncomfortable seeing otherwise vendor-neutral calls gain vendor
> > extensions.
>=20
> But this is whole purpose of the udata framework in uverbs, right?=20
> for=20
> each uverb command the vendor user-space library has a well defined=20
> channel to communicate directly with the low level vendor driver=20
> throughout the uverbs channels.
>=20

Uverbs convey information between kernel and userspace drivers to
implement verbs for userspace application. I don't think it's designed
to allow vendor to add random extensions in the best way with regard to
backward/forward compability.


Anyway, please, we have to make drivers which are going to behave as
good citizens to the kernel *and* userspace. Adding a dedicated
extensions which is going to be replaced later by a generic, vendor
neutral, extension will be painful to maintain to ensure backward
compatibility.

So let's think how this timestamp extension can be made generic enough
to be future-proof (and at least present proof to address current use
cases).

Regards.

--=20
Yann Droneaud
OPTEYA



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
