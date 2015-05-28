From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Thu, 28 May 2015 10:24:16 -0600
Message-ID: <20150528162416.GA6515@obsidianresearch.com>
References: <CAJ3xEMj5qphSq5QQHKPsihuK6StmJ+NHiPbkY-ZVGmpViB1AXA@mail.gmail.com>
 <20150526185315.GF11800@obsidianresearch.com>
 <CAJ3xEMh7JYN8sP5MYdVjH=tqPFURwvD7jVvV0=PBiEn1qEFi2A@mail.gmail.com>
 <20150526220724.GC4502@obsidianresearch.com>
 <CAJ3xEMgdqBnn6hobRJFut6Nyu2pKt40rb46Z3dYx3MaohR2urA@mail.gmail.com>
 <20150527184856.GA16059@obsidianresearch.com>
 <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com>
 <20150527222108.GA7855@obsidianresearch.com>
 <5566BDE4.50709@mellanox.com>
 <alpine.DEB.2.11.1505280908001.16142@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1505280908001.16142-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 28, 2015 at 09:13:41AM -0500, Christoph Lameter wrote:
> What we have to do without this is to use RDTSC to get a timestamp but the
> packet reception / sending time then is inaccurate due to the instructions that
> have to be executed before and after. And there is additional overhead due
> to that processing.

After a quick look through, the biggest question in my mind is what
should the timestamp value in the wc be?

Right now it is some coded thing in clock cycles.

Should we require the driver to convert to ns before passing the wc
back to the app? (Looks like the socket implementation uniformly uses
us or ns)

Should the app open code the conversion from clock cycles to ns, or
vfunc down to the driver?

Is the coding going to be OK for multiple HW vendors?

These questions effect what the UAPI should be, if the answer is 'use
ns everwhere' then some of this stuff being added does not belong in
the general API.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
