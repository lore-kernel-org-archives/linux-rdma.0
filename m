From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 for-next 01/15] RDMA/bnxt_re: Fixing the Control path
 command and response handling
Date: Thu, 18 May 2017 14:46:14 +0300
Message-ID: <20170518114614.GC3616@mtr-leonro.local>
References: <1495012791-5053-1-git-send-email-selvin.xavier@broadcom.com>
 <1495012791-5053-2-git-send-email-selvin.xavier@broadcom.com>
 <20170518105311.GB3616@mtr-leonro.local>
 <CA+sbYW0WwxQkPJ_KAdth25p-s320yonO8vKTUa_V43e3ofdAOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="L/iKGr82HRlWSTal"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+sbYW0WwxQkPJ_KAdth25p-s320yonO8vKTUa_V43e3ofdAOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--L/iKGr82HRlWSTal
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 18, 2017 at 04:47:59PM +0530, Selvin Xavier wrote:
> On Thu, May 18, 2017 at 4:23 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >> -int bnxt_qplib_rcfw_block_for_resp(struct bnxt_qplib_rcfw *rcfw, u16 cookie)
> >> +static int __block_for_resp(struct bnxt_qplib_rcfw *rcfw, u16 cookie)
> >>  {
> >> -     u32 count = -1;
> >> +     u32 count = RCFW_BLOCKED_CMD_WAIT_COUNT;
> >>       u16 cbit;
> >>
> >> -     cookie &= RCFW_MAX_COOKIE_VALUE;
> >>       cbit = cookie % RCFW_MAX_OUTSTANDING_CMD;
> >>       if (!test_bit(cbit, rcfw->cmdq_bitmap))
> >>               goto done;
> >>       do {
> >> +             mdelay(1); /* 1m sec */
> >
> > It doesn't work as you may expect. msleep below 20 ms is not reliable.
> > See my queued for this cycle commit
> > https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=topic/msleep-to-usleep_range
> >
> >>               bnxt_qplib_service_creq((unsigned long)rcfw);
> >>       } while (test_bit(cbit, rcfw->cmdq_bitmap) && --count);
> >>  done:
>
> __block_for_resp is called from functions where it is not expected to
> sleep (say from create_ah). That is the reason for
> using the mdelay instead of sleep. So we may not be able to use
> usleep_range here. Both instances of
> mdelay are in the atomic contexts.

Ahh, sorry, my bad.
I misread mdelay and msleep.

Sorry about that.

--L/iKGr82HRlWSTal
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkdiYYACgkQ5GN7iDZy
WKf+NxAAxXaxfAqRSKPLs77TFm4XQSKJyYvNdrVBCfRJ/IsyaU2HsjneGGyc+uUh
AHI8mPHM16dgiOzUdDfgw1SOy2sT1u4fXwgQxGwCMSp8z4DS6fDU1ho8GwC7+Wh9
wFNPp/Uv9R1vGSCSOzNTJBxGe3obYjdp3/2AReGjKnN82OJCMkvlHe3gtGA8jSGj
XYscdd5ryds2KqCrWc9E1s0QVY29L4qY65jCV5Gd7kaIo0HUpDqRG6NSp+MsZJBU
A5wk2v49nkdi5dpPxoIgiCW1MBMt58OW+ldUG7bdcEH/vj1ZOSUvSgx1hjoY6ul8
0KP+qb3TzrOetnM6MEStWlFmpsRQBj5ynFyerwWkoQW27Qn/AIUTFWhHocdpv8kt
/XBXnrIJAb15D/KnGfLJz32ffjnLJMHTuvrK1qkoQdE4nQNRB5JlmyuRwKIjRwpY
ey+Z+imw9wpqoVwp2NKK+m8S9GOktXSnGbkP91tHLNSatguPTyLPNZ6CEUS7yeqx
44DlB3LynMf5uJ4q06fxwKsFUbEAjjfs/x2VaF5x9MeREc7teG6fX+tsamx7bSGo
T8S8a6fhkrsZgDUWqdTrSawXu2biOkBqvyd/sb1zBkrr9N+XUZIQG0KAGTmmKQ0N
JuZUtfbHHfg/ctPRviYBh5N0BI8cM0iliZRqojrZRusO5xcaYj8=
=AVY/
-----END PGP SIGNATURE-----

--L/iKGr82HRlWSTal--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
