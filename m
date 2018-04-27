From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/1] IB/rxe: avoid double kfree_skb
Date: Fri, 27 Apr 2018 12:24:07 -0400
Message-ID: <1524846247.11756.60.camel@redhat.com>
References: <1524146512-4188-1-git-send-email-yanjun.zhu@oracle.com>
         <1524190794.11756.18.camel@redhat.com>
         <89cbf00d-40b1-d3cc-dd1c-3c4b6fd365d8@oracle.com>
         <0b87f416-eee1-fd6c-c386-27469d6db143@oracle.com>
         <36d099a9-0946-c7b6-3c1f-0f64fc6bdf19@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Th32yWLE/raVi/z8Xqi+"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <36d099a9-0946-c7b6-3c1f-0f64fc6bdf19@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: Yanjun Zhu <yanjun.zhu@oracle.com>, monis@mellanox.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org
Cc: netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-Th32yWLE/raVi/z8Xqi+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-04-25 at 14:56 +0800, Yanjun Zhu wrote:
> Hi, all
>=20
> rxe_send [rdma_rxe]
>      ip_local_out
>          __ip_local_out
>          ip_output
>              ip_finish_output
>                  ip_finish_output2
>                      dev_queue_xmit
>                          __dev_queue_xmit
>                              dev_hard_start_xmit
>                                  e1000_xmit_frame [e1000]
>=20
> When skb is sent, it will pass the above functions. I checked all the=20
> above functions. If error occurs in the above functions after=20
> ip_local_out, kfree_skb will be called.
> So when ip_local_out returns an error, skb should be freed. It is not=20
> necessary to call kfree_skb in soft roce module again.
>=20
> If I am wrong, please correct me.

No one from netdev has spoken up, and I don't see where you are wrong,
so I've applied this to for-rc.  Thanks.

