From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: VERBOSE flags
Date: Mon, 19 Sep 2016 09:15:58 +0300
Message-ID: <20160919061558.GG3273@leon.nu>
References: <CALq1K=KfU+N87pyfjfSd=G-thpyR0mjzuuxQ8eTuqrc2Mb+yZQ@mail.gmail.com>
 <77cd1f09-fa39-6f75-6c01-c7ef18909f30@redhat.com>
 <CALq1K=+0S-YnXQo5Hvc3bdOBNuEpowdSMYJThdmHqMNwOu8z1Q@mail.gmail.com>
 <0a26585a-2e54-1c24-d212-0e2469afb8d8@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UKNXkkdQCYZ6W5l3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0a26585a-2e54-1c24-d212-0e2469afb8d8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--UKNXkkdQCYZ6W5l3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 18, 2016 at 04:35:37PM -0400, Doug Ledford wrote:
> On 9/14/2016 2:37 AM, Leon Romanovsky wrote:
> > On Wed, Sep 14, 2016 at 9:17 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >> On 9/14/2016 1:27 AM, Leon Romanovsky wrote:
> >>> Hi Doug,
> >>>
> >>> Can you please respond to my questions to this patch [1]?
> >>>
> >>> Thanks
> >>>
> >>> [1] https://patchwork.kernel.org/patch/9302591/
> >>>
> >>
> >> I don't appear to still have that email.  But I know what I came up with
> >> at the time.
> >>
> >> The debug information was in the mlx5 entry point for post_send.  That
> >> means you can create a sysfs entry that allows you to enable or disable
> >> the debugging, and then make two different mlx5 post_send entry points.
> >> When debugging is enabled, you simply change the entry point for
> >> mlx5_post_send to mlx5_post_send_debug, where mlx5_post_send_debug is
> >> essentially nothing but mlx5_post_send; dump_wqe.  The unconditional
> >> branch will be highly optimized by the CPU, so no real loss on it.  And
> >> when not in debug mode, there is zero penalty.  In short, make use of
> >> the entry pointers to make this configurable but also zero penalty on
> >> the hot path in the non-debug case.
> >
> > I did it in similar way to Intel's HFI driver and had in mind future
> > consolidation of all
> > these verbose flags for whole subsystem.
> >
> > I proposed topic (debuggability) in mini-summit to talk about it.
>
> OK, but if the hfi1 driver does this similar to what you were doing,
> then I think we should change it too.
>
> Essentially, given that all IB devices have a set of function pointers
> that are registered and stored on a per device basis, there is no reason
> that the core code can't be modified to present
> /sys/class/infiniband/debug/<list of specific entry points we wish to
> have possible debug functions for> and if the user wants to debug a
> specific entry point, they set it to 1 when it's normally 0.  Then
> drivers can optionally register debug versions of their entry points,
> and in the core if the user tries to enable debug on an entry point, and
> the driver registered a debug variant for that entry point, we start
> using it.

As a short writeup to anyone who lacks context of this thread, we are talking
about debug information in DATA paths flows. The control paths don't need
anything special and standard dynamic_debug and/or tracing infrastructure
will be enough for them.

Doug,
The function pointers will cause us to create two similar functions
(debug/regular) for every important function. It will leave to code
duplication and/or introducing of new code to fill additional fields
in returns to debug functions, so they will be able to print it.

I wanted to propose to use tracepoints to provide debug information in
data paths. The tracepoints infrastructure uses hooks in the code with
minimal impact on performance.


> Then we can drop the CONFIG_*_DEBUG options out of all of the
> drivers.  That would be my preference.  I don't want any compile time
> options because you never will be running a debug kernel when you need
> it.  Per device, run time selectable so that you get 0 overhead in the
> normal case is what I would like to see.

Great,
We are aligned on this point, so do I. I see no reason in special compiled
kernel or global module parameter to print debug prints for whole driver.

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
>




--UKNXkkdQCYZ6W5l3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX34KeAAoJEORje4g2clinuIEP/2z5AEz5wMa0FxSy5ecGY/Fc
4xinAjq1/NVA7upjDVpcKiF+ia4gigpbz4y1RKCxpytu+ONS+wN4F46Q+JdsTcEO
bEIj00j4Pjdo7PYhpeIz/7qiH2/aM5bq66X8Ov9zGihcaMdtFTsXoPrQ1llbSpMB
rrATvLcb67/E8Kkmjj6S5sDGiXzT/xc2blBH2Dvp0Gww5VzOEii75Mvl9IagLFX7
4CcR9AVQEgyatpjNOlJ+X2S4y3oeEbxQl+E7/oZI3N3MMoO+giagK+ErhT9mH4tE
tI9IX5zUFK9AgdbtKIDKzPPpkc8hGALd9kGLGwALG1g04zXO9eEHYM+AT8xVrPfm
Lkkc4UiJGrkIn+KJhFBpRF5IFHO9PX61F4cbDoUSjS/2g60IK+cZdiDofNinaxKz
BQYlx+ABgYu72DDj7geTJA4iddzLN7ZKhPzzODXvROy+3Zm6nZjx2aBkKC2Oob4W
v6pS/jaM+FpyX2OaebLpfjrTQAcGno3P4vFDkf7zwy2UJf0A9kyXJoZTpfC00M8F
wsAYJu6b9lUx+kBtEkRbq2ZRAQDn2qFel106gaAnMySU3MoGp7rsZddIx2nyCrA/
VO73OdhwwQtJYWGRA4iN1k/Ilr+VvYFMstJx///fVUDE70rcTyiRVlw2Lmy9tAYh
rdvgDIy5wqi5sW2Zh2nh
=zIPJ
-----END PGP SIGNATURE-----

--UKNXkkdQCYZ6W5l3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
