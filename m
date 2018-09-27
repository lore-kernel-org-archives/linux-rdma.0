From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] RDMA/qedr: Explicitly cast pkt->tx_dest to qed_ll2_tx_dest
Date: Thu, 27 Sep 2018 13:41:30 -0700
Message-ID: <CAKwvOdkueN6WrQgo9L4BVgDojUNH6v0HC6TE9S7n_dfOt9DvYA@mail.gmail.com>
References: <20180927011820.13608-1-natechancellor@gmail.com>
 <CAKwvOd=Oe1AAbQKcR+6K7LtZGne+-=3zREs_xVMnEbXBZJDJTQ@mail.gmail.com> <20180927203500.GA12450@flashbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927203500.GA12450@flashbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Michal.Kalderon@cavium.com, Ariel.Elior@cavium.com, dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 27, 2018 at 1:35 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Thu, Sep 27, 2018 at 01:28:12PM -0700, Nick Desaulniers wrote:
> > On Wed, Sep 26, 2018 at 6:18 PM Nathan Chancellor
> > <natechancellor@gmail.com> wrote:
> > >
> > > Clang warns when one enumerated type is explicitly converted to another.
> > >
> > > drivers/infiniband/hw/qedr/qedr_roce_cm.c:198:28: warning: implicit
> > > conversion from enumeration type 'enum qed_roce_ll2_tx_dest' to
> > > different enumeration type 'enum qed_ll2_tx_dest' [-Wenum-conversion]
> > >         ll2_tx_pkt.tx_dest = pkt->tx_dest;
> > >                            ~ ~~~~~^~~~~~~
> > > 1 warning generated.
> > >
> > > Avoid this warning by explicitly casting pkt->tx_dest to
> > > qed_112_tx_dest, which has the expected values from the
> > > type qed_roce_ll2_tx_dest.
> >
> > But these enums are different lengths, which is problematic for this
> > patch.  Is this code broken, or that it's ok for ll2_tx_pkt.tx_dest to
> > have a value that's not a valid enumeration value for enum
> > qed_ll2_tx_dest? (QED_LL2_TX_DEST_MAX 's value (3) is outside the
> > enumeration values of enum qed_roce_ll2_tx_dest).
> >
> > include/linux/qed/qed_rdma_if.h:
> >  42 enum qed_roce_ll2_tx_dest {
> >  43         /* Light L2 TX Destination to the Network */
> >  44         QED_ROCE_LL2_TX_DEST_NW,
> >  45
> >  46         /* Light L2 TX Destination to the Loopback */
> >  47         QED_ROCE_LL2_TX_DEST_LB,
> >  48         QED_ROCE_LL2_TX_DEST_MAX
> >  49 };
> >
> > include/linux/qed/qed_ll2_if.h:
> >  64 enum qed_ll2_tx_dest {
> >  65         QED_LL2_TX_DEST_NW, /* Light L2 TX Destination to the
> > Network */
> >  66         QED_LL2_TX_DEST_LB, /* Light L2 TX Destination to the
> > Loopback */
> >  67         QED_LL2_TX_DEST_DROP, /* Light L2 Drop the TX packet */
> >  68         QED_LL2_TX_DEST_MAX
> >  69 };
> >
> > Maybe the maintainers can clarify?
> >
>
> My assumption was that if QED_ROCE_LL2_TX_DEST_MAX was used that the
> packet would be dropped.
>
> Turns out that QED_ROCE_LL2_TX_DEST_MAX isn't actually used anywhere in
> the tree. I suppose that qed_roce_ll2_tx_dest could just be removed and
> all other instances of those values could be converted to
> qed_ll2_tx_dest like the rxe patch. I'll test this now and send a patch
> along if it works out.

Even better.  Sometimes removing code is the correct solution.  Number
of lines of code and number of bugs are positively correlated, so the
less code sometimes the better.

>
> Nathan
>
> > >
> > > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > > ---
> > >  drivers/infiniband/hw/qedr/qedr_roce_cm.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/infiniband/hw/qedr/qedr_roce_cm.c b/drivers/infiniband/hw/qedr/qedr_roce_cm.c
> > > index 85578887421b..147e0d69003d 100644
> > > --- a/drivers/infiniband/hw/qedr/qedr_roce_cm.c
> > > +++ b/drivers/infiniband/hw/qedr/qedr_roce_cm.c
> > > @@ -195,7 +195,7 @@ static int qedr_ll2_post_tx(struct qedr_dev *dev,
> > >
> > >         ll2_tx_pkt.num_of_bds = 1 /* hdr */  + pkt->n_seg;
> > >         ll2_tx_pkt.vlan = 0;
> > > -       ll2_tx_pkt.tx_dest = pkt->tx_dest;
> > > +       ll2_tx_pkt.tx_dest = (enum qed_ll2_tx_dest)pkt->tx_dest;
> > >         ll2_tx_pkt.qed_roce_flavor = roce_flavor;
> > >         ll2_tx_pkt.first_frag = pkt->header.baddr;
> > >         ll2_tx_pkt.first_frag_len = pkt->header.len;
> > > --
> > > 2.19.0
> > >
> >
> >
> > --
> > Thanks,
> > ~Nick Desaulniers



-- 
Thanks,
~Nick Desaulniers
