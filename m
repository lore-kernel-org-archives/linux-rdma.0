From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 1/2] RPING: Make sure CQ event thread exits before
 destroying the CQ.
Date: Wed, 20 Oct 2010 22:05:36 +0200
Message-ID: <AANLkTi=uAuXT1RMEQ+vsA4FkN2828mZ2q0KPKXxpb6H0@mail.gmail.com>
References: <20101020192859.1431.68877.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101020192859.1431.68877.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 20, 2010 at 9:28 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+v7I7tHvgBF7@public.gmane.org=
m> wrote:
>
> It is possible for the CQ event thread to poll the CQ after it has be=
en
> destroyed which can result in a seg fault on T3 interfaces. =A0This p=
atch
> cancels the thread and waits for it to exit before destroying the CQ.
>
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>
> =A0examples/rping.c | =A0 =A08 ++++++--
> =A01 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/examples/rping.c b/examples/rping.c
> index 91952e7..e603d3b 100644
> --- a/examples/rping.c
> +++ b/examples/rping.c
> @@ -800,10 +800,10 @@ static void *rping_persistent_server_thread(voi=
d *arg)
>
> =A0 =A0 =A0 =A0rping_test_server(cb);
> =A0 =A0 =A0 =A0rdma_disconnect(cb->child_cm_id);
> - =A0 =A0 =A0 rping_free_buffers(cb);
> - =A0 =A0 =A0 rping_free_qp(cb);
> =A0 =A0 =A0 =A0pthread_cancel(cb->cqthread);
> =A0 =A0 =A0 =A0pthread_join(cb->cqthread, NULL);
> + =A0 =A0 =A0 rping_free_buffers(cb);
> + =A0 =A0 =A0 rping_free_qp(cb);
> =A0 =A0 =A0 =A0rdma_destroy_id(cb->child_cm_id);
> =A0 =A0 =A0 =A0free_cb(cb);
> =A0 =A0 =A0 =A0return NULL;
> @@ -888,6 +888,8 @@ static int rping_run_server(struct rping_cb *cb)
>
> =A0 =A0 =A0 =A0rping_test_server(cb);
> =A0 =A0 =A0 =A0rdma_disconnect(cb->child_cm_id);
> + =A0 =A0 =A0 pthread_cancel(cb->cqthread);
> + =A0 =A0 =A0 pthread_join(cb->cqthread, NULL);
> =A0 =A0 =A0 =A0rdma_destroy_id(cb->child_cm_id);
> =A0err2:
> =A0 =A0 =A0 =A0rping_free_buffers(cb);
> @@ -1055,6 +1057,8 @@ static int rping_run_client(struct rping_cb *cb=
)
>
> =A0 =A0 =A0 =A0rping_test_client(cb);
> =A0 =A0 =A0 =A0rdma_disconnect(cb->cm_id);
> + =A0 =A0 =A0 pthread_cancel(cb->cqthread);
> + =A0 =A0 =A0 pthread_join(cb->cqthread, NULL);
> =A0err2:
> =A0 =A0 =A0 =A0rping_free_buffers(cb);
> =A0err1:

Hello Steve,

Are you aware that in general it is easy to trigger a deadlock or
other undesired behavior by invoking pthread_cancel() ? If a thread
e.g. gets canceled after having obtained a mutex lock and before that
mutex is unlocked, this will cause trouble for any other thread that
tries to grab the mutex.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
