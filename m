From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 00/50] Add OPA gen1 driver
Date: Thu, 30 Jul 2015 17:52:38 -0400
Message-ID: <20150730215237.GA16736@phlsvsds.ph.intel.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com> <alpine.DEB.2.11.1507301535340.6551@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1507301535340.6551-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 03:37:24PM -0500, Christoph Lameter wrote:
> On Thu, 30 Jul 2015, Mike Marciniszyn wrote:
>=20
> > As a verbs driver the device functions as an InfiniBand device and
> > supports the standard features of the IBTA specification v1.3 with
> > the exceptions noted below.
>=20
> Hmmm... So OPA networks and IB networks (Truescale?) will be able to
> interoperate?

No, you can't plug an IB device into an OPA switch or a HFI into an IB =
switch.

The comment "As a verbs driver" means that we present the standard verb=
s
software interface to the core kernel and userspace.  This was to aid i=
n review
of the patch series and how it interacts with the rest of the infiniban=
d
subtree.

"Intel=E2=80=99s host software strategy is to utilize the existing Open=
=46abrics Alliance
interfaces, thus ensuring that today=E2=80=99s application software wri=
tten to those
interfaces run with Intel OPA with no code changes required."

	-- https://www-ssl.intel.com/content/www/us/en/high-performance-comput=
ing-fabrics/omni-path-fabric-software-components.html

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