> Zhu Yanjun
> On 2018/4/24 16:34, Yanjun Zhu wrote:
> > Hi, all
> >=20
> > rxe_send
> >     ip_local_out
> >         __ip_local_out
> >             nf_hook_slow
> >=20
> > In the above call process, nf_hook_slow drops and frees skb, then=20
> > -EPERM is returned when iptables rules(iptables -I OUTPUT -p udp=20
> > --dport 4791 -j DROP) is set.
> >=20
> > If skb->users is not changed in softroce, kfree_skb should not be=20
> > called in this module.
> >=20
> > I will make further investigations about other error handler after=20
> > ip_local_out.
> > If I am wrong, please correct me.
> >=20
> > Any reply is appreciated.
> >=20
> > Zhu Yanjun
> > On 2018/4/20 13:46, Yanjun Zhu wrote:
> > >=20
> > >=20
> > > On 2018/4/20 10:19, Doug Ledford wrote:
> > > > On Thu, 2018-04-19 at 10:01 -0400, Zhu Yanjun wrote:
> > > > > When skb is dropped by iptables rules, the skb is freed at the sa=
me=20
> > > > > time
> > > > > -EPERM is returned. So in softroce, it is not necessary to free s=
kb=20
> > > > > again.
> > > > > Or else, crash will occur.
> > > > >=20
> > > > > The steps to reproduce:
> > > > >=20
> > > > >       server                       client
> > > > >      ---------                    ---------
> > > > >      |1.1.1.1|<----rxe-channel--->|1.1.1.2|
> > > > >      ---------                    ---------
> > > > >=20
> > > > > On server: rping -s -a 1.1.1.1 -v -C 10000 -S 512
> > > > > On client: rping -c -a 1.1.1.1 -v -C 10000 -S 512
> > > > >=20
> > > > > The kernel configs CONFIG_DEBUG_KMEMLEAK and
> > > > > CONFIG_DEBUG_OBJECTS are enabled on both server and client.
> > > > >=20
> > > > > When rping runs, run the following command in server:
> > > > >=20
> > > > > iptables -I OUTPUT -p udp  --dport 4791 -j DROP
> > > > >=20
> > > > > Without this patch, crash will occur.
> > > > >=20
> > > > > CC: Srinivas Eeda <srinivas.eeda@oracle.com>
> > > > > CC: Junxiao Bi <junxiao.bi@oracle.com>
> > > > > Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> > > > > Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
> > > >=20
> > > > I have no reason to doubt your analysis, but if there are a bunch o=
f
> > > > error paths for net_xmit and they all return with your skb still be=
ing
> > > > valid and holding a reference, and then one oddball that returns wi=
th
> > > > your skb already gone, that just sounds like a mistake waiting to=
=20
> > > > happen
> > > > (not to mention a bajillion special cases sprinkled everywhere to d=
eal
> > > > with this apparent inconsistency).
> > > >=20
> > > > Can we get a netdev@ confirmation on this being the right solution?
> > >=20
> > > Yes. I agree with you.
> > > After iptables rule "iptables -I OUTPUT -p udp  --dport 4791 -j=20
> > > DROP", the skb is freed in this function
> > >=20
> > > /* Returns 1 if okfn() needs to be executed by the caller,
> > >  * -EPERM for NF_DROP, 0 otherwise.  Caller must hold rcu_read_lock. =
*/
> > > int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
> > >                  const struct nf_hook_entries *e, unsigned int s)
> > > {
> > >         unsigned int verdict;
> > >         int ret;
> > >=20
> > >         for (; s < e->num_hook_entries; s++) {
> > >                 verdict =3D nf_hook_entry_hookfn(&e->hooks[s], skb,=
=20
> > > state);
> > >                 switch (verdict & NF_VERDICT_MASK) {
> > >                 case NF_ACCEPT:
> > >                         break;
> > >                 case NF_DROP:
> > > kfree_skb(skb);                               <----here, skb is freed
> > >                         ret =3D NF_DROP_GETERR(verdict);
> > >                         if (ret =3D=3D 0)
> > >                                 ret =3D -EPERM;
> > >                         return ret;
> > >                 case NF_QUEUE:
> > >                         ret =3D nf_queue(skb, state, e, s, verdict);
> > >                         if (ret =3D=3D 1)
> > >                                 continue;
> > >                         return ret;
> > >                 default:
> > >                         /* Implicit handling for NF_STOLEN, as well=
=20
> > > as any other
> > >                          * non conventional verdicts.
> > >                          */
> > >                         return 0;
> > >                 }
> > >         }
> > >=20
> > >         return 1;
> > > }
> > > EXPORT_SYMBOL(nf_hook_slow);
> > >=20
> > > If I am wrong, please correct me.
> > >=20
> > > And my test environment is still there, any solution can be verified=
=20
> > > in it.
> > >=20
> > > Zhu Yanjun
> > > >=20
> > > > > ---
> > > > >   drivers/infiniband/sw/rxe/rxe_net.c  | 3 +++
> > > > >   drivers/infiniband/sw/rxe/rxe_req.c  | 5 +++--
> > > > >   drivers/infiniband/sw/rxe/rxe_resp.c | 9 ++++++---
> > > > >   3 files changed, 12 insertions(+), 5 deletions(-)
> > > > >=20
> > > > > diff --git a/drivers/infiniband/sw/rxe/rxe_net.c=20
> > > > > b/drivers/infiniband/sw/rxe/rxe_net.c
> > > > > index 9da6e37..2094434 100644
> > > > > --- a/drivers/infiniband/sw/rxe/rxe_net.c
> > > > > +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> > > > > @@ -511,6 +511,9 @@ int rxe_send(struct rxe_pkt_info *pkt, struct=
=20
> > > > > sk_buff *skb)
> > > > >            if (unlikely(net_xmit_eval(err))) {
> > > > >                  pr_debug("error sending packet: %d\n", err);
> > > > > +               /* -EPERM means the skb is dropped and freed. */
> > > > > +               if (err =3D=3D -EPERM)
> > > > > +                       return -EPERM;
> > > > >                  return -EAGAIN;
> > > > >          }
> > > > >   diff --git a/drivers/infiniband/sw/rxe/rxe_req.c=20
> > > > > b/drivers/infiniband/sw/rxe/rxe_req.c
> > > > > index 7bdaf71..9d2efec 100644
> > > > > --- a/drivers/infiniband/sw/rxe/rxe_req.c
> > > > > +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> > > > > @@ -727,8 +727,9 @@ int rxe_requester(void *arg)
> > > > >                    rollback_state(wqe, qp, &rollback_wqe,=20
> > > > > rollback_psn);
> > > > >   -               if (ret =3D=3D -EAGAIN) {
> > > > > -                       kfree_skb(skb);
> > > > > +               if ((ret =3D=3D -EAGAIN) || (ret =3D=3D -EPERM)) =
{
> > > > > +                       if (ret =3D=3D -EAGAIN)
> > > > > +                               kfree_skb(skb);
> > > > >                          rxe_run_task(&qp->req.task, 1);
> > > > >                          goto exit;
> > > > >                  }
> > > > > diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c=20
> > > > > b/drivers/infiniband/sw/rxe/rxe_resp.c
> > > > > index a65c996..6bdf9b2 100644
> > > > > --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> > > > > +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> > > > > @@ -742,7 +742,8 @@ static enum resp_states read_reply(struct=20
> > > > > rxe_qp *qp,
> > > > >          err =3D rxe_xmit_packet(rxe, qp, &ack_pkt, skb);
> > > > >          if (err) {
> > > > >                  pr_err("Failed sending RDMA reply.\n");
> > > > > -               kfree_skb(skb);
> > > > > +               if (err !=3D -EPERM)
> > > > > +                       kfree_skb(skb);
> > > > >                  return RESPST_ERR_RNR;
> > > > >          }
> > > > >   @@ -956,7 +957,8 @@ static int send_ack(struct rxe_qp *qp, stru=
ct=20
> > > > > rxe_pkt_info *pkt,
> > > > >          err =3D rxe_xmit_packet(rxe, qp, &ack_pkt, skb);
> > > > >          if (err) {
> > > > >                  pr_err_ratelimited("Failed sending ack\n");
> > > > > -               kfree_skb(skb);
> > > > > +               if (err !=3D -EPERM)
> > > > > +                       kfree_skb(skb);
> > > > >          }
> > > > >     err1:
> > > > > @@ -1141,7 +1143,8 @@ static enum resp_states=20
> > > > > duplicate_request(struct rxe_qp *qp,
> > > > >                          if (rc) {
> > > > >                                  pr_err("Failed resending result.=
=20
> > > > > This flow is not handled - skb ignored\n");
> > > > >                                  rxe_drop_ref(qp);
> > > > > -                               kfree_skb(skb_copy);
> > > > > +                               if (rc !=3D -EPERM)
> > > > > +                                       kfree_skb(skb_copy);
> > > > >                                  rc =3D RESPST_CLEANUP;
> > > > >                                  goto out;
> > > > >                          }
> > > > > --=20
> > > > > 2.7.4
> > > > >=20
> > >=20
> > > --=20
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at http://vger.kernel.org/majordomo-info.html
>=20
>=20

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-Th32yWLE/raVi/z8Xqi+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrjTqcACgkQuCajMw5X
L91VhA/9FMVqKouBjZGjOmjjeprwS7pBa4DQH6z9Am6s67idQppdElaZdFM7nssx
rSlybtufOU8IMCF4o8UFekm4sIRo6CYqZHDj6hwND5+ylZYMmLn2pN0xIXHap0Dy
QQygGun/enMjezsVUlOj6CiU6wBMvKS5kPnKgtTYhCeANCHc6wnWkVJ7x5xdiMNH
X9AfZcXvT01A1+6DTAEYMYCIfqbfvBt0h2954NUUpx5wacCvK28o+Fi9dGJCZCNl
v6RObAB9AhlCxdjjmqXWsh7HapHAcN7q0UW1OshvJEFhxEVWZVs1C/9ytIXX7k3g
RhJuXlNsVY1tOfMRrmWM2u84CT95x5ODsqboqg7zs8rk1FF5LZEOc25KNvIuGfdC
OKxDRJhpRSB7B6/v58Rm9zlPswHLwFwYww7w1mTghu1mwkqzDMikY3JZAZpC/3Cj
srdDc4vNrcVsaoLq2LmEjtP/jLSpNFdcTTQvEbXlqSe0RDQ/z/O98rZLR6Kseo9d
0bpzDIn6wemhtwGxTnNrbxY53+0gWVpe43BisJhC6uDd12rnruK7JxxGH80+cYZP
vnvtqc3T3zElZU+mK1VwlkIa5UH0Go1/gZ1D0ksKIvCBXDmYg4OxT7fzqoT3bIyL
czbl4aJ3woIYQknYF3yCpeWmMwEIqJEmNhx9qvH/3jFFeJbAOds=
=vKsm
-----END PGP SIGNATURE-----

--=-Th32yWLE/raVi/z8Xqi+--
