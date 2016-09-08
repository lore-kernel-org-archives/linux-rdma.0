From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: RFCv3: Consolidated userspace RDMA library repo
Date: Thu, 8 Sep 2016 08:49:18 +0300
Message-ID: <20160908054918.GH18398@leon.nu>
References: <20160907040925.GA27361@obsidianresearch.com>
 <20160907062508.GA3639@leon.nu>
 <20160907154508.GA2878@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xHbokkKX1kTiQeDC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160907154508.GA2878-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <christoph-zt5rKe7wo/JBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--xHbokkKX1kTiQeDC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 07, 2016 at 09:45:08AM -0600, Jason Gunthorpe wrote:
> On Wed, Sep 07, 2016 at 09:25:08AM +0300, Leon Romanovsky wrote:
> > On Tue, Sep 06, 2016 at 10:09:25PM -0600, Jason Gunthorpe wrote:
> > > Hello Everyone,
> > >
> > > I've updated the repo, and I think we are now at the point to begin to
> > > engage the distribution packagers and collect their feedback. As Doug
> > > has suggested, there are many modifications that the distros have done
> > > that could be folded back upstream.
> > >
> > > It is available at:
> > >   https://github.com/jgunthorpe/rdma-plumbing
> >
> > The simple git pull from v2 on master fails. Do I need to clone it
> > again?
>
> The tree is still in the rebase phase, so 'git fetch --all' followed
> by 'git reset --hard origin/master' or 'git rebase -i origin/master +
> fiddling' to preserve local commits

Thanks

>
> Jason

--xHbokkKX1kTiQeDC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX0PveAAoJEORje4g2clin4vEP/1NiBWx1r+rWX6bRuYXHM05b
2zGRmUttGf3kFVbTQ3nuq7Ook4olC79WFDf5bdgS/vz97CsTujqyMsa5ARLtqmcv
vQgHaaw1d8cUqtq+W2/KfyjNvrV/5isRKTkq+Xg3/7Th+0UHF/P4+fLzTnXPUQac
vU9Cp5bPLzvlVqoqevE3FLBoj8gv1A67GwzjTQI3jGKCsRsAWuB7PsyUX7TKC1ae
UaM8HDYqDxXcHdk2NenXBoZZ4hDWjn8udbPLQ2AKnd07ReiUbr3pQj8s5wEJhjyX
1bTtB/uasIrONJqSO9yHTmlpzDxxsWtmYPw3MLkWywch51/A30wwI3N0oZlk1wm3
R8HZaMqBOUNWl9kD9CEp5Wa+Mv26N1G1mVVqEcD1O9qYkN9ElOmO7n2yty8mbPK8
YhPzsYOuEDMykyyDuOAlNYGgEvKHO9lUvzvxZ9TmhPvTo/48KMnNTM/JgCjPLJrq
yIHf/ELUWJoo1RefwhyNzYwhGeywRBZw9RYVQkmwFzCUNysop9omuCtCYAGYnGSM
pNGnUwItT49s0Zt3wXaDo2i6UsK1su1mgupJrGrW9x/5HUA6kGfTjUysWzIwcp9Q
5Q4higlu004mV+EHd1wm8IOyeTFoumI4Y/nA6DUn6wpxn4t3nEUY/Vj6/eXNWeti
98gbTapEogCsh2KX37ZG
=d0bS
-----END PGP SIGNATURE-----

--xHbokkKX1kTiQeDC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
