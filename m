From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Mon, 5 Sep 2016 15:48:02 +0300
Message-ID: <20160905124802.GX21847@leon.nu>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <4f0876ce-f3c9-83e3-d0ef-0c5656ce9462@grimberg.me>
 <53eb35b4-0320-acd9-9969-73f5817c8144@sandisk.com>
 <20160901172355.GA20472@obsidianresearch.com>
 <019b01d2047f$b9694f90$2c3beeb0$@opengridcomputing.com>
 <20160902233231.GA26309@obsidianresearch.com>
 <ef8214f8-d44d-2289-d1ed-a0998e9e05c0@sandisk.com>
 <20160903051222.GA2098@obsidianresearch.com>
 <20160904055441.GI21847@leon.nu>
 <20160904235555.GA21542@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XUd+PsnCfaVdInSg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160904235555.GA21542-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--XUd+PsnCfaVdInSg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 04, 2016 at 05:55:55PM -0600, Jason Gunthorpe wrote:
> On Sun, Sep 04, 2016 at 08:54:41AM +0300, Leon Romanovsky wrote:
> > On Fri, Sep 02, 2016 at 11:12:22PM -0600, Jason Gunthorpe wrote:
> > > On Fri, Sep 02, 2016 at 05:10:45PM -0700, Bart Van Assche wrote:
> > >
> > > So I added opensuse 13.2 and 42.1 to the list of docker container
> > > builders and the simple build looks like it runs OK.
> >
> > Are you running standard docker containers or build them by yourself?
> > Can you add scripts to run containers to your rdma-plumbers repo? So it
> > will be much easier to see/debug build issues on different platforms.
>
> I mentioned this in my first email, but here is more details.
>
> The tooling branch contains all the scripting I used to build and test
> this thing. The docker/ directory has all the docker files and the
> script to run them.
>
> https://github.com/jgunthorpe/rdma-plumbing/tree/tooling/docker
>
> The docker script is something I've used for awhile in other places,
> there are others around as well that are similar.. The basic usage is
> like this:
>
> # Download docker base images and run all docker files
> # Do once.
> $ docker/do_docker.py build-images --env all
>
> # Run 'make' inside the container using the current source tree
> # exactly as is. Directs the build to a build-fc24 output directory
> $ docker/do_docker.py make fc24
>
> # Build a package. This runs 'git archive', imports the archive into
> # the container, transfers the spec file, fusses with the container,
> # runs rpmbuild/dpkg-buildpkg, then copies the rpms back out. Note
> # that changes must be checked in to have any impact.
> $ docker/do_docker.py pkg fc24
>
> Folks can decide how much of this stuff should go on into the main
> repository later on..

I completely missed that tooling branch. It looks like it misses the
Debian image.

Thanks

>
> Jason

--XUd+PsnCfaVdInSg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXzWmCAAoJEORje4g2clinoCUP/AqqhAvPEBxYZckOnzlXrHmb
pZ8EyOOAItnBdPzbEvZEKegrciUs1HQiyy0i+nFVcNmMllCtGAiHX4IRfC+iOict
SQhHi3HYSf1lLNIWqE9L0yQub7odimK0cge0EhGVR+exmz6XzXnpZOd7akfTXysL
Lq1UTTW1qDM6i7Vpcsg0kTuLK4xqKI090xwrBrMV3GCfpPSdUU+9ciTQMPYyzHWc
WubN7k6NCENiNWHP9o5vYFOhoX8BSYdMofpXMyj32xEMeqMjRSsy6XNVp3KKgbBE
is3Ey2ZYt9YLT5GK0xSe9LcnemFx0+3cKc2WbsaIUhZTgBISipvbaUQQBczOyeIX
ts6CpKtEggrsXHaWN17hiYg62EtUQEcLTPALzsm8SAZPP3sbzHJeECKkkRe3jWIQ
3geWWPW9KT8sAamrKM4HqTrootlhDL9KtKGxApTewuLlL4C+X8FzvPgVLl1VkCCo
mMqNCCeJ8grMYMPFJzeapAIQVNcP6oBBZUqB0iWX2EwojaNgFs7HIWQpIWVhVcIl
vk2P+lZ0Z7sP21HV6W9CEkjxTK4Gb82Z2zCntZ3S7XRU+bNt1mIZgR9hzQlMd5Pi
wb2OMGyAH6wn4DfVF9hUrID3pwbptWNs89N/WtbFyYCsFM/jQd3RufRHHBlgUUMT
bYuNR1OT28LG5C4vRbpA
=umpf
-----END PGP SIGNATURE-----

--XUd+PsnCfaVdInSg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
