From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 0/4] Sockperf: Initial multi-threaded throughput
 client
Date: Wed, 20 Dec 2017 10:52:39 +0200
Message-ID: <20171220085239.GP2942@mtr-leonro.local>
References: <cover.1513609601.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kaF1vgn83Aa7CiXN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1513609601.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--kaF1vgn83Aa7CiXN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 18, 2017 at 10:26:42AM -0500, Doug Ledford wrote:
> During testing, it has become painfully clear that a single threaded UDP
> test client can not exercise a 100Gig link due to issues related to
> single core maximum throughput.  This patchset implements a
> multi-threaded throughput test in sockperf.  This is just an initial
> implementation, there is still more work to be done.  In particular:
>
> 1) Although the speed improved with this change, it did not improve
> drastically.  As soon as the client send bottleneck was removed, it
> became clear there is another bottleneck on the server.  When sending to
> a server from one client, all data is received on a single queue pair,
> and due to how interrupts are spread in the RDMA stack (namely that each
> queue pair goes to a single interrupt and we rely on multiple queue
> pairs being in use to balance interrupts across different cores), we
> take all interrupts from a specific host on a single core and the
> receiving side then becomes the bottleneck with single core IPoIB
> receive processing being the limiting factor.  On a slower machine, I
> clocked 30GBit/s throughput.  On a faster machine as the server, I was
> able to get up to 70GBit/s throughput.
>
> 2) I thought I might try an experiment to get around the queue pair is
> on one CPU issue.  We use P_Keys in our internal lab setup, and so on
> the specific link in question, I actually have a total of three
> different IP interfaces on different P_Keys.  I tried to open tests on
> multiple of these interfaces to see how that would impact performance
> (so a multithreaded server listening on ports on three different P_Key
> interfaces all on the same physical link, which should use three
> different queue pairs, and a multithreaded client sending to those three
> different P_Key interfaces from three different P_Key interfaces of its
> own).  It tanked it.  Like less than gigabit ethernet speeds.  This
> warrants some investigation moving forward I think.
>
> 3) I thought I might try sending from two clients to the server at once
> and summing their throughput.  That was fun.  With UDP the clients are
> able to send enough data that flow control on the link kicks in, at
> which point each client starts dropping packets on the floor (they're
> UDP after all), and so the net result is that one client claimed
> 200GBit/s and the other about 175GBit/s.  Meanwhile, the server thought
> we were just kidding and didn't actually run a test at all.
>
> 4) I reran the test using TCP instead of UDP.  That's a non-starter.
> Whether due to my changes, or just because it is the way it is, the TCP
> tests all failed.  For larger message sizes, they failed instantly.  For
> smaller message sizes the test might run for a few seconds, but would
> eventually fail too.  Always the failure was that the server would get a
> message it deemed too large and would forcibly close all of the TCP
> connections, at which point the client just bails.
>
> I should point out that I don't program C++.  Issues with me not doing
> these patches in a C++ typical manner are related to that.
>

Doug,

I contacted the group which is responsible for the development of sockperf
https://github.com/Mellanox/sockperf

Their maintainer is on vacation till third week of January and unluckily
there are no other people right now who can take a look onto your proposal.

In meanwhile, it is better to push the code to github, because their
development flow is based on github and not on mailing list.

Thanks

--kaF1vgn83Aa7CiXN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo6JNcACgkQ5GN7iDZy
WKfniw//bdeUOykm7AU3vu/REOkhq3T/vDDoIetMRV8LnSHovSX2TX+c7V7lsnOP
QvThDqoNAOH+T0fFFxFcdzm37/IWAL1HOyi0tWf6AXMf9jqK2YySGSw3HmfmxxRR
8Gqm+8fSq1tejxBSbRdVHxFzvS3+fMiUwpF5/qyzNfkvJ/oAPPWwx+syAZnUjdnx
c5JrAxCaFO1vgy+PPZejkzKbQ1lmADBzxltc/goMpzg4Mey5KJtmfBIEnaKUBI+f
CyXvB8iEcyA3TEr8Xl5RlvfQVKBdnB8/Z6tdOgFvOB7VJyJV5gJRqSWumObdz2GX
IoHnsyp0dJ2xVIsegCqpfmr+vSrY624GpsqzofSen7NcdkcuA/EDgEbXR1FApbh7
DEX847EzRLBVRbyQDX6YBVFqD19WkRIPpDRt4RWP/zRDhsMk5FC35QVXOL/pRsfn
HDZl2Mwc/MVmT49mBD49+kUM7aqaYVDv+YSrX74YVE2ObGrElpMEBBYcYa7WtGYz
Eecjyl/CYvsYDrThkPCrkc/rdhksAdnVTN9ePElguA1KdifvFVNb6P1VfiS1ckak
ZUav1sw4IEtxYeX4I2UAyUw8G/JBqQvaUd2dMOmUTSh9Ow4C1WyebbSHj8wYp+QU
LHvUWszMjlhRpOKjc3zScCY3wT9pvQVW7w8TsAvFf0RtNuZ+csQ=
=D2P1
-----END PGP SIGNATURE-----

--kaF1vgn83Aa7CiXN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
