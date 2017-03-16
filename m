From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [rdma-core v3 8/9] libbnxt_re: Add support for atomic operations
Date: Thu, 16 Mar 2017 16:07:38 +0000
Message-ID: <1489680444.2574.9.camel@sandisk.com>
References: <1489574253-20300-1-git-send-email-devesh.sharma@broadcom.com>
         <1489574253-20300-9-git-send-email-devesh.sharma@broadcom.com>
         <20170315191515.GH2079@mtr-leonro.local>
         <CANjDDBjGCCc8MLLQ3jhToWyc0Z+Qm3pYejz3BrMrRketDdZbEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANjDDBjGCCc8MLLQ3jhToWyc0Z+Qm3pYejz3BrMrRketDdZbEw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <B788AC5F0B69A54D9F5206AC50F7F0C1-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-03-16 at 21:24 +0530, Devesh Sharma wrote:
> On Thu, Mar 16, 2017 at 12:45 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote=
:
> > On Wed, Mar 15, 2017 at 06:37:32AM -0400, Devesh Sharma wrote:
> > > @@ -1116,6 +1119,44 @@ static int bnxt_re_build_rdma_sqe(struct bnxt_=
re_qp *qp, void *wqe,
> > >       return len;
> > >  }
> > >=20
> > > +static int bnxt_re_build_cns_sqe(struct bnxt_re_qp *qp, void *wqe,
> > > +                              struct ibv_send_wr *wr)
> > > +{
> > > +     struct bnxt_re_bsqe *hdr =3D wqe;
> > > +     struct bnxt_re_atomic *sqe =3D ((void *)wqe +
> > > +                                   sizeof(struct bnxt_re_bsqe));
> > > +     int len;
> > > +
> > > +     len =3D bnxt_re_build_send_sqe(qp, wqe, wr, false);
> > > +     hdr->key_immd =3D wr->wr.atomic.rkey;
> > > +     sqe->rva_lo =3D lower_32_bits(wr->wr.atomic.remote_addr);
> > > +     sqe->rva_hi =3D upper_32_bits(wr->wr.atomic.remote_addr);
> > > +     sqe->cmp_dt_lo =3D lower_32_bits(wr->wr.atomic.compare_add);
> > > +     sqe->cmp_dt_hi =3D upper_32_bits(wr->wr.atomic.compare_add);
> > > +     sqe->swp_dt_lo =3D lower_32_bits(wr->wr.atomic.swap);
> > > +     sqe->swp_dt_hi =3D upper_32_bits(wr->wr.atomic.swap);
> > > +
> >=20
> > Sorry for my question, but why do you need to separate uint64_t variabl=
e
> > to two __u32? Why can't you declare one __u64?
>=20
> It may help 32 bit CPU during byte order conversion.

Does that mean that you consider optimizing for 32-bit CPUs more important =
than
optimizing for 64-bit CPUs? Does this also mean that you expect that the ma=
cros
you introduced in your driver to be more efficient than the glibc endiannes=
s
conversion macros? Sorry but this sounds like a weird explanation to me. I =
agree
with Leon that it would be a significant improvement if 64-bit data types w=
ould
be used instead of using numerous lower_32_bits() / upper_32_bits() calls.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
