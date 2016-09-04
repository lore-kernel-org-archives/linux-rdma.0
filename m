From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 3/9] Revert "IB/mlx4: Return EAGAIN for any error
 in mlx4_ib_poll_one"
Date: Sun, 4 Sep 2016 09:14:12 +0300
Message-ID: <20160904061412.GJ21847@leon.nu>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
 <1472371118-8260-4-git-send-email-leon@kernel.org>
 <20160828171758.GA11719@obsidianresearch.com>
 <20160828182613.GP594@leon.nu>
 <20160828182813.GB12783@obsidianresearch.com>
 <20160828183500.GQ594@leon.nu>
 <aa325795-a120-6dee-a102-6aaa903be617@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OX2aLCKeO1apYW07"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <aa325795-a120-6dee-a102-6aaa903be617-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--OX2aLCKeO1apYW07
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 02, 2016 at 02:03:13PM -0400, Doug Ledford wrote:
> On 8/28/2016 2:35 PM, Leon Romanovsky wrote:
> > On Sun, Aug 28, 2016 at 12:28:13PM -0600, Jason Gunthorpe wrote:
> >> On Sun, Aug 28, 2016 at 09:26:13PM +0300, Leon Romanovsky wrote:
> >>> On Sun, Aug 28, 2016 at 11:17:58AM -0600, Jason Gunthorpe wrote:
> >>>> On Sun, Aug 28, 2016 at 10:58:32AM +0300, Leon Romanovsky wrote:
> >>>>> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>>>>
> >>>>> By Mellanox HW design and SW implementation poll_cq never
> >>>>> fails and returns errors, so all these prints are to catch ULP bugs.
> >>>>
> >>>> Eh? How can a ULP cause poll_cq to get errors?
> >>>>
> >>>> Are you sure these are not driver bugs?
> >>>>
> >>>> Why can't you just print and discard the broken CQ entry?
> >>>>
> >>>> What should use ULP do when it get EINVAL? You say poll again is
> >>>> not correct, so you suggest a full QP tear down?
> >>>
> >>> See patches 4 and 6, they completely removed these EINVALs.
> >>
> >> So the commit message is still wrong.
> >>
> >> Why do we need this revert? Just squash it and mark it fixup the
> >> original.
> >
> > We need this revert, because the original commit is wrong and as was presented
> > by Sasha Levin in his talk about automatic creation of stable trees [1], he needs
> > this information to ensure that this commit won't be in stable tree by mistake.
> >
> > [1]
> > https://lcccna2016.sched.org/event/7JW4/automating-the-creation-of-stable-trees-sasha-levin-verizon-labs
>
> I didn't see the presentation at this link, but I'm not sure I agree
> with your statement here.  There should be no difference, effectively,
> between a commit to revert a bad commit, and a commit to fix a bad
> commit that uses a Fixes: tag referencing the original commit.

The final code will look the same, but it will be much easier for the
tools to pickup them.

>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
>




--OX2aLCKeO1apYW07
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXy7u0AAoJEORje4g2clin2YwQAMMtkHuVGSHd5yOa8yQOHZVc
QU9vYqNOn+k1c8qimd8m5AdfFKyQhXf7vsioS+JY7bXjCileq8X7pkVGTXZoaVla
Uq6pD2hNrAEmR1p1+6qRoVM/hL7qLZvsEqghTAwEajki0dxxfFP3WOlUyzUwOawU
XOJPK1QTxjO5bvNCy8npW21/4zugKs1yKdL+9an7lAHZhwiKwXt+Zxk6iczOPvO8
JAN89LC8/aZpmTImw7ZdJIvdG+yVxjRba0zAbL6ZU5H6jD9BAs+8E61VMVPv4yRx
CkG3+H/3SY0FNTVCngEQ61qiI6DCKi5xNy6yZd1+aa/oxmlYzp/zfhL5mUpx66p1
v/Gz10vtwxaZB0jUOnE1zdrNMtha/+MJZ8GAkKpg4hGAwVzuEq2WcVDUrGF77Rk/
rFST5x0fuOuGDISc8Uq+SIm0Rb3jVmsTzXe1/ZcEvJG75pDvwRJv/UI076wxJH7G
mEbFrw6ldkOrmLI9onyj8opHmUP+9Yka85fbB0du67hG+rtJkVirr8qBlqw/AC+k
iKumv+jNvq3sbzu2zKweDUZnnUNamDOkLT3TbwA/H1zhG4B1t5iMf3eIjkCUPAGa
oKzgUtePOXc7Oe9s+R6z+NPO55oMKfrh91CjeTxNZT0RjgVhQ2rhVb8sisdNIQra
pdkceKtrd0/eM7X5/QcX
=hqYh
-----END PGP SIGNATURE-----

--OX2aLCKeO1apYW07--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
