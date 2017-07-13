From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH] Add rdma service for kernel boot support
Date: Thu, 13 Jul 2017 17:48:22 +0000
Message-ID: <1499968101.2740.10.camel@wdc.com>
References: <20170713172057.25411-1-benjamin.drung@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170713172057.25411-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Content-Language: en-US
Content-ID: <0D6C70E788409148B7EA8D22490CCA7E-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-07-13 at 19:20 +0200, Benjamin Drung wrote:
> Currently upstream does not provide a rdma or openibd service. Only the
> RedHat package ships a rdma service and rdma modules configuration
> files. The ibacm and srp_daemon services depend on the openibd service.
>=20
> Make RedHat's rdma service available to all distros by cherry-picking
> the basic files for the rdma service to run and trim them down to the
> minimum. Do not pick workarounds or other quirk that might not needed
> any more. Then replace the openibd service dependency by the rdma
> service.

Hello Benjamin,

Shouldn't the rdma / openibd service be split into multiple services -
one for IPoIB, one for the SRP initiator driver, one for the SRP target
driver, one for the iSER initiator driver, one for the iSER target driver,
one for RDS and one for NFSoRDMA? I think that would allow us to get rid
of the rdma.conf configuration file and also that this would allow systemd
to load those services concurrently that do not depend on each other.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
