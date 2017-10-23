From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
 misinterpreted flag
Date: Mon, 23 Oct 2017 20:12:11 +0300
Message-ID: <20171023171211.GM2106@mtr-leonro.local>
References: <20171019213859.26124.37851.stgit@phlsvslse11.ph.intel.com>
 <20171020073724.GY2106@mtr-leonro.local>
 <14063C7AD467DE4B82DEDB5C278E8663875E0841@FMSMSX108.amr.corp.intel.com>
 <20171023081117.GE2106@mtr-leonro.local>
 <f03e51d6-4157-64b4-ec5d-9beac00ceb87@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="waAWgznbqtWOzvJZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f03e51d6-4157-64b4-ec5d-9beac00ceb87-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--waAWgznbqtWOzvJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 23, 2017 at 10:49:24AM -0400, Doug Ledford wrote:
> On 10/23/2017 4:11 AM, Leon Romanovsky wrote:
> > On Fri, Oct 20, 2017 at 05:20:22PM +0000, Ruhl, Michael J wrote:
> >>> -----Original Message-----
> >>> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> >>> Sent: Friday, October 20, 2017 3:37 AM
> >>> To: Ruhl, Michael J <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >>> Subject: Re: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
> >>> misinterpreted flag
> >>>
> >>> On Thu, Oct 19, 2017 at 05:40:59PM -0400, Michael J. Ruhl wrote:
> >>>> I was playing with the ibacm service and discovered an issue
> >>>> the other day.
> >>>>
> >>>> If no provider library is present (I removed libacmp.so, and the
> >>>> provider keyword in the opts.cfg file is libacmp), when a resolve
> >>>> request is posted, the kernel will crash with the following Oops:
> >>>>
> >>>> Call Trace:
> >>>>  ? netlink_dump+0x12c/0x290
> >>>>  __netlink_dump_start+0x186/0x1f0
> >>>>  rdma_nl_rcv_msg+0x193/0x1b0 [ib_core]
> >>>>  rdma_nl_rcv+0xdc/0x130 [ib_core]
> >>>>  netlink_unicast+0x181/0x240
> >>>>  netlink_sendmsg+0x2c2/0x3b0
> >>>>  sock_sendmsg+0x38/0x50
> >>>>  SYSC_sendto+0x102/0x190
> >>>>  ? __audit_syscall_entry+0xaf/0x100
> >>>>  ? syscall_trace_enter+0x1d0/0x2b0
> >>>>  ? __audit_syscall_exit+0x209/0x290
> >>>>  SyS_sendto+0xe/0x10
> >>>>  do_syscall_64+0x67/0x1b0
> >>>>  entry_SYSCALL64_slow_path+0x25/0x25
> >>>>
> >>>> The issue is that in rdma_nl_rcv_msg(), the check
> >>>> 'if (flags & NLM_F_DUMP)' is not completely correct.
> >>>>
> >>>> NLM_F_DUMP is two bits NLM_F_ROOT | NLM_F_MATCH.
> >>>>
> >>>> ibacm sends a RDMA_NL_LS response with the RDMA_NL_LS_F_ERR bit set
> >>>> if an error occurs in the service (like no provider being available,
> >>>> or ACM_STATUS_ENODATA, etc.).
> >>>>
> >>>> NLM_F_ROOT == (0x100) == RDMA_NL_LS_F_ERR.
> >>>>
> >>>> The current code thinks that it sees a NLM_F_DUMP flag and incorrectly calls
> >>>> the .dump() callback.
> >>>
> >>> Hi Michael,
> >>>
> >>> Thanks for the report and for excellent analysis, You are right that
> >>> RDMA_NL_LS_F_ERR has the same value as NLM_F_ROOT and it is bad, but
> >>> I just think that it is not the final root cause.
> >>>
> >>> In case of errors, the LS was supposed to send NLMSG_ERROR message and not
> >>> overload general nlmsg_flags, which is awful. However I don't know if it is
> >>> feasible to fix current implementation without breaking UAPI contract.
> >>
> >> I agree this is probably something that needs to get followed up on.
> >>
> >>> In meanwhile, can we implement dummy dumpit functions for the LS,
> >>> which reuse ib_nl_is_good_ip_resp?
> >>
> >> The original code does not call the netlink_dump_start() code for this path, so if we create a dummy dump function we will have to add code to special case this and call it directly.
> >>
> >> So maybe we could just go back to the original code and call .doit rather than .dump in the non netlink_dump_start() path?
> >>
> >> i.e.:
> >>       if (!(nlh->nlmsg_flags & NLM_F_REQUEST) ||
> >>            (index == RDMA_NL_LS && op == RDMA_NL_LS_OP_SET_TIMEOUT)) {
> >>                cb.skb = skb;
> >>                cb.nlh = nlh;
> >>                cb.dump = cb_table[op].dump;
> >> -               return cb.dump(skb, &cb);
> >> +               return cb.doit(skb, &cb);
> >>        } else {
> >>                c.dump = cb_table[op].dump;
> >>
> >>
> >>> I prefer this solution over yours, because it doesn't mix LS-specifics with
> >>> general decision function and leaves LS anomalies in the LS-relevant code.
> >>
> >> The problem with this is that the code has to take into consideration the LS anomalies either before the this function is called, or has to deal with them here.
> >>
> >> The other thought would be to special case the LS stuff before this decision and call the .doit function there (and then return).
> >
> > What about such code?
> >
> > diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
> > index b12e58787c3d..6a7362664876 100644
> > --- a/drivers/infiniband/core/netlink.c
> > +++ b/drivers/infiniband/core/netlink.c
> > @@ -175,6 +175,14 @@ static int rdma_nl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
> >  	    !netlink_capable(skb, CAP_NET_ADMIN))
> >  		return -EPERM;
> >
> > +	/*
> > +	 * LS is special because it runs backward communication
> > +	 * and it overloads NLM_F_DUMP flag with RDMA_NL_LS_F_ERR
> > +	 * So we are calling to .doit before processing .dumpit call.
> > +	 */
> > +	if (index == RDMA_NL_LS)
> > +		return cb_table[op].doit(skb, nlh, extack);
> > +
> >  	/* FIXME: Convert IWCM to properly handle doit callbacks */
> >  	if ((nlh->nlmsg_flags & NLM_F_DUMP) || index == RDMA_NL_RDMA_CM ||
> >  	    index == RDMA_NL_IWCM) {
> >
> >>
> >>> And returning 0 in absence of dumpit function as a response with
> >>> NLM_F_DUMP flag is wrong. User should be aware of the fact that
> >>> something wrong was with his request.
> >>
> >> This was the value that the function returns if .dump and .doit are NOT selected, so I thought that this was appropriate.  Should that value (the final return 0) be changed to something different?
> >
> > The is_nl_valid() should return "false" If no .dumpit/.doit functions exist.
> > In such case, we are supposed to return EINVAL.
>
> My comment here is not specifically related to this issue alone, but to
> the overall netlink changes in general.  I just want to make sure people
> are aware that this qualifies as a security fix, it *would* need to be
> addressed in stable if we weren't still in the same devel cycle that the
> overall netlink changes were introduced, and because this exposed the
> fact that we could call a routine that does not exist and oops the
> kernel, I think we need a quick audit of the netlink code to make sure
> there isn't another way for this to happen.  Since this is user input
> directing the kernel to jump to a specific callback, this netlink code
> must be hardened against intentional attacks (and I haven't looked to
> see if this patch is sufficient to do that yet, I'm just trying to set
> expectations of what really needs to be done so I can send a complete
> pull request to Linus for this).

Doug,

It has very little related to security here. The RDMA_NL_LS netlink
operations require CAP_NET_ADMIN capability set and it is checked before
calling any callback.

>
> Cc: Linus to make him aware of the issue and to expect a fix from us
> sometime this week.
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--waAWgznbqtWOzvJZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnuIuoACgkQ5GN7iDZy
WKdLZhAAmSSFcvEykDanvuUj6vSUO2hjIUUNk6ai9qVMRNyOCH7ADbk/S3JC7Jto
YtBxS6HHt99DzxddJ0y/kKAhB7KuseUX4ST15Wl1tNA6sA1yAArcPu3z2ov0zRZq
u0FoKSVhinb0qCfrO02LMSKhQiFFVfFWiWRexTdS2AF68eVxVylbPcJMC7iRPNYo
jP8agdU5yJrWcp54bl41mAl+UmBoNr+aU6RBrMH7pXpzoQvFVcxzAKXgVpbWpPgi
/wNROdRoTQNRZYrOZBdIcFVdCNINwHiVKCky8fq/T/nbPM1tEY6U/G1Cw+jaoQek
TdtoErZ4TiSLt5A83SfF7j1AAAAMERhIaDJgCGulnVgDZ0J09vhf6FttnQ5HPCfx
W6T3lrZWjqdAC8+QVNY2lXX7xvxq46u4JgxDRbAPkn2hs4Zlg+JVmQLr0PmBzzqh
xiqWXJU6mJda8ACV7akhGiXFG1p9Fg6/Nx20a6u1IA90PCDL4HoxS1Z4+UPODc7b
XfEIrdqqk9gFxlappVo5QNGqzNqtZO264soKqum5zVkhDjEnBu85mEOCrkVgnssr
dSfpSuJ4XDVclLpQnui+BospKaiCidr34qOzWU/y00tZaodZKK59/0ZvyQsqYzPD
718BWoiR3sIDAteUUL1047WG0XlMZx+HVohveAFRTJHifBx9iPA=
=2Qw1
-----END PGP SIGNATURE-----

--waAWgznbqtWOzvJZ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
