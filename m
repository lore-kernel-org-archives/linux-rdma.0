From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ib_isert: prevent NULL pointer dereference in
 isert_login_recv_done() (was: Re: NULL pointer dereference in
 isert_login_recv_done in 4.9.32)
Date: Mon, 26 Jun 2017 11:53:05 +0300
Message-ID: <20170626085305.GB1248@mtr-leonro.local>
References: <CAANLjFoaZ8ueEQet3Yu6LygmxXBbQ0cHUEYsb2xEON0o3N9=+w@mail.gmail.com>
 <CAANLjFp6Y8wvLvmWrk1ECjm-OoyEppxD1svNYKpg+HDEZevJig@mail.gmail.com>
 <CAANLjFoQcmfkjq9N1fehTC9Zi6aOC7ArOEPXz-he3EnOvWeEDw@mail.gmail.com>
 <20170622223757.GC28955@Dell>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="up2r7mkFEYHJ3y+X"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170622223757.GC28955@Dell>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Righi <righi.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, Sean Jenkins <sean-v0B6Y9onFlloq1w47eu9iAC/G2K4zDHf@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--up2r7mkFEYHJ3y+X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 23, 2017 at 12:37:57AM +0200, Andrea Righi wrote:
> On Wed, Jun 21, 2017 at 10:33:45AM -0600, Robert LeBlanc wrote:
> > On Wed, Jun 21, 2017 at 9:17 AM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
> > > On Tue, Jun 20, 2017 at 12:54 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
> > >> We have hit this four times today. Any ideas?
> > >>
> > >> [  169.382113] BUG: unable to handle kernel NULL pointer dereference at           (null)
> > >> [  169.382152] IP: [<ffffffffa051e968>] isert_login_recv_done+0x28/0x170 [ib_isert]
>
> So, we spent more time to track down this bug.
>
> It seems that at login time an error is happening, not sure exactly what
> kind of error, but isert_connect_error() is called and isert_conn->cm_id
> is set to NULL.
>
> Later, isert_login_recv_done() is trying to access
> isert_conn->cm_id->device and we get the NULL pointer dereference.
>
> Following there's the patch that we have applied to track down this
> problem.
>
> And this is what we see in dmesg with this patch applied:
>
>  [  658.633188] isert: isert_connect_error: conn ffff887f2209c000 error
>  [  658.633226] isert: isert_login_recv_done: login with broken rdma_cm_id
>
> As we can see isert_connect_error() is called before isert_login_recv_done
> and at that point isert_conn->cm_id is NULL.
>
> Obviously simply checking if the pointer is NULL, returning and ignoring
> the error in isert_login_recv_done() is not the best fix ever and I'm
> not sure if I'm breaking something else doing so (even if with this
> patch the kernel doesn't crash and I've not seen any problem so far).
>
> Maybe a better way is to tear down the whole connection when this
> particular case is happening? Suggestions?
>
> Thanks,
> -Andrea
>
> ---
> ib_isert: prevent NULL pointer dereference in isert_login_recv_done()
>
> During a login if an error is happening isert_connect_error() is called
> and isert_conn->cm_id is set to NULL.
>
> Later, isert_login_recv_done() is executed, trying to access
> isert_conn->cm_id->device, causing the following BUG:
>
>  [  169.382113] BUG: unable to handle kernel NULL pointer dereference at (null)
>  [  169.382152] IP: [<ffffffffa051e968>] isert_login_recv_done+0x28/0x170 [ib_isert]
>
> Check if isert_con->cm_id is set to NULL in isert_login_recv_done() to
> avoid this problem.
>
> Signed-off-by: Andrea Righi <righi.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index fcbed35..a8c1143 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -741,6 +741,7 @@ isert_connect_error(struct rdma_cm_id *cma_id)
>  {
>  	struct isert_conn *isert_conn = cma_id->qp->qp_context;
>
> +	isert_warn("conn %p error\n", isert_conn);

the same can be achieved with tracing, please don't put it.

>  	list_del_init(&isert_conn->node);
>  	isert_conn->cm_id = NULL;
>  	isert_put_conn(isert_conn);
> @@ -1452,7 +1453,13 @@ static void
>  isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc)
>  {
>  	struct isert_conn *isert_conn = wc->qp->qp_context;
> -	struct ib_device *ib_dev = isert_conn->cm_id->device;
> +struct ib_device *ib_dev;
> +
> +	if (unlikely(isert_conn->cm_id == NULL)) {

There is no need to explicitly compare with NULL. !isert_conn->cm_id
will do the trick.

Thanks

> +		isert_warn("login with broken rdma_cm_id");
> +		return;
> +	}
> +	ib_dev = isert_conn->cm_id->device;
>
>  	if (unlikely(wc->status != IB_WC_SUCCESS)) {
>  		isert_print_wc(wc, "login recv");
> --
> 2.7.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--up2r7mkFEYHJ3y+X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllQy3EACgkQ5GN7iDZy
WKfaixAAqAW/XLJSRnarmTqFrtg9HLGyRNhsUcdRcQXlFy3gca3kq819t8ZnJ8fu
RkPFwFT/cMvAiHhAByvsbfHRxOXv4UFl5089J3vaA9WlbJbRuWDMsgI4ARF51aja
oPH+Vk2AhkS3mibU2irqPIHg5DmwakuEYWYrQnSJnLPcJ5KPCITizReVwjPYi4Dr
wMT6yCO4a6e8fLJnELGxd/5usEboJiDbT/uuq5eOsXPUMydS2Dg9EsiCNDapG1aj
LSituZxbqmybEoZgZGmW+rVJXgCW9GknFGUDVq3Au966fB4u4eV5qksuMzIJ0EqS
4nZMYZonhXrYzaShOoDgTsD5KwWKxi7vM3I1CXFu0h871lCuMyi2qew4GNE5JsrF
B8tvbXXomOQ4tofYLFLE2Q1CM1LcJoI2drfqFm91hC2ItYTtYaYx+Jif98Hq6geD
BB/hvXSs3oaSUOnQQ/Dwe+nTm8XB0IYNPUZYOnJ7nrMaHLjDlkFZGnyYQXWsRIuz
CmM6SG4tSEsRh2r4v8HrcQjqb9KthZc0FBYmOFcEkYN36+RSEPT5+hoIBOAlFpic
ACwQrvmFatgtqrYMlu/m14TZmD3U3fA/XsubOfvfQ0FvQR7jwhz3BwF7GcO+fctw
xcfolqPIWakzuzhVRXHIUOPf60/G7S5ZmeRx/r5XSck+OaLt/Sc=
=jyx2
-----END PGP SIGNATURE-----

--up2r7mkFEYHJ3y+X--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
