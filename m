From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Drain the send queue before destroying a QP
Date: Sun, 12 Feb 2017 19:19:28 +0200
Message-ID: <20170212171928.GF14015@mtr-leonro.local>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com>
 <20170210235611.3243-9-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="m1UC1K4AOz1Ywdkx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170210235611.3243-9-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--m1UC1K4AOz1Ywdkx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 10, 2017 at 03:56:11PM -0800, Bart Van Assche wrote:
> A quote from the IB spec:
>
> However, if the Consumer does not wait for the Affiliated Asynchronous
> Last WQE Reached Event, then WQE and Data Segment leakage may occur.
> Therefore, it is good programming practice to tear down a QP that is
> associated with an SRQ by using the following process:
> * Put the QP in the Error State;
> * wait for the Affiliated Asynchronous Last WQE Reached Event;
> * either:
>   * drain the CQ by invoking the Poll CQ verb and either wait for CQ
>     to be empty or the number of Poll CQ operations has exceeded CQ
>     capacity size; or
>   * post another WR that completes on the same CQ and wait for this WR to return as a WC;
> * and then invoke a Destroy QP or Reset QP.
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 2f85255d2aca..b50733910f7e 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -471,9 +471,13 @@ static struct srp_fr_pool *srp_alloc_fr_pool(struct srp_target_port *target)
>   * completion handler can access the queue pair while it is
>   * being destroyed.
>   */
> -static void srp_destroy_qp(struct ib_qp *qp)
> +static void srp_destroy_qp(struct srp_rdma_ch *ch, struct ib_qp *qp)
>  {
> -	ib_drain_rq(qp);
> +	spin_lock_irq(&ch->lock);
> +	ib_process_cq_direct(ch->send_cq, -1);

I see that you are already using "-1" in your code, but the comments in the
ib_process_cq_direct states that no new code should use "-1".

 61  * Note: for compatibility reasons -1 can be passed in %budget for unlimited
 62  * polling.  Do not use this feature in new code, it will be removed soon.
 63  */
 64 int ib_process_cq_direct(struct ib_cq *cq, int budget)

Thanks

--m1UC1K4AOz1Ywdkx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAligmSAACgkQ5GN7iDZy
WKfAOg//eTjYBONpXZjS+YTHUSJwjlEn+xTS5ar4aVRoq39ie22scSjLmS0HU7Ht
03QXG9PK9b3vHGWRfbLCynXsQMcQzhvLLvgG0c2MB6yrViB0b6y5uZPNNnsJzSH9
8bHEAqQmF3yTYXbWX7yfYZ07sDY9YTYq9W15dZM0vNATAc40dBCOHXCg28IomV2y
VDdHI/wWOGZ4+8gLq3K73pr/AJqq9kdf2hOYndcoe/DP9lv39llny6utAJqOTySk
xGfaJ+NwCOAGdAPdXUeY7gxsPDsi3xXDsHhsWLZe5Q7t9zqYrqDUHjuwHDeYbdiP
2TzlLoOMXkry10Lesvz6zsDn2noY98xKrh7YwhLYs5LbUn5vlTpTcdZz4NLBGCQ9
VxLz48NLxQ5xum2NSs+buH+t6dOkdKzMVNi2At+0isGej3y/ns2JyqB93wMBt/s/
Yc6cmlJlZ8NIYwQyXt3LxO228SYSxR3jAHHrBUpyoN8keC0hEl/HVi1AKX0jo/d+
gQRVkE8rDIe08+YMVVi0tz//t8mGHYQJpa/8S0GIirhZpLEM5wxnvH0gE8Uitlg3
EN1yTwEX0XKImeIuMLunEIbwhE9uwYItk6ddxmVH3H+FQt2dd6SrkwhkiBJTFgXU
HH4vRaO9Hx8ER63c0VWG1ongkknA/80oJMuhm4oCdyDkDitrbJM=
=Ka/M
-----END PGP SIGNATURE-----

--m1UC1K4AOz1Ywdkx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
