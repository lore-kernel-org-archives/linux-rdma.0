From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Problem with XRC userspace
Date: Mon, 15 Feb 2010 10:34:54 -0700
Message-ID: <20100215173454.GA19714@obsidianresearch.com>
References: <201002151456.56696.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201002151456.56696.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, changquing.tang-VXdhtT5mjnY@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 15, 2010 at 02:56:56PM +0200, Jack Morgenstein wrote:

> If I put the XRC srq fields after the pthread_cond_t, the RHEL4/5
> incompatibility kicks in, in a big way.  If I put them before the
> pthread_cond_t, we still have a problem with "events_completed", as
> indicated by Gleb Nabokov of Voltaire, not to mention requiring all
> apps using libibverbs to recompile (no backwards libibverbs binary
> compatibility).

So, er, is this trying to say that RH changed the size of
pthread_cond_t, and because this internal structure is exposed via the
header file rather than being opaque you can get the app thinking the
size is X and the library thinking it is Y and presumably both link to
different symvers for things like pthread_cond_XX?

> In the OFED distribution, since it is installed as a set of
> packages, we simply moved the mutex and cond fields to the end of
> the structures involved (as a userspace fix).  What on earth can we
> do for the mainstream ( see below -- "Yikes...")?

Well, no matter what, you have to rev at least the ibverbs API toward
the driver. You cannot actually change ibv_srq at all without breaking
all the drivers too. Look at mlx4, it allocates a

struct mlx4_srq {
        struct ibv_srq                  ibv_srq;
        struct mlx4_buf                 buf;

During ibv_create_srq - you cannot increase the size of ibv_srq
without breaking this API.

Soo.. going ahead and breaking the driver API (rev the symver on
ibv_cmd_create_srq I guess), it seems pretty simple to fixup:

struct ibv_srq {
         struct ibv_context     *context;
         void                   *srq_context;
         struct ibv_pd          *pd;
         uint32_t                handle;

         uint32_t                xrc_srq_num;
         struct ibv_xrc_domain  *xrc_domain;
         struct ibv_cq          *xrc_cq;

         uint32_t private[64]; // Something more sneaky for the 64..
};

struct ibv_srq_private {
         pthread_mutex_t         mutex;
         pthread_cond_t          cond;
         uint32_t                events_completed;
};

Then use:
COMPILE_BUG(sizeof(srq->private) >= sizeof(struct ibv_srq_private));
pthread_cond_signal(((ibv_srq_private *)srq->private)->cond);

Since pthread_cond_t can be different sizes the app *cannot* touch it
directly and the events_completed cannot be accessed without taking
the lock, this shouldn't cause any problems. You can put the xrc items
anywhere in the structure so long as the other 4 public members do not
change offset.

Realistically, the only things that need to be built against the same
libpthreads are the drivers and the libibverbs itself, as long as the
3 private items remain at the end of the structure the apps won't
care. If this was a really big deal then the symver of
ibv_cmd_create_srq would need to be determined based on the libpthread
it was linked too.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
