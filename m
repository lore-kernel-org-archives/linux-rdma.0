From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/rxe: Add port protocol stats
Date: Fri, 10 Mar 2017 18:17:16 +0200
Message-ID: <20170310161716.GA14379@mtr-leonro.local>
References: <20170302081554.5012-1-leon@kernel.org>
 <D4E6FBE1.13839%Andrew.Boyer@emc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JcGvecxLhm+LytDG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D4E6FBE1.13839%Andrew.Boyer-mb1K0bWo544@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--JcGvecxLhm+LytDG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 09, 2017 at 05:35:45PM +0000, Boyer, Andrew wrote:
>
> On 3/2/17, 3:15 AM, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of Leon
> Romanovsky" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of
> leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> >From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> >Expose new counters using the get_hw_stats callback.
> >We expose the following counters:
> >
> >+---------------------+----------------------------------------+
> >|      Name           |           Description                  |
> >|---------------------+----------------------------------------|
> >|sent_pkts            | number of sent pkts                    |
> >|---------------------+----------------------------------------|
> >|rcvd_pkts            | number of received packets             |
> >|---------------------+----------------------------------------|
> >|out_of_sequence      | number of errors due to packet         |
> >|                     | transport sequence number              |
> >|---------------------+----------------------------------------|
> >|duplicate_request    | number of received duplicated packets. |
> >|                     | A request that previously executed is  |
> >|                     | named duplicated.                      |
> >|---------------------+----------------------------------------|
> >|rcvd_rnr_err         | number of received RNR by completer    |
> >|---------------------+----------------------------------------|
> >|send_rnr_err         | number of sent RNR by responder        |
> >|---------------------+----------------------------------------|
> >|rcvd_seq_err         | number of out of sequence packets      |
> >|                     | received                               |
> >|---------------------+----------------------------------------|
> >|ack_deffered         | number of deferred handling of ack     |
> >|                     | packets.                               |
> >|---------------------+----------------------------------------|
> >|retry_exceeded_err   | number of times retry exceeded         |
> >|---------------------+----------------------------------------|
> >|completer_retry_err  | number of times completer decided to   |
> >|                     | retry                                  |
> >|---------------------+----------------------------------------|
> >|send_err             | number of failed send packet           |
> >+---------------------+----------------------------------------+
> >
> >Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >
> >---
> > drivers/infiniband/sw/rxe/Makefile          |  3 +-
> > drivers/infiniband/sw/rxe/rxe_comp.c        | 12 +++++
> > drivers/infiniband/sw/rxe/rxe_hw_counters.c | 78
> >+++++++++++++++++++++++++++++
> > drivers/infiniband/sw/rxe/rxe_hw_counters.h | 61 ++++++++++++++++++++++
> > drivers/infiniband/sw/rxe/rxe_loc.h         |  2 +
> > drivers/infiniband/sw/rxe/rxe_recv.c        |  2 +
> > drivers/infiniband/sw/rxe/rxe_resp.c        |  5 ++
> > drivers/infiniband/sw/rxe/rxe_verbs.c       |  3 ++
> > drivers/infiniband/sw/rxe/rxe_verbs.h       |  8 +++
> > 9 files changed, 173 insertions(+), 1 deletion(-)
> > create mode 100644 drivers/infiniband/sw/rxe/rxe_hw_counters.c
> > create mode 100644 drivers/infiniband/sw/rxe/rxe_hw_counters.h
> >
> >diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c
> >b/drivers/infiniband/sw/rxe/rxe_comp.c
> >index 4cd55d5617f7..85343f339624 100644
> >--- a/drivers/infiniband/sw/rxe/rxe_comp.c
> >+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
> >@@ -685,6 +692,8 @@ int rxe_completer(void *arg)
> > 					/* tell the requester to retry the
> > 					 * send send queue next time around
> > 					 */
> >+					rxe_counter_inc(rxe,
> >+							RXE_CNT_COMP_RETRY);
> > 					qp->req.need_retry =3D 1;
> > 					rxe_run_task(&qp->req.task, 1);
> > 				}
>
> While here, fix =B3send send queue=B2 in comments?
>
> >diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h
> >b/drivers/infiniband/sw/rxe/rxe_verbs.h
> >index e100c500ae85..3abe9ca97599 100644
> >--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
> >+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
> >@@ -38,6 +38,7 @@
> > #include <rdma/rdma_user_rxe.h>
> > #include "rxe_pool.h"
> > #include "rxe_task.h"
> >+#include "rxe_hw_counters.h"
> >
> > static inline int pkey_match(u16 key1, u16 key2)
> > {
> >@@ -401,10 +402,17 @@ struct rxe_dev {
> > 	spinlock_t		mmap_offset_lock; /* guard mmap_offset */
> > 	int			mmap_offset;
> >
> >+	u64 stats_counters[RXE_NUM_OF_COUNTERS];
> >+
> > 	struct rxe_port		port;
> > 	struct list_head	list;
> > };
>
> Match indentation with other fields?
>
> Looks good otherwise.
> Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>

Thanks for the review,
I'll post v1.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--JcGvecxLhm+LytDG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljC0YsACgkQ5GN7iDZy
WKdsvhAAs0JVyl8jE6MmZQBCHNqj4PWKPymKx6tTEZS5+RarkNNpP8xpvNMa7gFc
TwXcnrv/xE8xOQu/BcfcgKKuPXCaHCh72IAJj5yFnHhurEFb6kv/1qTdFrw9MgnR
+U9dXbw7624pfpwcDqld4ui4b8cH6Hnq9kznqVIH7XSA6nH8MKAexNbxmZx6Z1Pb
TZBOeSv0uLdq8yfJqYsOfjFRuztE/QdEsDH3zpGw5erqRFhcFVX3dXRp6G+Rb9a1
n6PSQ+KJrQZAxd2eEFXHmOPZebr5LVVLIRxZWKhEDDTYqRo9r+WfpSbQKC19NdpS
tbfpQIKhU00Iu58kR4WS8BmIptmeXYwHTlkBxMgyRRBrK3i3Ro1z9qU+4MBGacNN
kWGbfNTjp56Zt29fXiCA4V++6u0yfyXQwp0JYTuEdb/LSP5GM144cvDHZMnagzDv
fHxP/xpZK7lfzQbawSJu/yBzFpWCneBjRcQjfSHQHcgFyhfGdNJfDangTi+STp1p
KLkPhaHdZbwkVSA92LhCvxH1JE4R8Sd3LLK+qvDcabYw5WamgR5kNM/Q9yUGFhJC
Un1jaM7C0i3xs+M6ITiyqrqkQ5ucejS3qk7UIDcZDxr3JLT3ih68oJe+xHZnv7Lc
a0TRf9QDDdS3ie+Iztk6X6iR1ZVbXRzgU6394C3IIdII8Fet4Yo=
=32+w
-----END PGP SIGNATURE-----

--JcGvecxLhm+LytDG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
