From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: srp warning
Date: Wed, 12 Jan 2011 09:43:13 -0800
Message-ID: <adalj2q587i.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Just noticed this in my latest build:

    drivers/infiniband/ulp/srp/ib_srp.c: In function =E2=80=98srp_queue=
command=E2=80=99:
    drivers/infiniband/ulp/srp/ib_srp.c:1116: warning: =E2=80=98req=E2=80=
=99 may be used uninitialized in this function

Looks like it came from 76c75b258f1f ("IB/srp: reduce local coverage fo=
r
command submission and EH") because the code now looks like:

	iu =3D __srp_get_tx_iu(target, SRP_IU_CMD);
	if (iu) {
		req =3D list_first_entry(&target->free_reqs, struct srp_request,
				      list);
		list_del(&req->list);
	}

	// ...

	if (!iu)
		goto err;

	// ...

	scmnd->host_scribble =3D (void *) req;

and my gcc at least is not smart enough to see that we can't reach the
use of req without initializing req.

Simplest fix is to mark req with uninitialized_var() but maybe there's =
a
nicer way to handle this.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
