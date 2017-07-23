From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 7/9] IB/core: Allow QP state transition from
 reset to error
Date: Sun, 23 Jul 2017 10:41:53 +0300
Message-ID: <20170723074153.GF3259@mtr-leonro.local>
References: <20170530000314.534.72983.stgit@scvm10.sc.intel.com>
 <20170530002032.534.25061.stgit@scvm10.sc.intel.com>
 <20170530054609.GG17751@mtr-leonro.local>
 <20170723073905.GE3259@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/LSm8UPTCLHL4o89"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170723073905.GE3259-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--/LSm8UPTCLHL4o89
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 23, 2017 at 10:39:05AM +0300, Leon Romanovsky wrote:
> On Tue, May 30, 2017 at 08:46:09AM +0300, Leon Romanovsky wrote:
> > On Mon, May 29, 2017 at 05:20:53PM -0700, Dennis Dalessandro wrote:
> > > From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >
> > > Playing with IP-O-IB interface can trigger a warning message:
> > > "ib0: Failed to modify QP to ERROR state" to be logged.
> > > This happens when the QP is in IB_QPS_RESET state and the stack
> > > is trying to transition it to IB_QPS_ERR state in ipoib_ib_dev_stop().
> > >
> > > According to the IB spec, Table 91 - "QP State Transition Properties"
> > > it looks like the transition from reset to error is valid:
> > >
> > > Transition: Any State to Error
> > > Required Attributes: None
> > > Optional Attributes: None allowed
> > > Actions: Queue processing is stopped. Work Requests pending or in
> > > process are completed in error, when possible.
> > >
> > > This patch allows the transition and quiets the message.
> > >
> > > Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > ---
> >
> > Thanks,
> > Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Doug,
>
> After digging more with Erez's help, it looks like the sentence "it
> looks like the transition from reset to error is valid:" is not correct.
>
> According to the InfiniBandTM Architecture Release 1.3, Figure 126 QP/EE Context
> State Diagram - transition to error from reset is not valid.
>
> The quote from the spec:
> "An error can be forced from any state, except Reset, with the Modify QP/EE Verb."
>
> I'll send revert patch along with proper fix.

Ahh, it wasn't pushed to kernel.org, so no need to revert and you can
simply drop it.

Thanks

>
> Thanks



--/LSm8UPTCLHL4o89
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll0U0EACgkQ5GN7iDZy
WKex2xAAsuJ03iMv6vW47p0MV51xCoWGGj6JqGSOSwaBkmQqkC5K1rOmawj9i5nN
IjpmEM5L+nOjGtBfb2WPTVuhAev3yxZcWBQz536vMmRr5VzoHm94A5ZE+nY8f2XL
uarQoPOC4p4cydyhDhxY2DHbzPdbxuxk1pW6MtOUdwOKnaFiXul5ooSc4nYkz/rI
2udmRSjf5VUQQxq/dj1fmtrjyaM5Xw8mSaxgquonD6IFyyd3V2ybmIEhfa3BGT1k
AnKvmCGnvBDbo5FPLW74ZJ7IQkFuPOfbOCSNt4GwPqwlvGw/6GzlTAHNougSKDw8
PhxQDX/EsTB7iQcQTtmHTG49fTKAuVr0UbMrpdsWpJM8CErmh/hXUvIhuHQKnuzn
GLqlPyQVmKobag/cs2nEunm6NSCBi7UvxQEa3q7DSD5FAOj4QTMJV8cugwOqkvYA
K+xQp9FwgZxpWPzcgfnqFfq3M+v5ZeM7iBNu9ueXpbDyY2hElmDE2FW48o5X5tzU
NsDLMfgt4dEdwRQbTbPjZglzRpG4GnPYRK7hcTMS5/Fe6T/hrwQs4ZmZFq1RI4dg
8+G3nN1bNzX89v1uheTgyT64JFz7oGYf2hnfHaRvhlrHB1T6K/0r4BNAde3XR7tm
jKYZNSYwcFDOEhYW1ASyZQ+IHmEzrGbMj0UorBP6aRxqYS8vmeg=
=y0ff
-----END PGP SIGNATURE-----

--/LSm8UPTCLHL4o89--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
