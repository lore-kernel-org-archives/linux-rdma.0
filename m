From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2 2/8] IB/srp: Avoid that duplicate responses trigger a
 kernel bug
Date: Wed, 15 Feb 2017 09:22:48 +0200
Message-ID: <20170215072248.GO6989@mtr-leonro.local>
References: <20170214185636.29250-1-bart.vanassche@sandisk.com>
 <20170214185636.29250-3-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nrXiCraHbXeog9mY"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170214185636.29250-3-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Laurence Oberman <loberman@redhat.com>, Steve Feeley <Steve.Feeley@sandisk.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--nrXiCraHbXeog9mY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 14, 2017 at 10:56:30AM -0800, Bart Van Assche wrote:
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
> RIP: srp_recv_done+0x450/0x6b0 [ib_srp] RSP: ffff88046f483e20
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Israel Rukshin <israelr@mellanox.com>
> Cc: Max Gurtovoy <maxg@mellanox.com>
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: Steve Feeley <Steve.Feeley@sandisk.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--nrXiCraHbXeog9mY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlikAcgACgkQ5GN7iDZy
WKd7rQ/8CFvxhWwSPgww0y+Eb4dBc56lDd0lYKClbOjU2mvX7Wd/F1GgZ7nSk5fd
FX+vt5Fl655Q8IkefdFLH0VS1IHux6zeKRtULAYv2DCGJ7vzeDiD4/kgYngQd25X
DVxCN1XlqC1cpZT0IxK4dDuTYUjnw85SJ56fcnp8J8OjsgyzxxY1j6Da50KjKNUU
XxJHy9mMxk/aWFcVqaewC6Qg6A87RLlYkn7cpsG4JvPY2Vtop6388UysiKutswUj
W1DDHTGS4ofGNAxaDyKTIFnz4UtGsRI5Vt7Zzz2MoDkJGorC88q7wEa3X1XBIaD3
zS35o4WQNzjxomkyy77yoDg+IeisF2rZJURe94nJsCxDoNKHSQt65Hrkp9cDcAYG
AbhKex+Esr18yPECXipyAFhQPyZyVFLrt8xLotnf+Ck8ALTqKDG8lz/D9iPr3ALa
b+/2l8LnpypbUtrdEr6sluLtoOOMKZPkO5gnNmmVun3PA3JMsKoFVb+EXA+KKcZk
HkbMe5S6NhgWDdK7mawRu5+2OJF/fJAIvGQ3vR0A4nq+cscGGb4Jjf5llCfNi6q+
WKBxQ7cHXyTifGjNjvhYg1fAAIprpqbfF6zsnhKqiX0CiLO2Dcke0Ay5ten1zlPQ
npflg06z5O8CRO2aGx7EyQoStTb/fIwu7VEzkrg76LyCi7WS+FM=
=6Qb7
-----END PGP SIGNATURE-----

--nrXiCraHbXeog9mY--
