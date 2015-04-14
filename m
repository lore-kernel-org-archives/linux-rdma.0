From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Stepping down as maintainer (was Re: [PATCH for-next 0/9] mlx4
 changes in virtual GID management)
Date: Tue, 14 Apr 2015 14:32:48 +0300
Message-ID: <CAJ3xEMhYVJZETA=zoVP2CBBrZ_r9s09T-U1Rk3XQxakpOdiakg@mail.gmail.com>
References: <CAG4TOxPQX+hBiEcaWD7DOAeLEmi9bWMeE06to+QyCdo3pAU+Yw@mail.gmail.com>
	<CAJ3xEMiky+s55zsqH0Vxpw8wmk3uGsx1wyMdNqsFihCaiBDgtw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A82373A8FC07D4@ORSMSX109.amr.corp.intel.com>
	<20150413175330.GC17521@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150413175330.GC17521-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 13, 2015 at 8:53 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> As far as patches go, you keep asking for reviews, but where are the
> reviews from Mellanox? I count 45 @mellanox folks who contributed to
> the kernel, but I wouldn't have guessed that based on mailing
> list participation.

Jason,

Making things more precise... glasses have two halves, namely:

on the RDMA Storage side of things, Sagi Grimberg is doing tons of
rdma kernel work, besides being a  maintainer of both iSER target and
Initiator drivers AND top contributor to both, he reviews practically
every SRP patch sent to this list and many if not most of the NFS RDMA
patches sent here. This can be checked with Bart Van Assche and Chuck
Lever, see also [1]

on the IPoIB side of things, Erez Shitrit is reviewing the IPoIB
patches sent here. Specifically, he spent endless hours reviewing the
3-4 rounds of the fixes Doug sent in the last months, not only he
reviewed them, he took them into regression on our systems and showed
Doug again and again where things break, till the point where that
worked.

Hal Rosenstock is reviewing every patch which related to the MAD layer.

Haggai Eran, Matan Barak and Shachar Raindel interacted with Yann on
his comments and patches he sent to fix and enhance things around ODP
and uverbs extensions.

Jack Morgenstein, Eli Cohen and Amir Vadai constantly review patches
and address questions and issues raised by other parties for the
low-level mellanox drivers.

ETC, and I will not speak on myself, see for yourself where/when I
commented on patches sent by other members of this community.

> I see patches from Yann, Michael, Ira, and Yuval at least on the list
> that have seen general silence from your corner. That's just this last
> month or so.

Indeed, we can improve and some patch series didn't get enough review
from a @mellanox.com person, but by all means, the volume of back
reviews done here by mellanox folks goes way beyond what you describe.


> Look - the only way a subsystem can function properly is if all
> parties who want to continuously change the shared subystem core
> realise they have to contribute back review-hours and discussion
> leadership *AT LEAST* equal to what they receive.

Or.

[1] And all this is in parallel to his work @ the SCSI (previously MM
too) subsystem (SCSI target, iSCSI stack, Block MQ, etc) which enables
more indirect elements allowing for high performance RDMA storage to
shine.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
