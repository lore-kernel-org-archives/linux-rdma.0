From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Wed, 20 May 2015 11:37:18 -0600
Message-ID: <20150520173718.GC28496@obsidianresearch.com>
References: <1431869786-6308-1-git-send-email-ogerlitz@mellanox.com>
 <1431869786-6308-10-git-send-email-ogerlitz@mellanox.com>
 <20150519185801.GM18675@obsidianresearch.com>
 <20150519190031.GN18675@obsidianresearch.com>
 <CAJ3xEMiO2y6G5YzzkGC1M=XB6yrtNJ7jj13pTUAee1TssiYwkQ@mail.gmail.com>
 <20150519191553.GP18675@obsidianresearch.com>
 <CAJ3xEMjj31SpZmYXORCePVCQfMOWVKEhtNay-v59FcnCOQWm9w@mail.gmail.com>
 <20150520002915.GD16941@obsidianresearch.com>
 <555C9D00.2090609@mellanox.com>
 <1432134677.5304.23.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432134677.5304.23.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 20, 2015 at 05:11:17PM +0200, Yann Droneaud wrote:
> Hi,
>=20
> Le mercredi 20 mai 2015 =E0 17:41 +0300, Or Gerlitz a =E9crit :
> > On 5/20/2015 3:29 AM, Jason Gunthorpe wrote:
> > > On Tue, May 19, 2015 at 10:30:00PM +0300, Or Gerlitz wrote:
> > > > > Are you objecting adding the clock frequency and mask to the=20
> > > > > qeury device verb?
> > > > > why?
> > > Lets see the verbs side and I'll let you know.
> >=20
> > You mean the user series of libibverbs/libmlx4? I don't see why thi=
s=20
> > should be a must for the review of the kernel bits. The user-space=20
> > code=20
> > is coming up soon, sure, but we should be able to review kernel=20
> > patches=20
> > without requiring to actually see the user-space code.
> >=20
>=20
> In some other subsystems: no userspace code, no merge.
>=20
> http://blog.ffwll.ch/2015/05/gfx-kernel-upstreaming-requirements.html

I think we need to have the same policy.

Like for the time base related values, if the uapi is some kind of
'ibv_get_wc_timestamp_ns' call (which would make sense) then those are
actually vendor values and we don't need them in the public structure.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
