From: Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: [Xen-devel] Re: [PATCH] infiniband/mthca : Fix userland mapping
 of mthca infiniband cards in Xen dom0
Date: Sun, 9 Jan 2011 10:24:02 +0200
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443D1C7B3EA5@MTLMAIL.mtl.com>
References: <1293034260.30522.426.camel@trax> <adamxnfdty8.fsf@cisco.com>
 <AANLkTi=zMiVJfTRDeYvbxT46b0iASKG9jPgXqG81bqAK@mail.gmail.com>
 <20110106165549.GC18774@dumpdata.com> <adalj2xdfw2.fsf@cisco.com>
 <20110107191559.GA27871@dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110107191559.GA27871-Z2dCqgVfyhJWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Vivien Bernet-Rollande <vbr-GKN1HSsW2S7R7s880joybQ@public.gmane.org>, Jeremy Fitzhardinge <jeremy-TSDbQ3PG+2Y@public.gmane.org>, "xen-devel-GuqFBffKawuULHF6PoxzQEEOCMrvLtNR@public.gmane.org" <xen-devel-GuqFBffKawuULHF6PoxzQEEOCMrvLtNR@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "rdreir-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rdreir-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We have no plans at present to test mthca on Xen. Our current Xen testing is focused on Connectx.

-Jack

-----Original Message-----
From: Konrad Rzeszutek Wilk [mailto:konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
Sent: Friday, January 07, 2011 9:16 PM
To: Roland Dreier
Cc: Vivien Bernet-Rollande; Jack Morgenstein; Jeremy Fitzhardinge; xen-devel-GuqFBffKawuULHF6PoxzQEEOCMrvLtNR@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; rdreir-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: Re: [Xen-devel] Re: [PATCH] infiniband/mthca : Fix userland mapping of mthca infiniband cards in Xen dom0

On Thu, Jan 06, 2011 at 10:51:57AM -0800, Roland Dreier wrote:
>  > There is another way, which I hope can fix this issue (it fixes
>  > the graphics drivers). Basically making the Xen MMU be aware of the E820
>  > and consider any access to PFNs that are not in RAM to have VM_IO implicitly set.
>  >
>  > The patches are at git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git
>  >
>  > stable/p2m-identity.v4.3
>  >
>  > And posted on LKML )https://lkml.org/lkml/2010/12/30/163)
>  >
>  > They _should_ take care of your problem as long as the PFNs you
>  > are mapping fall within the PCI BAR regions (which I would presume they
>  > do since you are using ioremap).
>
> Yes, that should work fine for all the cases I know of in the RDMA
> drivers.  We are just mapping some PCI BAR space into userspace for
> direct access to hardware (just like graphics, I think).

Allright, then it will work.

I've respun another version that fundamentally does the same thing
but accounts for  "what PFN is non-RAM" in a much cleaner way.

It is @:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/p2m-identity.v4.5

will post it soon on LKML.

Jack, Vivien: i you do merge it in your tree for testing with Xen and it works properly can
I attach your 'Tested-by' on the patch-set?

>
> I definitely prefer a solution that doesn't require driver authors to
> add a Xen-specific fix that isn't required on any other architecture.

Heh. You and me are on the same wavelength here.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
