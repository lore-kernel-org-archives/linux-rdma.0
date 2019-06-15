From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: RDMA: Clean destroy CQ in drivers do not return errors
Date: Sat, 15 Jun 2019 07:12:27 +0000
Message-ID: <20190615071224.GA4694@mtr-leonro.mtl.com>
References: <68d62660-902c-ca49-20fd-32e92830faa7@canonical.com>
 <ee0c017e93e28317791b7395e257801a208c7306.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ee0c017e93e28317791b7395e257801a208c7306.camel@redhat.com>
Content-Language: en-US
Content-ID: <C2621CA764179B4DAA30AD367EA0F07E@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Colin Ian King <colin.king@canonical.com>, Gal Pressman <galpress@amazon.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 14, 2019 at 03:46:50PM -0400, Doug Ledford wrote:
> On Fri, 2019-06-14 at 14:59 +0100, Colin Ian King wrote:
> > Hi,
> >
> > Static analysis with Coverity reported an issue with the following
> > commit:
> >
> > commit a52c8e2469c30cf7ac453d624aed9c168b23d1af
> > Author: Leon Romanovsky <leonro@mellanox.com>
> > Date:   Tue May 28 14:37:28 2019 +0300
> >
> >     RDMA: Clean destroy CQ in drivers do not return errors
> >
> > In function bnxt_re_destroy_cq() contains the following:
> >
> >         if (!cq->umem)
> >                 ib_umem_release(cq->umem);
>
> Given that the original test that was replaced was:
> 	if (!IS_ERR_OR_NULL(cq->umem))
>
> we aren't really worried about a null cq, just that umem is valid.  So,
> the logic is inverted on the test (or possibly we shouldn't have
> replaced !IS_ERR_OR_NULL(cq->umem) at all).

I took a very brief look and think that the better way will be to put
this "if (null)" check inside ib_umem_release() and make unconditional
call to that function in all call sites.

>
> But on closer inspection, the bnxt_re specific portion of this patch
> appears to have another problem in that it no longer checks the result
> of bnxt_qplib_destroy_cq() yet it does nothing to keep that function
> from failing.

It was intentional for two reasons. First, bnxt_re already had exactly
same logic without any checks of returned call inside bnxt_re_create_cq().
Second, we need to release kernel memory without any relation to HW state.

Maybe I should move bnxt_qplib_free_hwq() to be immediately after
bnxt_qplib_rcfw_send_message() inside of bnxt_qplib_destroy_cq()?

>
> Leon, can you send a followup fix?

Sure, I'll do it tomorrow.

>
> > Coverity detects this as a deference after null check on the null
> > pointer cq->umem:
> >
> > "var_deref_model: Passing null pointer cq->umem to ib_umem_release,
> > which dereferences it"
> >
> > Is the logic inverted on that null check?
> >
> > Colin
>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
> 2FDD
