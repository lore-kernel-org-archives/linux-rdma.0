From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 1/8] IB/srp: Avoid that duplicate responses trigger a
 kernel bug
Date: Sun, 12 Feb 2017 19:05:37 +0200
Message-ID: <20170212170537.GE14015@mtr-leonro.local>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com>
 <20170210235611.3243-2-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="C94crkcyjafcjHxo"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170210235611.3243-2-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Laurence Oberman <loberman@redhat.com>, Steve Feeley <Steve.Feeley@sandisk.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--C94crkcyjafcjHxo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 10, 2017 at 03:56:04PM -0800, Bart Van Assche wrote:
> After srp_process_rsp() returns there is a short time during which
> the scsi_host_find_tag() call will return a pointer to the SCSI
> command that is being completed. If during that time a duplicate
> response is received, avoid that the following call stack appears:
>
> BUG: unable to handle kernel NULL pointer dereference at           (null)
> IP: srp_recv_done+0x450/0x6b0 [ib_srp]
> Oops: 0000 [#1] SMP
> CPU: 10 PID: 0 Comm: swapper/10 Not tainted 4.10.0-rc7-dbg+ #1
> Call Trace:
>  <IRQ>
>  __ib_process_cq+0x4b/0xd0 [ib_core]
>  ib_poll_handler+0x1d/0x70 [ib_core]
>  irq_poll_softirq+0xba/0x120
>  __do_softirq+0xba/0x4c0
>  irq_exit+0xbe/0xd0
>  smp_apic_timer_interrupt+0x38/0x50
>  apic_timer_interrupt+0x90/0xa0
>  </IRQ>
>  cpuidle_enter_state+0xf2/0x370
>  cpuidle_enter+0x12/0x20
>  call_cpuidle+0x1e/0x40
>  do_idle+0xe3/0x1c0
>  cpu_startup_entry+0x18/0x20
>  start_secondary+0x103/0x130
>  start_cpu+0x14/0x14
> RIP: srp_recv_done+0x450/0x6b0 [ib_srp] RSP: ffff88046f483e20
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Israel Rukshin <israelr@mellanox.com>
> Cc: Max Gurtovoy <maxg@mellanox.com>
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: Steve Feeley <Steve.Feeley@sandisk.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 79bf48477ddb..4068d34f5427 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1899,7 +1899,14 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
>  		scmnd = scsi_host_find_tag(target->scsi_host, rsp->tag);
>  		if (scmnd) {
>  			req = (void *)scmnd->host_scribble;
> -			scmnd = srp_claim_req(ch, req, NULL, scmnd);
> +			if (req) {
> +				scmnd = srp_claim_req(ch, req, NULL, scmnd);
> +			} else {
> +				shost_printk(KERN_ERR, target->scsi_host,
> +					     "NULL host_scribble for response with tag %#llx\n",
> +					     rsp->tag);
> +				scmnd = NULL;
> +			}
>  		}
>  		if (!scmnd) {
>  			shost_printk(KERN_ERR, target->scsi_host,

You have the chance to print the message below together with your new
print, because scmd will be NULL.

What about to do the following check "if (scmd && scmd->host_scribble)"
instead of your proposed patch?

Thanks

> --
> 2.11.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--C94crkcyjafcjHxo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAligleEACgkQ5GN7iDZy
WKcvxxAAuMJk8Yt0jLoG4/HzROXzrZOaG8IzhX7dbG+XfBNbQcHkWLpaefj587CY
zx040S3wyuEO1a3Kfle/6f6wNb39ErMb8BrhGZWj9CMiZsqAC180WeDIS5bTZ7PO
T43T1hhuThQP3XbYAaqMa3tDt5R54bAFU0XDZ4kUmQB7NdrtxalEldFZjmY/IDmB
mCNBS/+oTI5UNyvybdtoPDHPfDmK7eqp9z9NNo1+f0RBon1FTN9gZ5CY4CPRRR8x
Jxl6TB8s83UOiy9a9Tpy8VT2muNXdPzTb9W/W6JMg000gJliGk+iSooClu3PPeh3
Nr4FQI3GmnLfWAMzfwmoHcCKeF0TQ+NA60p8/xBqRkofzqMuF2PclPKa+m58usAj
6PXdomciaDbNVEUh8/7lQsEjVVyQDChgqB8aJexSPRIhhD0Hn+29kFToGPpSF6uU
/1Od0s2wiKr+FMqZYfgwBRS213uHrB5VT5Kw3Sifz6czbum6gcmqERFPruRrVGyi
NjQf7IkaW/HNIjksb3E6rHPAxJL6nRS2m1RdZFCwCD8AUbDXZS3Jaw1+7xjBTK/U
UtdVYis9E9hFbSQm6T4em0V7KYnoFUlrLtAnikpxDI3edmQijyJyjE9SsIU50ha8
1T4JGJ2CGeq4mmK4tChJ+Nx+5d4KTRB8EDsyaoNCMynk6p/Hxug=
=10+x
-----END PGP SIGNATURE-----

--C94crkcyjafcjHxo--
