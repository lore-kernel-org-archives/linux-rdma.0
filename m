From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [patch v2 21/37] add rxe_qp.c
Date: Mon, 15 Aug 2011 10:58:26 -0600
Message-ID: <20110815165826.GD12482@obsidianresearch.com>
References: <20110724194300.421253331@systemfabricworks.com>
 <20110724201229.163423781@systemfabricworks.com>
 <CAO+b5-opA-W4Lp69NzS=9MLEv1V7jWhHPo=bayKhaR-kPgTQTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAO+b5-opA-W4Lp69NzS=9MLEv1V7jWhHPo=bayKhaR-kPgTQTQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 15, 2011 at 06:13:57PM +0200, Bart Van Assche wrote:
> On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> > +char *rxe_qp_state_name[] = {
> > +	[QP_STATE_RESET]	= "RESET",
> > +	[QP_STATE_INIT]		= "INIT",
> > +	[QP_STATE_READY]	= "READY",
> > +	[QP_STATE_DRAIN]	= "DRAIN",
> > +	[QP_STATE_DRAINED]	= "DRAINED",
> > +	[QP_STATE_ERROR]	= "ERROR",
> > +};
> 
> Doesn't the compiler complain about assigning const char* to char* for
> the above array definition ? And since this array is only used in this
> source file, I think it can be declared static.

Best would be:

 static const char * const rxe_qp_state_name[]

To put as much as possible in .rodata.

Be sure to run size and nm on your .o files and check that the stuff
in .data actually needs to be writeable..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
