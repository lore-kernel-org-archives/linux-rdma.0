From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] ib_srpt: use kvmalloc to allocate ring pointers
Date: Tue, 10 Jul 2018 08:39:44 +0300
Message-ID: <20180710053944.GN3014@mtr-leonro.mtl.com>
References: <1531144268-25361-1-git-send-email-jan.dakinevich@virtuozzo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0OOz7ZB592LYQf07"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1531144268-25361-1-git-send-email-jan.dakinevich@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Bart Van Assche <bart.vanassche@wdc.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Denis Lunev <den@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org


--0OOz7ZB592LYQf07
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 09, 2018 at 04:51:08PM +0300, Jan Dakinevich wrote:
> An array of pointers to SRPT contexts in ib_device is over 30KiB even
> in default case, in which an amount of contexts is 4095. The patch
> is intended to weed out large contigous allocation for non-DMA memory.

kvmalloc* doesn't "weed out" large contiguous allocations, but tries to
allocate them and gracefully fallback to vmalloc if kmalloc fails.

More on that, for allocations less than page (64KB for PowerPC), it will
not call to vmalloc at all, which is fine too, because pages granularity.

If you want to get rid of "contiguous allocations", use vmalloc instead.

Thanks

>
> Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 3081c62..de167af 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -720,7 +720,7 @@ static struct srpt_ioctx **srpt_alloc_ioctx_ring(struct srpt_device *sdev,
>  	WARN_ON(ioctx_size != sizeof(struct srpt_recv_ioctx)
>  		&& ioctx_size != sizeof(struct srpt_send_ioctx));
>
> -	ring = kmalloc_array(ring_size, sizeof(ring[0]), GFP_KERNEL);
> +	ring = kvmalloc_array(ring_size, sizeof(ring[0]), GFP_KERNEL);
>  	if (!ring)
>  		goto out;
>  	for (i = 0; i < ring_size; ++i) {
> @@ -734,7 +734,7 @@ static struct srpt_ioctx **srpt_alloc_ioctx_ring(struct srpt_device *sdev,
>  err:
>  	while (--i >= 0)
>  		srpt_free_ioctx(sdev, ring[i], dma_size, dir);
> -	kfree(ring);
> +	kvfree(ring);
>  	ring = NULL;
>  out:
>  	return ring;
> @@ -759,7 +759,7 @@ static void srpt_free_ioctx_ring(struct srpt_ioctx **ioctx_ring,
>
>  	for (i = 0; i < ring_size; ++i)
>  		srpt_free_ioctx(sdev, ioctx_ring[i], dma_size, dir);
> -	kfree(ioctx_ring);
> +	kvfree(ioctx_ring);
>  }
>
>  /**
> --
> 2.1.4
>

--0OOz7ZB592LYQf07
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbREagAAoJEORje4g2clinc8MP/jEJQeruV+X+Af8kW/TU/Jps
GF1fuPUL+XTh47Zr6BHbCAspjcHn853TS43o4IQOJFMaCWHfkxBAxx0Qf9dm/FfR
xrwFmtBdOu5nvMfNG6LAQ9j1RmpsAi+wSii3xZJRgwM3uc7kYHYlkmm+y6fGALKL
ceQS9bhhI1m9CHTR+u61p5hTesxr3s8fY2mUoYh6vmCEh2RWgPMvUF9U/Gq5u3br
D9GAhYXd63K2OxIS1C1K9I6+5h6rpFuar/jQgrC1yrWqfOvalnjZCytiIEX1Mz2E
T2urRf6v/h5RZFCHGkm/ke0XIug9Vig/T58d1Byj6h7tBtwq+kXiue2EHCIKh1UT
D4T1EbwP24i+64SzYcABz5eLMIATLp6vgEtbP9HeS5HykgE01ct+4d6RT0r0V1Fe
MyDTpg7Kl3sU4nTF4EV8ZAnG9EvRcu2ZIjb0YqDQ1BbGmPTUjUrZvfU9o8f75Pyf
qlitI0cig2N2QzfCY12wkDP/SxEBRGaOXaAVhNvnthIQ2uHjBWvRf4lL3dK99qz2
bq8/mF+SQBqnTHVAI+3Xxh8GQahEDk6T1+nkpa6U7PMaQNEZTqC28IKN5TefI0nD
GpguPEmBraFCxdeHfVRKPf7pGKrmlAVXp4txyBTEf28vFlt0XhvUD3ZMgCsd9pu2
YMviGhO3eGg28Gnw53Mb
=Z3p4
-----END PGP SIGNATURE-----

--0OOz7ZB592LYQf07--
