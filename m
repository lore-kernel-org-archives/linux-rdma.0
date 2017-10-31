From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Computer issues...
Date: Tue, 31 Oct 2017 17:13:02 +0200
Message-ID: <20171031151302.GJ16127@mtr-leonro.local>
References: <CA+mK3=-v-nMb-cRO2hGEmirxbNnRuW-OZWGC8d+sUoTcxKmt7w@mail.gmail.com>
 <1509363152.2295.5.camel@redhat.com>
 <5b0fbfd7-6747-da76-91a9-3fa4dc173bb0@redhat.com>
 <d6ab43f7-9698-7164-441b-02c1f5560abd@redhat.com>
 <CAKkHt7W_Cv_qGRs_R3zn6_PaXd7xAE0+D_Qghn7KUq+bzRHHjg@mail.gmail.com>
 <f3a0d17b-1a5c-b97c-e544-5b4524e71424@redhat.com>
 <783cf656-3cd7-c40d-48cf-a749f022a161@redhat.com>
 <e4fc7d4e-5295-caf9-be5b-6ac5a57a5d2d@redhat.com>
 <36640bfe-850b-a857-1cc9-58939ac50946@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xKAOFH8xvSgM/GoA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <36640bfe-850b-a857-1cc9-58939ac50946-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--xKAOFH8xvSgM/GoA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 31, 2017 at 10:32:03AM -0400, Doug Ledford wrote:
> My primary computer had a sudden failure yesterday. I was working, I
> turned around to grab something, and the whole thing just powered down
> while I was looking away. I tried everything to power it back up, but
> nothing worked.  However, it wasn't *completely* dead because two LEDs
> on the motherboard came on, just nothing else. So, I started to pull it
> apart and do some investigation. I pulled another power supply and
> plugged just the motherboard into it, and viola, it came up. So, I guess
> the 12v rail on my other power supply died. I went to Best Buy to buy a
> new power supply (the one I tested with really wasn't big enough for
> this machine), bring it back home, and got to work replacing the entire
> power supply.
>
> I happen to always buy fully modular power supplies if I can, so I was
> in the process of swapping things out, and I didn't realize I had
> plugged a Corsair modular SATA power cable in the SATA connector on the
> new power supply and ran it to the bank of 4 SSDs I have in my main
> computer.  Until I powered the new EVGA power supply and immediately
> heard some odd crackling followed by the unmistakable smell of magic
> smoke (quite strong I might add).  So, moral of this story is, while the
> EVGA and Corsair modular connectors for SATA power cables use identical
> physical connectors and will happily plug in on each other's power
> supplies, how they wire them up most definitely is *not* identical, and
> all four SSDs that were plugged into that modular SATA power cable are
> now toast.  This includes my primary workstation and all data that was
> on it.  Fortunately, I keep backups and what not, but I am currently
> sending this email from my laptop and I will likely loose the next day
> to two days to the task of reinstalling from scratch, then restoring
> from backup (even as I write this, my laptop is writing a Fedora 27 Beta
> USB boot key).  Joy!

Hi Doug,

Thank you for keeping us in the loop, as far as I can see there are no -rc
material except this one: https://patchwork.kernel.org/patch/10032391/

This patch is extremely important to forward to Linus in this cycle,
before -rc is closed, because NLDEV was added in v4.14 merge window.

Will it be OK from you side if I forward this to Linus immediately?

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>
>
>




--xKAOFH8xvSgM/GoA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln4kv4ACgkQ5GN7iDZy
WKdUuBAAy8k//ktFIMOiVUh0vwgRxN1DuPP6q4DK3l9eeChISiq69z7HFqVfhbst
fwqtGgkJ0R4jSsqagddkvPL/a4kpLrkZemGewVItz3L0xVSc1+TJOJsY8Y/nqMJk
75Ui25/59PdJ+q3/uN73yO0iOrXKTHQzXM9/Rmi3y7b9a57pN/Hw0EeAQDInR5zs
6S2GwbWwbAVl0H9DqRudEO6iTnWiLKKWU8efb3yrlBR/EQ3DO1STSoGz+JdFbgNy
nVKDke/Xx3djUWMqrV57yYjBFHXPr/aoX+TlKltehm7m2t1osRRjA43Bz/SY/CMu
qY9/DpDyEVKMEhQcSOfCanzMkb06MaoRbDKzkeq57qu8j0/2aE4xhqmTQtbRI9Lx
JDuB+liTUPM58NLKhJbygZfKvDQepq63XLY2QxmefRH9Sfh3Smx/9Agztf7e7imV
t0qPQF2hHbMFOzaCbVCi7vRJayzBl+sKf+ESiZaxy6L8PQS4UYzKUAMV8nzl5ndR
9QkzJSlJTw3qrTWwQc7TwIx9Nv6/R2WhxFFq9qYYcz+M0LiOWe1YYJ93IvyePkp1
NsDy78XxwxH8x0mIERTPdveYBulTgqM6NoXqykwnu7LuSdEeJt+p1OWShbGCfQ3e
0ljdrNJZolkBfrm/y9OVz399Et1RoxYCZnF9YnAvhMlj2sU4RqE=
=dZSV
-----END PGP SIGNATURE-----

--xKAOFH8xvSgM/GoA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
