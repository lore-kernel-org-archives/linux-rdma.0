From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH iproute2-next 2/2] rdma: Print net device name and index
 for RDMA device
Date: Mon, 26 Mar 2018 19:57:50 +0300
Message-ID: <20180326165750.GJ1877@mtr-leonro.local>
References: <20180326082829.21214-1-leon@kernel.org>
 <20180326082829.21214-3-leon@kernel.org>
 <7b6f0370-4749-5327-5701-6567587d2044@gmail.com>
 <20180326150933.GI1877@mtr-leonro.local>
 <5f7e480c-dfa5-f246-cb3a-0264128640cf@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Q6STzHxy03qt/hK9"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5f7e480c-dfa5-f246-cb3a-0264128640cf@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org


--Q6STzHxy03qt/hK9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 26, 2018 at 09:44:32AM -0600, David Ahern wrote:
> On 3/26/18 9:09 AM, Leon Romanovsky wrote:
> > On Mon, Mar 26, 2018 at 08:06:52AM -0600, David Ahern wrote:
> >> On 3/26/18 2:28 AM, Leon Romanovsky wrote:
> >>> diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
> >>> index 9446a721..45474f13 100644
> >>> --- a/rdma/include/uapi/rdma/rdma_netlink.h
> >>> +++ b/rdma/include/uapi/rdma/rdma_netlink.h
> >>> @@ -388,6 +388,10 @@ enum rdma_nldev_attr {
> >>>  	RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY,	/* u32 */
> >>>  	RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY,	/* u32 */
> >>>
> >>> +	/* Netdev information for relevant protocols, like RoCE and iWARP */
> >>> +	RDMA_NLDEV_ATTR_NDEV_INDEX,		/* u32 */
> >>> +	RDMA_NLDEV_ATTR_NDEV_NAME,		/* string */
> >>> +
> >>>  	RDMA_NLDEV_ATTR_MAX
> >>>  };
> >>>  #endif /* _RDMA_NETLINK_H */
> >>
> >> Why wasn't the above included in patch 1 as part of the header file update?
> >>
> >>
> >
> > Kernel part is not accepted yet, this is why I separated them.
> >
> Please don't mix patches in a set like this. The entire set should be
> consistent -- either all of them are in the kernel or all of them are
> waiting to be committed.

Ok, I'll do.

--Q6STzHxy03qt/hK9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlq5Jo4ACgkQ5GN7iDZy
WKd0HQ/+N16s0P+I/jnEZfRMUE4b5H4W6yBZFUVUwU/PQbyRZ6hzHb9mEJuNbgVu
jpYlOds+eqicExb86xWE0zEbHbvfe+vnOsolnmhuL6mXjhhtTtaLdwzr26Hl+JTa
pe0fcd4WhNz3OAIaORmHyfCurlvkfs0INqIWJqel12dGiXH9csD/OJkEn6Xm/7n/
roo7itnUcZF0OHYBRfcpEkcoEFcUCnFvULzYDl5U2knHtRcGcotmuP4DMDQajbkJ
VdQoTpT7n/g1/hZXKR//JA0Y6PJsZk0y+dLFam9oebWpS6bV3AFPo/qJiTk4sFHs
7umSVs087XU5m/1Qq5IfNkqgBC3QCgy9HWLCkFuCzAu9LbHE3paVlFz63jFQCwJg
El4t7T76rl4NHH5hnC5G1HL0mbmLGwEx85THhnzJPI49s3NP5jNp75idadKMHjds
f2AygDx4SOVc5SxzzvSz7bZNAVYVDsLqNYXf4Xjv7nV3fdAslyN/63Nq1PfuEx/L
ijH3ed/qXU5Y2Yr6cXJA4LRVsJWvrP7suIl4lcYz9yHBj3r4gbMA2z+O/WKZ6FZ6
57AWSqybxDQdNkq9U1jiW6lwqyuC8w5VpElNFN/FydQmhKWGmyvEReVCRz3v/P1F
YaY2G30aaSKfgHH/67BZtfZWEZs+CBDrSFMll6ixnioRG1Mn3x0=
=cMi7
-----END PGP SIGNATURE-----

--Q6STzHxy03qt/hK9--
