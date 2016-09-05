From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Mon, 5 Sep 2016 08:29:29 +0300
Message-ID: <20160905052929.GU21847@leon.nu>
References: <004e01d20203$156edc30$404c9490$@opengridcomputing.com>
 <20160829161902.GB23557@obsidianresearch.com>
 <20160830060842.GJ594@leon.nu>
 <20160830071716.GA3098@infradead.org>
 <20160830073521.GM594@leon.nu>
 <20160830163033.GC26778@obsidianresearch.com>
 <4b791de5-0d6e-fd94-8a31-2fe833ca72db@grimberg.me>
 <20160904083517.GN21847@leon.nu>
 <a220db98-ebbf-5df4-e011-8804442796b8@grimberg.me>
 <280b8620-0996-a9bc-dc93-bf5d710dd6de@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="O7hm+SMpb/lu0d4d"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <280b8620-0996-a9bc-dc93-bf5d710dd6de-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--O7hm+SMpb/lu0d4d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 04, 2016 at 05:40:48PM -0400, Doug Ledford wrote:
> On 9/4/2016 6:36 AM, Sagi Grimberg wrote:
> >
> >>> What I think it missing is a release schedule, stable fixes
> >>> methodology and merge cycles. I think once we can agree on that
> >>> a lot of the concerns will be addressed.
> >>
> >> This is exactly my point.
> >> What do you think if we follow kernel release cycles and schedules? It
> >> will give to everyone in RDMA world clear answer on WHEN question.
> >
> > That can work. But, I think that we need the stable fixes to be released
> > more frequently (Ideally on-demand, but it might be too much of an
> > overhead both to maintainers and users).
>
> I don't think so.  A regular release cadence to match the kernel, and on
> demand hot fixes seems perfectly doable to me.

It is a good starting point and in addition to releases we would like to
see the same fast piece of accepting new code into vendor specific
user space drivers. It is hard to get rid of feelings for possible long
submission queues.

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
>




--O7hm+SMpb/lu0d4d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXzQK5AAoJEORje4g2clino7YP/1JBcz7msES55/m/R5ihSSNB
bSeJXj7nHUdmJpgnIOrpkPDkP0hb6lroCO3y9CA/Ep+5LqBkzA7r6882NeZjGrTI
6X6zLB/dwpfCAFJ5xTNMLHlF0Zv9+5IE1LMCnT9XmrHeDdkuH9vojTSJ4LvPex15
Inv+09+lM/LYkcv9RquDiYkwh4fdEQgGBiokfYVyhEjbfRGJVLkuva5FPsrux0kN
jZFHa5hPtNvFWlVq6fLVjc/Xu0YYOzl5MDuJxhfBvMTv8/Kx5/+lCMCEs+VVyFM9
3yKnkUYTz65kmL5AU+PzJ8rFFakkbaTGad4m1AqYzkGKeUWi0r2UdM5iTAM0bgkV
feWP/6cq+C76xUr3sxWC3QVgkGWEFL5LWJqBvyfhghDqzl4NpKYbtLl+CBgvRo/M
b15MAv8xdBnw7f1UWGD9XbJG2cTkap/m0BX6wHb/JmeW7zovKdOIIKpQbJoSA7mr
gPicJ1tPlwl4CojXyEEZytET5V7wHkNIfPCHCbnkHXZpUo1ECu5bfevwAGKQQcXo
VxeLrGcn5bgGxqUpALgWfM45feea0yoSJBLUJCfIQeXsqdAwak0doQDwfMaa9LbM
nsRuQ/ESTfaJka7IRXd5tQnwEtHfLwy/t77stgPnHed9Gt/YBfgkX3rq/WxpNSNv
eNvhG4P0gLyY4/5zQqe2
=nC4t
-----END PGP SIGNATURE-----

--O7hm+SMpb/lu0d4d--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
