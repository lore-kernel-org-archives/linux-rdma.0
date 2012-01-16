From: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/nes: Change for phy clock divisor
Date: Mon, 16 Jan 2012 21:07:45 +0000
Message-ID: <13AA599688F47243B14FCFCCC2C803BBA51E@FMSMSX108.amr.corp.intel.com>
References: <20111207222406.GA4012@TENIKOLO-MOBL>
 <CAG4TOxMjjT3+NJZFito656=O+cVDw_FXWAZ-vyjWsPF415+5vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxMjjT3+NJZFito656=O+cVDw_FXWAZ-vyjWsPF415+5vg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roland.dreier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <roland.dreier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Roland,

<roland.dreier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Any comment on why you want to change the bus clock?

By mistake I had sent the response to your question using your old email @kernel.org and you probably never got it.

In this patch, the clock divisor is increased, so that MDIO bus clock frequency is reduced from 3.5MHz to 2.5MHz. In this way, it complies with the standard maximum clock frequency 2.5MHz, defined in MDIO specs.

I have submitted a few more patches after this one. Could you please review and apply them?

Thank you.
Tatyana
  

-----Original Message-----
From: roland.dreier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org [mailto:roland.dreier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] On Behalf Of Roland Dreier
Sent: Wednesday, December 07, 2011 5:20 PM
To: Nikolova, Tatyana E
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH] RDMA/nes: Change for phy clock divisor

<Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Change the MDIO bus clock to frequency 2.5MHz

Any comment on why you want to change the bus clock?

------------------------------------------------------------------
On Wed, Dec 7, 2011 at 2:24 PM, Tatyana Nikolova
<Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

Change the MDIO bus clock to frequency 2.5MHz
 
Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 7c0ff19..6ee570b 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -1529,7 +1529,7 @@ int nes_init_phy(struct nes_device *nesdev)
 	} else {
 		/* setup 10G MDIO operation */
 		tx_config &= 0xFFFFFFE3;
-		tx_config |= 0x15;
+		tx_config |= 0x1D;
 	}
 	nes_write_indexed(nesdev, NES_IDX_MAC_TX_CONFIG, tx_config);
 
--
1.7.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
