From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] IPoIB to Ethernet routing performance
Date: Thu, 9 Dec 2010 17:46:03 -0600 (CST)
Message-ID: <alpine.DEB.2.00.1012091745070.29367@router.home>
References: <20101206112454.76bb85f1@frecb012350.frec.bull.fr> <00d701cb9533$71c5f2e0$5551d8a0$@com> <20101206124023.025c2f88@frecb012350.frec.bull.fr> <00f201cb953e$53f66a00$fbe33e00$@com> <20101206140505.20cfc9e2@frecb012350.frec.bull.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101206140505.20cfc9e2-xRPE6/W2vR9iM9LT7/dT9zWMkbuR3peG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Cc: Richard Croucher <richard-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'OF EWG' <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 6 Dec 2010, sebastien dugue wrote:

> > The Mellanox BridgeX looks a better hardware solution with 12x 10Ge
> > ports but when I tested this they could only provide vNIC
> > functionality and would not commit to adding IPoIB gateway on their
> > roadmap.
>
>   Right, we did some evaluation on it and this was really a show stopper.

Did the same thing here came to the same conclusions.

> > Qlogic also offer the 12400 Gateway.  This has 6x 10ge ports.
> > However, like the Mellanox, I understand they only provide host vNIC
> > support.

Really? I was hoping that they would have something worth looking at.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
