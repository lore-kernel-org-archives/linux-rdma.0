From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v2 2/8] IB/core: Replace semaphore sm_sem with completion
Date: Tue, 25 Oct 2016 09:48:22 -0600
Message-ID: <20161025154822.GA27240@obsidianresearch.com>
References: <1477396919-27669-1-git-send-email-binoy.jayan@linaro.org>
 <1477396919-27669-3-git-send-email-binoy.jayan@linaro.org>
 <CAD+HZHXQE=VptiyLfSdw4MsZR=bjEj_XAB19_=YdjzPY96EK_g@mail.gmail.com>
 <CAHv-k_86z3MTYePPQcs5fWSqFeoGxt7UYG_b-SyZGQ7zVW-hSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHv-k_86z3MTYePPQcs5fWSqFeoGxt7UYG_b-SyZGQ7zVW-hSw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Jack Wang <xjtuwjp@gmail.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Arnd Bergmann <arnd@arndb.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Linux kernel mailing list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 25, 2016 at 08:38:21PM +0530, Binoy Jayan wrote:
> On 25 October 2016 at 18:13, Jack Wang <xjtuwjp@gmail.com> wrote:
> > Hi Binoy,
> >
> > snip
> >>
> >>         port->ib_dev   = device;
> >>         port->port_num = port_num;
> >> -       sema_init(&port->sm_sem, 1);
> >> +       init_completion(&port->sm_comp);
> >> +       complete(&port->sm_comp);
> >
> > Why complete here?
> >
> >>         mutex_init(&port->file_mutex);
> >>         INIT_LIST_HEAD(&port->file_list);
> >>
> > KR,
> > Jinpu
> 
> 
> Hi Jack,
> 
> ib_umad_sm_open() calls wait_for_completion_interruptible() which
> comes before ib_umad_sm_close() that calls complete(). In the
> initial open() there will not be anybody to signal the completion,
> so the complete is called to mark the initial state.  I am not sure
> if this is the right way to do it, though.

Using a completion to model exclusive ownership seems convoluted to
me - is that a thing now? What about an atomic?

open:

while (true) {
   wait_event_interruptible(priv->queue,test_bit(CLAIMED_BIT, &priv->flags));
   if (!test_and_set_bit(CLAIMED_BIT, &priv->flags))
        break;
}

close():

   clear_bit(CLAIMED_BIT, &priv->flags)
   wake_up(&priv->queue);

??

Jason
